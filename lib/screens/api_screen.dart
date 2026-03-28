import 'package:flutter/material.dart';
import '../app_theme.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, _) => Column(
        children: [
          Container(
            color: context.isLight ? const Color(0xFFFFE0B2) : const Color(0xFF2A1A08),
            child: TabBar(
              controller: _tabController,
              indicatorColor: context.accentMid,
              labelColor: context.accentLight,
              unselectedLabelColor: const Color(0xFF546E7A),
              tabs: const [Tab(text: 'Python'), Tab(text: 'JavaScript'), Tab(text: 'Dart')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [_PythonExamples(), _JsExamples(), _DartExamples()],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Python ──────────────────────────────────────────────────────────────────
class _PythonExamples extends StatelessWidget {
  const _PythonExamples();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Appel simple', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''from mistralai import Mistral

client = Mistral(api_key="ta-clé-mistral")

res = client.chat.complete(
    model="mistral-large-latest",
    messages=[
        {"role": "user", "content": "Bonjour Mistral !"}
    ]
)

print(res.choices[0].message.content)'''),
          const SizedBox(height: 20),
          _sectionLabel('Avec contexte système', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''res = client.chat.complete(
    model="mistral-large-latest",
    messages=[
        {"role": "system", "content": "Tu es un expert en Python."},
        {"role": "user", "content": "Explique les décorateurs"}
    ]
)'''),
          const SizedBox(height: 20),
          _sectionLabel('Streaming', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''stream = client.chat.stream(
    model="mistral-large-latest",
    messages=[{"role": "user", "content": "Raconte une histoire"}],
)

for chunk in stream:
    delta = chunk.data.choices[0].delta.content
    if delta:
        print(delta, end="", flush=True)'''),
          const SizedBox(height: 20),
          _sectionLabel('Embeddings', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''res = client.embeddings.create(
    model="mistral-embed",
    inputs=["Texte à vectoriser", "Autre texte"]
)

vector = res.data[0].embedding
print(f"Dimension : {len(vector)}")  # 1024'''),
          const SizedBox(height: 20),
          _sectionLabel('Tool Use (Fonctions)', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''tools = [{
    "type": "function",
    "function": {
        "name": "get_weather",
        "description": "Retourne la météo",
        "parameters": {
            "type": "object",
            "properties": {
                "location": {"type": "string"}
            },
            "required": ["location"]
        }
    }
}]

res = client.chat.complete(
    model="mistral-large-latest",
    messages=[{"role": "user", "content": "Météo à Paris ?"}],
    tools=tools,
    tool_choice="auto",
)'''),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── JavaScript ──────────────────────────────────────────────────────────────
class _JsExamples extends StatelessWidget {
  const _JsExamples();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Appel simple', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''import Mistral from "@mistralai/mistralai";

const client = new Mistral({
  apiKey: "ta-clé-mistral",
});

const res = await client.chat.complete({
  model: "mistral-large-latest",
  messages: [
    { role: "user", content: "Bonjour Mistral !" }
  ],
});

console.log(res.choices[0].message.content);'''),
          const SizedBox(height: 20),
          _sectionLabel('Streaming', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''const stream = client.chat.stream({
  model: "mistral-large-latest",
  messages: [{ role: "user", content: "Raconte..." }],
});

for await (const chunk of stream) {
  const delta = chunk.data.choices[0].delta.content;
  if (delta) process.stdout.write(delta);
}'''),
          const SizedBox(height: 20),
          _sectionLabel('Avec outils (tools)', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''const res = await client.chat.complete({
  model: "mistral-large-latest",
  messages: [{ role: "user", content: "Météo à Paris ?" }],
  tools: [{
    type: "function",
    function: {
      name: "get_weather",
      description: "Retourne la météo",
      parameters: {
        type: "object",
        properties: {
          location: { type: "string" }
        },
        required: ["location"]
      }
    }
  }],
  toolChoice: "auto",
});'''),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Dart ─────────────────────────────────────────────────────────────────────
class _DartExamples extends StatelessWidget {
  const _DartExamples();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Appel HTTP direct', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> askMistral(String question) async {
  final response = await http.post(
    Uri.parse('https://api.mistral.ai/v1/chat/completions'),
    headers: {
      'Authorization': 'Bearer \$apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': 'mistral-large-latest',
      'messages': [
        {'role': 'user', 'content': question}
      ],
    }),
  );

  final data = jsonDecode(response.body);
  return data['choices'][0]['message']['content'];
}'''),
          const SizedBox(height: 20),
          _sectionLabel('Intégration Flutter Widget', context),
          const SizedBox(height: 8),
          CodeBlock(code: '''class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  String _response = '';
  bool _loading = false;

  Future<void> _sendMessage(String msg) async {
    setState(() => _loading = true);
    final result = await askMistral(msg);
    setState(() {
      _response = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_loading) const CircularProgressIndicator(),
        Text(_response),
        ElevatedButton(
          onPressed: () => _sendMessage("Bonjour !"),
          child: const Text("Envoyer"),
        ),
      ],
    );
  }
}'''),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Widgets partagés ────────────────────────────────────────────────────────
Widget _sectionLabel(String text, BuildContext context) => Text(
      text,
      style: TextStyle(color: context.accentLight, fontSize: 14, fontWeight: FontWeight.w600),
    );

