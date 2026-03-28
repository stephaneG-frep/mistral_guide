import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController   = TextEditingController();
  final ScrollController      _scrollController = ScrollController();

  String _apiKey    = '';
  bool   _isLoading = false;

  bool get _showKeySetup => _apiKey.isEmpty;

  final List<_Msg> _display = [];
  final List<Map<String, String>> _history = [];

  static const _model     = 'mistral-large-latest';
  static const _maxTokens = 2048;
  static const _prefKey   = 'mistral_api_key';
  static const _storage   = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadKey() async {
    final saved = await _storage.read(key: _prefKey) ?? '';
    setState(() => _apiKey = saved);
  }

  Future<void> _saveKey(String key) async {
    await _storage.write(key: _prefKey, value: key.trim());
    setState(() => _apiKey = key.trim());
  }

  Future<void> _deleteKey() async {
    await _storage.delete(key: _prefKey);
    setState(() {
      _apiKey = '';
      _display.clear();
      _history.clear();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    _inputController.clear();

    setState(() {
      _display.add(_Msg(role: 'user', content: text));
      _display.add(_Msg(role: 'assistant', content: '', isTyping: true));
      _isLoading = true;
    });
    _history.add({'role': 'user', 'content': text});
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('https://api.mistral.ai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'max_tokens': _maxTokens,
          'messages': [
            {
              'role': 'system',
              'content': 'Tu es Mistral, un assistant IA développé par Mistral AI. '
                  'Tu réponds de façon claire, concise et utile.',
            },
            ..._history,
          ],
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['choices'][0]['message']['content'] as String;
        _history.add({'role': 'assistant', 'content': reply});

        setState(() {
          _display.removeLast();
          _display.add(_Msg(role: 'assistant', content: reply));
          _isLoading = false;
        });
      } else {
        final err = jsonDecode(response.body);
        final errMsg = err['message'] ?? 'Erreur ${response.statusCode}';
        _history.removeLast();
        setState(() {
          _display.removeLast();
          _display.add(_Msg(role: 'error', content: errMsg));
          _isLoading = false;
        });
      }
    } catch (e) {
      _history.removeLast();
      setState(() {
        _display.removeLast();
        _display.add(_Msg(role: 'error', content: 'Erreur réseau : $e'));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, _) {
        if (_showKeySetup) return _buildKeySetup(context);
        return _buildChat(context);
      },
    );
  }

  // ─── Écran saisie clé API ────────────────────────────────────────────────

  Widget _buildKeySetup(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: context.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.chat_bubble_outline, size: 36, color: Colors.white),
                SizedBox(height: 12),
                Text('Chatbot Mistral',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('Entre ta clé API Mistral pour discuter avec Mistral Large',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Clé API Mistral',
              style: TextStyle(color: context.accentLight, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _keyController,
            obscureText: true,
            style: TextStyle(
              color: context.isLight ? const Color(0xFF3E2000) : Colors.white,
              fontFamily: 'monospace',
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: 'Votre clé API Mistral...',
              hintStyle: TextStyle(
                color: context.isLight
                    ? const Color(0xFF3E2000).withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.3),
              ),
              filled: true,
              fillColor: context.cardBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.primary.withValues(alpha: 0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.primary.withValues(alpha: 0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.accentMid, width: 1.5),
              ),
              prefixIcon: Icon(Icons.key_outlined, color: context.accentMid, size: 20),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_keyController.text.trim().isNotEmpty) {
                  _saveKey(_keyController.text);
                }
              },
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Valider'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.tipBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.tipBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: context.accentLight, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Clé disponible sur console.mistral.ai\nStockée localement sur ton appareil.',
                    style: TextStyle(color: context.tipText, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Écran chat ──────────────────────────────────────────────────────────

  Widget _buildChat(BuildContext context) {
    final barBg = context.isLight ? const Color(0xFFFFE0B2) : const Color(0xFF2A1A08);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          color: barBg,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: context.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 12, color: context.accentLight),
                    const SizedBox(width: 4),
                    Text(_model,
                        style: TextStyle(
                          color: context.accentLight,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        )),
                  ],
                ),
              ),
              const Spacer(),
              if (_display.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() {
                    _display.clear();
                    _history.clear();
                  }),
                  child: Icon(Icons.refresh, size: 18,
                      color: context.isLight
                          ? const Color(0xFF8D6030)
                          : Colors.white.withValues(alpha: 0.4)),
                ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _showDeleteKeyDialog(context),
                child: Icon(Icons.key_off_outlined, size: 18,
                    color: context.isLight
                        ? const Color(0xFF8D6030)
                        : Colors.white.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),

        Expanded(
          child: _display.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: _display.length,
                  itemBuilder: (context, index) => _buildMessage(context, _display[index]),
                ),
        ),

        _buildInput(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 56, color: context.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text('Pose ta question à Mistral',
              style: TextStyle(
                color: context.isLight
                    ? const Color(0xFF8D6030)
                    : Colors.white.withValues(alpha: 0.5),
                fontSize: 15,
              )),
          const SizedBox(height: 6),
          Text('Modèle : $_model',
              style: TextStyle(
                color: context.isLight
                    ? const Color(0xFF8D6030).withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.25),
                fontSize: 12,
              )),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context, _Msg msg) {
    final isUser  = msg.role == 'user';
    final isError = msg.role == 'error';

    Color bubbleBg;
    Color textColor;
    if (isUser) {
      bubbleBg  = context.primary;
      textColor = Colors.white;
    } else if (isError) {
      bubbleBg  = context.isLight ? const Color(0xFFFFCDD2) : const Color(0xFF4A1010);
      textColor = const Color(0xFFD32F2F);
    } else {
      bubbleBg  = context.cardBg;
      textColor = context.isLight ? const Color(0xFF3E2000) : const Color(0xFFE0E0E0);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: BoxDecoration(
                color: isError ? const Color(0xFFD32F2F) : context.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isError ? Icons.error_outline : Icons.auto_awesome,
                size: 15, color: Colors.white,
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(16),
                  topRight:    const Radius.circular(16),
                  bottomLeft:  Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4  : 16),
                ),
                border: isUser ? null : Border.all(
                  color: isError
                      ? const Color(0xFFD32F2F).withValues(alpha: 0.4)
                      : context.primary.withValues(alpha: 0.2),
                ),
              ),
              child: msg.isTyping
                  ? _TypingIndicator(color: context.accentLight)
                  : SelectableText(
                      msg.content,
                      style: TextStyle(color: textColor, fontSize: 14, height: 1.55),
                    ),
            ),
          ),
          if (isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    final inputBg = context.isLight ? const Color(0xFFFFE0B2) : const Color(0xFF2A1A08);
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).viewInsets.bottom + 12),
      decoration: BoxDecoration(
        color: inputBg,
        border: Border(top: BorderSide(color: context.primary.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              style: TextStyle(
                color: context.isLight ? const Color(0xFF3E2000) : Colors.white,
                fontSize: 14,
              ),
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Message…',
                hintStyle: TextStyle(
                  color: context.isLight
                      ? const Color(0xFF3E2000).withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.3),
                ),
                filled: true,
                fillColor: context.cardBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isLoading
                    ? context.primary.withValues(alpha: 0.4)
                    : context.primary,
                shape: BoxShape.circle,
              ),
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.accentLight,
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteKeyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.cardBg,
        title: Text('Changer de clé API',
            style: TextStyle(
              color: context.isLight ? const Color(0xFF3E2000) : Colors.white,
            )),
        content: Text('La conversation sera effacée.',
            style: TextStyle(color: context.tipText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: TextStyle(color: context.accentMid)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteKey();
            },
            child: const Text('Supprimer', style: TextStyle(color: Color(0xFFEF5350))),
          ),
        ],
      ),
    );
  }
}

// ─── Modèle message ──────────────────────────────────────────────────────────

class _Msg {
  final String role;
  final String content;
  final bool isTyping;
  _Msg({required this.role, required this.content, this.isTyping = false});
}

// ─── Indicateur typing ────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  final Color color;
  const _TypingIndicator({required this.color});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
            final opacity = (0.3 + 0.7 * (phase < 0.5 ? phase * 2 : (1 - phase) * 2)).clamp(0.3, 1.0);
            return Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
