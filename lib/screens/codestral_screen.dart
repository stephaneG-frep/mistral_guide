import 'package:flutter/material.dart';
import '../app_theme.dart';

class CodestralScreen extends StatefulWidget {
  const CodestralScreen({super.key});
  @override
  State<CodestralScreen> createState() => _CodestralScreenState();
}

class _CodestralScreenState extends State<CodestralScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) => Column(
        children: [
          Container(
            color: context.cardBg,
            child: TabBar(
              controller: _tab,
              labelColor: context.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              indicatorColor: context.primary,
              tabs: const [
                Tab(text: 'Codestral'),
                Tab(text: 'Local & Ollama'),
                Tab(text: 'Fine-tuning'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _CodestralTab(),
                _LocalTab(),
                _FineTuningTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab 1 : Codestral ───────────────────────────────────────────────────────

class _CodestralTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.primary;
    final c2 = context.secondary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Codestral — Modèle de code', context),
        _InfoCard(
          icon: Icons.code,
          color: c,
          title: 'Qu\'est-ce que Codestral ?',
          body: 'Codestral est le modèle de génération de code de Mistral AI. '
              'Avec 22 milliards de paramètres, il supporte 80+ langages '
              'et excelle dans la complétion, la génération et l\'explication de code. '
              'Sa fenêtre de contexte de 32K tokens permet de traiter des fichiers entiers.',
        ),
        const SizedBox(height: 8),
        sectionTitle('Modèles de code disponibles', context),
        _ModelCard(color: c,  name: 'codestral-latest',     ctx: '32K',  note: 'Complétion & génération — recommandé'),
        _ModelCard(color: c2, name: 'codestral-mamba',      ctx: '256K', note: 'Architecture SSM, contexte très long'),
        _ModelCard(color: c,  name: 'mistral-large-latest', ctx: '128K', note: 'General purpose + code avancé'),
        const SizedBox(height: 8),
        sectionTitle('Utilisation via API', context),
        _StepCard(
          step: 1,
          color: c,
          title: 'Installation',
          child: const CodeBlock(code: 'pip install mistralai'),
        ),
        _StepCard(
          step: 2,
          color: c,
          title: 'Génération de code — Python',
          child: const CodeBlock(
            code: 'from mistralai import Mistral\n\n'
                'client = Mistral(api_key="votre_cle_mistral")\n\n'
                'response = client.chat.complete(\n'
                '  model="codestral-latest",\n'
                '  messages=[{\n'
                '    "role": "user",\n'
                '    "content": "Écris une fonction Python de tri rapide"\n'
                '  }]\n'
                ')\nprint(response.choices[0].message.content)',
          ),
        ),
        _StepCard(
          step: 3,
          color: c,
          title: 'Fill-in-the-Middle (FIM)',
          child: const CodeBlock(
            code: '# Complétion au milieu d\'un fichier\nresponse = client.fim.complete(\n'
                '  model="codestral-latest",\n'
                '  prompt="def fibonacci(n):\\n    ",\n'
                '  suffix="\\n    return result"\n'
                ')\nprint(response.choices[0].message.content)',
          ),
        ),
        const SizedBox(height: 8),
        sectionTitle('Langages supportés', context),
        _InfoCard(
          icon: Icons.bar_chart_outlined,
          color: c2,
          title: '80+ langages de programmation',
          body: null,
          child: Wrap(
            spacing: 6, runSpacing: 6,
            children: [
              'Python', 'JavaScript', 'TypeScript', 'Go', 'Rust',
              'C++', 'Java', 'Swift', 'Kotlin', 'SQL',
              'Dart', 'Ruby', 'PHP', 'Bash', 'C#', '80+ autres',
            ].map((lang) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: c2.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: c2.withValues(alpha: 0.3)),
              ),
              child: Text(lang, style: TextStyle(color: c2, fontSize: 12, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Tab 2 : Local & Ollama ──────────────────────────────────────────────────

class _LocalTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.primary;
    final c2 = context.secondary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Mistral en local avec Ollama', context),
        _InfoCard(
          icon: Icons.computer_outlined,
          color: c,
          title: 'Pourquoi utiliser Mistral en local ?',
          body: 'Les modèles Mistral sont open source et optimisés pour '
              'l\'exécution locale. Avec Ollama, exécutez Mistral 7B ou Mixtral '
              'sur votre machine sans coût d\'API et avec une confidentialité totale.',
        ),
        const SizedBox(height: 8),
        sectionTitle('Installation Ollama', context),
        _StepCard(
          step: 1,
          color: c,
          title: 'Installer Ollama',
          child: const CodeBlock(
            code: '# macOS / Linux\ncurl -fsSL https://ollama.com/install.sh | sh\n\n'
                '# Windows : télécharger sur ollama.com',
          ),
        ),
        _StepCard(
          step: 2,
          color: c,
          title: 'Télécharger un modèle Mistral',
          child: const CodeBlock(
            code: '# Mistral 7B — ~4 GB\nollama pull mistral\n\n'
                '# Mixtral 8x7B — ~26 GB\nollama pull mixtral\n\n'
                '# Mistral Nemo — ~7 GB\nollama pull mistral-nemo\n\n'
                '# Codestral\nollama pull codestral',
          ),
        ),
        _StepCard(
          step: 3,
          color: c,
          title: 'Utiliser en mode interactif',
          child: const CodeBlock(
            code: 'ollama run mistral\n\n'
                '# API locale (compatible OpenAI)\ncurl http://localhost:11434/v1/chat/completions \\\n'
                '  -H "Content-Type: application/json" \\\n'
                '  -d \'{"model":"mistral","messages":[{"role":"user","content":"Bonjour"}]}\'',
          ),
        ),
        const SizedBox(height: 8),
        sectionTitle('Recommandations RAM', context),
        _InfoCard(
          icon: Icons.memory_outlined,
          color: c2,
          title: 'Quel modèle pour votre machine ?',
          body: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ramRow(context, c2, 'mistral 7B',     '8 Go',  'Usage quotidien, très bon rapport qualité'),
              _ramRow(context, c2, 'mistral-nemo',   '8 Go',  '12B params, meilleur que 7B'),
              _ramRow(context, c2, 'mixtral 8x7B',   '32 Go', 'MoE, performances de niveau 70B'),
              _ramRow(context, c2, 'mistral-large',  '64 Go', 'Performances maximales locales'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        sectionTitle('LM Studio — Interface graphique', context),
        _InfoCard(
          icon: Icons.window_rounded,
          color: c,
          title: 'Alternative à Ollama avec GUI',
          body: 'LM Studio offre une interface graphique pour télécharger '
              'et exécuter les modèles Mistral localement. '
              'Idéal pour les utilisateurs qui préfèrent éviter la ligne de commande.',
          child: const CodeBlock(code: '# Téléchargement : lmstudio.ai\n# Windows, macOS, Linux'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _ramRow(BuildContext ctx, Color c, String model, String ram, String note) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(children: [
          Container(width: 10, height: 10,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          SizedBox(width: 80,
              child: Text(model, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600))),
          SizedBox(width: 52,
              child: Text(ram, style: TextStyle(color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12))),
          Expanded(child: Text(note,
              style: TextStyle(color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.55), fontSize: 11))),
        ]),
      );
}

// ── Tab 3 : Fine-tuning ─────────────────────────────────────────────────────

class _FineTuningTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.primary;
    final c2 = context.secondary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Fine-tuning avec Mistral', context),
        _InfoCard(
          icon: Icons.tune_outlined,
          color: c,
          title: 'Pourquoi fine-tuner ?',
          body: 'Le fine-tuning adapte un modèle Mistral à votre domaine spécifique '
              '(médical, juridique, support client...) avec vos propres données. '
              'Il améliore la précision, le ton et le format des réponses '
              'sans nécessiter de RAG complexe.',
        ),
        const SizedBox(height: 8),
        sectionTitle('Fine-tuning via La Plateforme', context),
        _StepCard(
          step: 1,
          color: c,
          title: 'Préparer le dataset (format JSONL)',
          child: const CodeBlock(
            code: '// dataset.jsonl — une ligne par exemple\n'
                '{"messages": [{"role": "user", "content": "Quel est le délai de livraison ?"},\n'
                '  {"role": "assistant", "content": "Notre délai standard est de 3-5 jours ouvrés."}]}\n'
                '{"messages": [{"role": "user", "content": "Comment retourner un article ?"},\n'
                '  {"role": "assistant", "content": "Vous avez 30 jours pour retourner un article."}]}',
          ),
        ),
        _StepCard(
          step: 2,
          color: c,
          title: 'Uploader et lancer le fine-tuning',
          child: const CodeBlock(
            code: 'from mistralai import Mistral\n\n'
                'client = Mistral(api_key="votre_cle")\n\n'
                '# Upload du dataset\nwith open("dataset.jsonl", "rb") as f:\n'
                '    uploaded = client.files.upload(file=("dataset.jsonl", f))\n\n'
                '# Lancer le fine-tuning\njob = client.fine_tuning.jobs.create(\n'
                '  model="open-mistral-7b",\n'
                '  training_files=[{"file_id": uploaded.id, "weight": 1}],\n'
                '  hyperparameters={"training_steps": 100, "learning_rate": 0.0001}\n'
                ')\nprint(f"Job ID: {job.id}")',
          ),
        ),
        _StepCard(
          step: 3,
          color: c,
          title: 'Utiliser le modèle fine-tuné',
          child: const CodeBlock(
            code: '# Attendre la fin du job\nimport time\nwhile job.status != "SUCCESS":\n'
                '    job = client.fine_tuning.jobs.retrieve(job.id)\n'
                '    time.sleep(10)\n\n'
                '# Utiliser le modèle\nresponse = client.chat.complete(\n'
                '  model=job.fine_tuned_model,  # ID du modèle fine-tuné\n'
                '  messages=[{"role": "user", "content": "Délai de livraison ?"}]\n'
                ')',
          ),
        ),
        const SizedBox(height: 8),
        sectionTitle('Modèles fine-tunables', context),
        _InfoCard(
          icon: Icons.check_circle_outline,
          color: c2,
          title: 'Modèles disponibles pour le fine-tuning',
          body: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tip(context, c2, 'open-mistral-7b — rapide et économique'),
              _tip(context, c2, 'open-mixtral-8x7b — meilleures performances'),
              _tip(context, c2, 'mistral-small-latest — bon équilibre'),
              _tip(context, c2, 'codestral-latest — spécialisé code'),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _tip(BuildContext ctx, Color c, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.arrow_right, color: c, size: 18),
          const SizedBox(width: 4),
          Expanded(child: Text(text,
              style: TextStyle(color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.75), fontSize: 13))),
        ]),
      );
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? body;
  final Widget? child;

  const _InfoCard({required this.icon, required this.color, required this.title, required this.body, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 36, height: 36,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14))),
        ]),
        if (body != null) ...[
          const SizedBox(height: 10),
          Text(body!, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8), fontSize: 13, height: 1.5)),
        ],
        if (child != null) ...[const SizedBox(height: 10), child!],
      ]),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final Color color;
  final String name;
  final String ctx;
  final String note;

  const _ModelCard({required this.color, required this.name, required this.ctx, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(child: Text(name, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12, fontFamily: 'monospace'))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
          child: Text(ctx, style: TextStyle(color: color, fontSize: 10)),
        ),
        const SizedBox(width: 8),
        Flexible(child: Text(note, textAlign: TextAlign.right,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55), fontSize: 11))),
      ]),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int step;
  final Color color;
  final String title;
  final Widget child;

  const _StepCard({required this.step, required this.color, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 28, height: 28,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Center(child: Text('$step',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          child,
        ])),
      ]),
    );
  }
}
