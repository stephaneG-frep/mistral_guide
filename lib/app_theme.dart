import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final themeNotifier = ValueNotifier<AppTheme>(AppTheme.darkOrange);

enum AppTheme { darkOrange, lightOrange }

extension AppThemeExt on BuildContext {
  bool get isLight => themeNotifier.value == AppTheme.lightOrange;

  Color get primary     => Theme.of(this).colorScheme.primary;
  Color get secondary   => Theme.of(this).colorScheme.secondary;

  Color get cardBg      => isLight ? const Color(0xFFFFF3E0) : const Color(0xFF2A1A08);
  Color get codeBg      => isLight ? const Color(0xFFFFE0B2) : const Color(0xFF1A0E04);
  Color get codeHeader  => isLight ? const Color(0xFFFFCC80) : const Color(0xFF2E1A06);
  Color get accentLight => isLight ? const Color(0xFFE65100) : const Color(0xFFFFB74D);
  Color get accentMid   => isLight ? const Color(0xFFBF360C) : const Color(0xFFFF8C00);
  Color get surfaceBg   => isLight ? const Color(0xFFFFF8F0) : const Color(0xFF1C1108);

  Color get codeText    => isLight ? const Color(0xFF4E2600) : const Color(0xFFFFCC80);
  Color get codeBorder  => isLight ? const Color(0xFFFFB74D) : const Color(0xFF5D3A1A);

  Color get tipBg       => isLight ? const Color(0xFFFFF3E0) : const Color(0xFF2E1A06);
  Color get tipBorder   => isLight ? const Color(0xFFFFCC80) : const Color(0xFF5D3A1A);
  Color get tipText     => isLight ? const Color(0xFF6D4C41) : const Color(0xFFD7A87A);

  Color get drawerDivider => isLight ? const Color(0xFFFFCC80) : const Color(0xFF4A2E10);

  List<Color> get heroGradient => isLight
      ? [const Color(0xFFE65100), const Color(0xFFFF6D00), const Color(0xFFFF8C00)]
      : [const Color(0xFF7C3000), const Color(0xFFBF5A00), const Color(0xFFE07000)];

  List<Color> get palette => isLight
      ? [
          const Color(0xFFE65100),
          const Color(0xFFBF360C),
          const Color(0xFFFF6D00),
          const Color(0xFFFF8C00),
          const Color(0xFFF57C00),
          const Color(0xFFE64A19),
        ]
      : [
          const Color(0xFFFFB74D),
          const Color(0xFFFF8C00),
          const Color(0xFFFFCC80),
          const Color(0xFFFF6D00),
          const Color(0xFFF4A261),
          const Color(0xFFFFAB40),
        ];
}

Widget sectionTitle(String text, BuildContext context) => Text(
      text,
      style: TextStyle(
        color: context.accentLight,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );

class CodeBlock extends StatelessWidget {
  final String code;
  final String? title;

  const CodeBlock({required this.code, this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.codeBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SelectableText(
              code,
              style: TextStyle(
                color: context.codeText,
                fontFamily: 'monospace',
                fontSize: title != null ? 13 : 12,
                height: title != null ? 1.6 : 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    void onCopy() {
      Clipboard.setData(ClipboardData(text: code));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Copié !'),
        backgroundColor: context.primary,
        duration: const Duration(seconds: 1),
      ));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: context.codeHeader,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: title != null
          ? Row(
              children: [
                Icon(Icons.terminal, size: 14, color: context.accentMid),
                const SizedBox(width: 6),
                Text(title!, style: TextStyle(color: context.accentLight, fontSize: 12)),
                const Spacer(),
                GestureDetector(
                  onTap: onCopy,
                  child: const Icon(Icons.copy, size: 14, color: Color(0xFF546E7A)),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onCopy,
                  child: Row(
                    children: [
                      Icon(Icons.copy, size: 14, color: context.accentMid.withValues(alpha: 0.7)),
                      const SizedBox(width: 4),
                      Text(
                        'Copier',
                        style: TextStyle(
                            color: context.accentMid.withValues(alpha: 0.7), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
