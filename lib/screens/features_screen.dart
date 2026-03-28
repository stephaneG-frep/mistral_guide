import 'package:flutter/material.dart';
import '../app_theme.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  static const List<_Feature> _features = [
    _Feature(icon: Icons.flash_on_outlined,      title: 'Performance & Efficacité',
      description: 'Mistral excelle à faire beaucoup avec peu de paramètres. Mistral 7B surpasse des modèles bien plus grands tout en étant très rapide.',
      tips: ['Idéal pour les déploiements sur des machines modestes', 'Faible latence pour les applications temps réel', 'Excellent rapport qualité/coût']),
    _Feature(icon: Icons.lock_open_outlined,      title: 'Open Source',
      description: 'Plusieurs modèles Mistral sont publiés en open source (licence Apache 2.0). Tu peux les télécharger, modifier et déployer localement.',
      tips: ['Mistral 7B et Mixtral 8x7B sont open source', 'Déploiement local avec Ollama ou vLLM', 'Aucune dépendance à un service cloud']),
    _Feature(icon: Icons.psychology_outlined,     title: 'Mixtral MoE',
      description: 'Architecture Mixture of Experts (MoE) : plusieurs sous-réseaux spécialisés activés selon le contexte. Puissance d\'un grand modèle, coût d\'un petit.',
      tips: ['Mixtral 8x7B active 2 experts sur 8 à chaque token', 'Performances proches de GPT-3.5 à moindre coût', 'Disponible en open source']),
    _Feature(icon: Icons.code_outlined,           title: 'Codestral',
      description: 'Modèle spécialisé pour la génération et complétion de code. Supporte 80+ langages de programmation avec une fenêtre de contexte de 32k tokens.',
      tips: ['Optimisé pour la complétion de code (fill-in-the-middle)', 'Intégrable dans VS Code, Neovim, JetBrains', 'Idéal pour Copilot-like features']),
    _Feature(icon: Icons.search_outlined,         title: 'Embeddings',
      description: 'Mistral Embed génère des vecteurs de 1024 dimensions pour la recherche sémantique, la classification et le RAG (Retrieval Augmented Generation).',
      tips: ['Parfait pour construire un moteur de recherche sémantique', 'Compatible avec des bases vectorielles (Pinecone, Weaviate)', 'Utilisé en RAG pour gronder un LLM sur tes données']),
    _Feature(icon: Icons.build_outlined,          title: 'Function Calling',
      description: 'Mistral peut appeler des fonctions que tu définis. Il analyse la requête, choisit le bon outil et retourne les arguments structurés en JSON.',
      tips: ['Définis tes outils avec un schéma JSON', 'Mistral choisit automatiquement quand les appeler', 'Idéal pour connecter à des APIs externes']),
    _Feature(icon: Icons.translate_outlined,      title: 'Multilingue',
      description: 'Excellente maîtrise du français (langue de Mistral AI !), anglais, espagnol, allemand, italien et de nombreuses autres langues européennes.',
      tips: ['Natif en français — aucune perte de qualité', 'Adapte le registre selon le contexte', 'Traduction avec nuances culturelles']),
    _Feature(icon: Icons.cloud_outlined,          title: 'La Plateforme',
      description: 'API REST complète avec SDKs Python et JS, compatible format OpenAI. Déploiement cloud via la Plateforme Mistral ou self-hosted.',
      tips: ['Compatible avec les clients OpenAI (drop-in replacement)', 'Modèles fine-tunables sur tes données', 'Offre gratuite pour débuter sur console.mistral.ai']),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, _) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _features.length,
        itemBuilder: (context, index) {
          final color = context.palette[index % context.palette.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _FeatureCard(feature: _features[index], color: color),
          );
        },
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final _Feature feature;
  final Color color;
  const _FeatureCard({required this.feature, required this.color});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    final c = widget.color;
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(f.icon, color: c, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(f.title,
                        style: TextStyle(
                          color: context.isLight ? const Color(0xFF3E2000) : Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      color: context.isLight ? const Color(0xFF8D6030) : const Color(0xFF546E7A),
                      size: 22),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(f.description,
                  style: TextStyle(
                    color: context.isLight ? const Color(0xFF6D4C41) : const Color(0xFFB0BEC5),
                    fontSize: 13,
                    height: 1.6,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Conseils',
                      style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  ...f.tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_right, color: c, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(tip,
                                  style: TextStyle(
                                    color: context.isLight
                                        ? const Color(0xFF8D6E63)
                                        : const Color(0xFF90A4AE),
                                    fontSize: 12,
                                    height: 1.5,
                                  )),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  final List<String> tips;
  const _Feature({required this.icon, required this.title, required this.description, required this.tips});
}
