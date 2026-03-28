import 'package:flutter/material.dart';
import '../app_theme.dart';

class InstallationScreen extends StatelessWidget {
  const InstallationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('SDK Python (mistralai)', context),
          const SizedBox(height: 10),
          _StepCard(step: '1', title: 'Installer le SDK',
              content: 'Installe le client officiel Python de Mistral AI.'),
          const SizedBox(height: 8),
          CodeBlock(title: 'Installation pip', code: 'pip install mistralai'),
          const SizedBox(height: 16),
          _StepCard(step: '2', title: 'Configurer la clé API',
              content: 'Obtiens ta clé sur console.mistral.ai et définis la variable d\'environnement.'),
          const SizedBox(height: 8),
          CodeBlock(
              title: 'Variable d\'environnement',
              code: 'export MISTRAL_API_KEY="ta-clé-ici"'),
          const SizedBox(height: 16),
          _StepCard(step: '3', title: 'Premier appel',
              content: 'Teste ton installation avec un appel simple.'),
          const SizedBox(height: 8),
          CodeBlock(
              title: 'Test rapide',
              code: 'from mistralai import Mistral\n\nclient = Mistral(api_key="...")\nres = client.chat.complete(\n    model="mistral-large-latest",\n    messages=[{"role":"user","content":"Bonjour !"}]\n)\nprint(res.choices[0].message.content)'),
          const SizedBox(height: 24),

          sectionTitle('SDK JavaScript / TypeScript', context),
          const SizedBox(height: 10),
          CodeBlock(title: 'Installation npm', code: 'npm install @mistralai/mistralai'),
          const SizedBox(height: 8),
          CodeBlock(
              title: 'Variable d\'environnement',
              code: 'export MISTRAL_API_KEY="ta-clé-ici"'),
          const SizedBox(height: 24),

          sectionTitle('SDK Dart / Flutter', context),
          const SizedBox(height: 10),
          CodeBlock(title: 'pubspec.yaml', code: 'dependencies:\n  http: ^1.2.0\n  flutter_secure_storage: ^9.2.2'),
          const SizedBox(height: 8),
          CodeBlock(
              title: 'Appel HTTP Mistral',
              code: 'final response = await http.post(\n  Uri.parse("https://api.mistral.ai/v1/chat/completions"),\n  headers: {\n    "Authorization": "Bearer \$apiKey",\n    "Content-Type": "application/json",\n  },\n  body: jsonEncode({...}),\n);'),
          const SizedBox(height: 24),

          sectionTitle('cURL', context),
          const SizedBox(height: 10),
          CodeBlock(
              title: 'Test API direct',
              code: 'curl https://api.mistral.ai/v1/chat/completions \\\n  -H "Authorization: Bearer \$MISTRAL_API_KEY" \\\n  -H "Content-Type: application/json" \\\n  -d \'{"model":"mistral-large-latest","messages":[{"role":"user","content":"Bonjour"}]}\''),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.tipBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.tipBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.tips_and_updates_outlined, color: context.accentLight, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Obtiens ta clé API sur console.mistral.ai\nOffer gratuite disponible pour débuter.',
                    style: TextStyle(color: context.tipText, fontSize: 13, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String content;
  const _StepCard({required this.step, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: context.primary, shape: BoxShape.circle),
          child: Center(
            child: Text(step,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    color: context.isLight ? const Color(0xFF3E2000) : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
              const SizedBox(height: 3),
              Text(content,
                  style: TextStyle(
                    color: context.isLight ? const Color(0xFF8D6030) : const Color(0xFF90A4AE),
                    fontSize: 13,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

