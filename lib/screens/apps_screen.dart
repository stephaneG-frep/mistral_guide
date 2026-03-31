import 'package:flutter/material.dart';
import '../app_theme.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  static final _apps = [
    _App(
      icon: Icons.chat_bubble_rounded,
      title: 'Le Chat — Application officielle',
      category: 'Officiel Mistral',
      description:
          'L\'interface web officielle de Mistral AI pour discuter avec les modèles '
          'Mistral Large, Mistral Small et Codestral. Accès gratuit avec Mistral Small, '
          'abonnement Pro pour les modèles avancés et la génération de code.',
      tips: [
        'Accès : chat.mistral.ai',
        'Gratuit : Mistral Small disponible sans inscription',
        'Pro (14.99€/mois) : Mistral Large + Codestral',
        'Mode Canvas pour l\'édition collaborative de documents',
        'Disponible aussi en app mobile iOS et Android',
      ],
    ),
    _App(
      icon: Icons.cloud_outlined,
      title: 'La Plateforme — API officielle',
      category: 'Développement',
      description:
          'Console développeur de Mistral AI pour gérer les clés API, '
          'surveiller la consommation et accéder à tous les modèles. '
          'Fine-tuning, batch API et accès aux modèles open-weight.',
      tips: [
        'Accès : console.mistral.ai',
        'Créez votre clé API dans "API Keys"',
        'Tableau de bord de consommation en temps réel',
        'Lancement de jobs de fine-tuning supervisé',
        'Batch API pour les traitements massifs (50% de réduction)',
      ],
    ),
    _App(
      icon: Icons.code_rounded,
      title: 'Codestral — Assistant code',
      category: 'Développement',
      description:
          'Modèle spécialisé pour la génération et complétion de code. '
          'Supporte 80+ langages de programmation avec une fenêtre de contexte '
          'de 32K tokens. Disponible via API et intégrations IDE.',
      tips: [
        'Endpoint dédié : codestral.mistral.ai',
        'FIM (Fill-in-the-Middle) pour la complétion inline',
        'Intégration VS Code via Continue.dev ou Copilot-style plugins',
        'Intégration JetBrains, Vim/Neovim, Emacs disponibles',
        'Gratuit pendant la bêta via clé API La Plateforme',
      ],
    ),
    _App(
      icon: Icons.extension_outlined,
      title: 'Continue.dev avec Mistral',
      category: 'Développement',
      description:
          'Extension VS Code open source configurée avec l\'API Mistral. '
          'Utilisez Codestral pour l\'autocomplétion et Mistral Large '
          'pour le chat dans votre éditeur à un coût compétitif.',
      tips: [
        'Extension VS Code : "Continue" dans le marketplace',
        'config.json → provider: "mistral", model: "codestral-latest"',
        'FIM natif pour la complétion de code inline',
        'Open source : github.com/continuedev/continue',
        'Raccourci : Cmd/Ctrl+I pour ouvrir le chat',
      ],
    ),
    _App(
      icon: Icons.download_outlined,
      title: 'Ollama — Modèles locaux',
      category: 'Local / Privé',
      description:
          'Exécutez Mistral 7B, Mistral Nemo et Mixtral 8x7B localement '
          'sur votre machine. Aucune donnée envoyée vers le cloud, '
          'idéal pour la confidentialité et les environnements hors-ligne.',
      tips: [
        'Installation : curl -fsSL https://ollama.com/install.sh | sh',
        'ollama pull mistral (4.1 GB, 8 GB RAM min.)',
        'ollama pull mistral-nemo (4.1 GB, 8 GB RAM)',
        'ollama pull mixtral (26 GB, 32 GB RAM min.)',
        'API compatible OpenAI sur http://localhost:11434',
      ],
    ),
    _App(
      icon: Icons.laptop_outlined,
      title: 'LM Studio — Interface desktop',
      category: 'Local / Privé',
      description:
          'Application desktop pour télécharger et exécuter les modèles '
          'Mistral localement via une interface graphique conviviale. '
          'Supporte les formats GGUF et propose un serveur OpenAI-compatible.',
      tips: [
        'Téléchargement : lmstudio.ai (Mac, Windows, Linux)',
        'Recherchez "mistral" ou "mixtral" dans le catalogue',
        'Interface graphique de chat intégrée',
        'Serveur local : port 1234 compatible API OpenAI',
        'GPU acceleration automatique (Metal/CUDA/ROCm)',
      ],
    ),
    _App(
      icon: Icons.hub_outlined,
      title: 'Hugging Face + Mistral',
      category: 'Open Source',
      description:
          'Les modèles Mistral open-weight sont disponibles sur Hugging Face '
          'pour le téléchargement, le fine-tuning et le déploiement. '
          'Inference API disponible sans infrastructure propre.',
      tips: [
        'huggingface.co/mistralai pour tous les modèles officiels',
        'Mistral 7B v0.3 : modèle de base téléchargeable gratuitement',
        'Inference API : client HF avec token d\'accès',
        'Spaces : démos interactives sans installation',
        'Compatible transformers, llama.cpp, vllm',
      ],
    ),
    _App(
      icon: Icons.psychology_outlined,
      title: 'LangChain + Mistral',
      category: 'Frameworks IA',
      description:
          'Intégration native de l\'API Mistral dans LangChain pour construire '
          'des applications RAG, des agents et des chaînes complexes. '
          'Compatible LangGraph pour les workflows multi-agents.',
      tips: [
        'pip install langchain-mistralai',
        'ChatMistralAI(model="mistral-large-latest")',
        'MistralAIEmbeddings pour les embeddings vectoriels',
        'Compatible LCEL (LangChain Expression Language)',
        'LangGraph : orchestration d\'agents Mistral multi-étapes',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _apps.length,
        itemBuilder: (context, i) => _AppCard(
          app: _apps[i],
          color: context.palette[i % context.palette.length],
        ),
      ),
    );
  }
}

class _AppCard extends StatefulWidget {
  final _App app;
  final Color color;
  const _AppCard({required this.app, required this.color});

  @override
  State<_AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<_AppCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(widget.app.icon, color: c, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(widget.app.title,
                      style: TextStyle(
                          color: c,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: c.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(widget.app.category,
                        style: TextStyle(
                            color: c,
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ),
                ]),
              ),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                  color: c, size: 20),
            ]),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(color: c.withValues(alpha: 0.2)),
              Text(widget.app.description,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.5)),
              const SizedBox(height: 10),
              ...widget.app.tips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right, color: c, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(tip,
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                      fontSize: 13))),
                        ]),
                  )),
            ]),
          ),
      ]),
    );
  }
}

class _App {
  final IconData icon;
  final String title;
  final String category;
  final String description;
  final List<String> tips;

  const _App(
      {required this.icon,
      required this.title,
      required this.category,
      required this.description,
      required this.tips});
}
