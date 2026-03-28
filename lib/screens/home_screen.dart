import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          // Hero card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.heroGradient,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Mistral AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'IA open source haute performance, développée en France par Mistral AI.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          sectionTitle('Qu\'est-ce que Mistral AI ?', context),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.info_outline,
            text: 'Mistral AI est une entreprise française fondée en 2023. Elle développe des modèles de langage open source et propriétaires de haute performance. Mistral est reconnu pour l\'efficacité de ses modèles : petits mais très puissants.',
          ),

          const SizedBox(height: 20),
          sectionTitle('Les modèles disponibles', context),
          const SizedBox(height: 10),
          _ModelCard(
            name: 'Mistral Large',
            id: 'mistral-large-latest',
            description: 'Le plus puissant. Idéal pour les tâches complexes.',
            color: context.palette[5],
          ),
          const SizedBox(height: 8),
          _ModelCard(
            name: 'Mistral Small',
            id: 'mistral-small-latest',
            description: 'Équilibre parfait entre performance et coût.',
            color: context.palette[2],
          ),
          const SizedBox(height: 8),
          _ModelCard(
            name: 'Codestral',
            id: 'codestral-latest',
            description: 'Spécialisé pour la génération et complétion de code.',
            color: context.palette[0],
          ),
          const SizedBox(height: 8),
          _ModelCard(
            name: 'Mistral Embed',
            id: 'mistral-embed',
            description: 'Modèle d\'embeddings pour la recherche sémantique.',
            color: context.palette[3],
          ),

          const SizedBox(height: 20),
          sectionTitle('Liens utiles', context),
          const SizedBox(height: 10),
          _LinkCard(
            icon: Icons.web,
            label: 'mistral.ai',
            subtitle: 'Site officiel Mistral AI',
            url: 'https://mistral.ai',
          ),
          const SizedBox(height: 6),
          _LinkCard(
            icon: Icons.description_outlined,
            label: 'docs.mistral.ai',
            subtitle: 'Documentation API',
            url: 'https://docs.mistral.ai',
          ),
          const SizedBox(height: 6),
          _LinkCard(
            icon: Icons.dashboard_outlined,
            label: 'console.mistral.ai',
            subtitle: 'Console & clés API',
            url: 'https://console.mistral.ai',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ctx.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ctx.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ctx.accentMid, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: ctx.isLight ? const Color(0xFF5D3A1A) : const Color(0xFFCFD8DC),
                height: 1.6,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final String name;
  final String id;
  final String description;
  final Color color;
  const _ModelCard({required this.name, required this.id, required this.description, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.auto_awesome, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      color: context.isLight ? const Color(0xFF3E2000) : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )),
                const SizedBox(height: 2),
                Text(id, style: TextStyle(color: color, fontSize: 11, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                      color: context.isLight ? const Color(0xFF8D6030) : const Color(0xFF90A4AE),
                      fontSize: 12,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String url;
  const _LinkCard({required this.icon, required this.label, required this.subtitle, required this.url});

  @override
  Widget build(BuildContext ctx) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: ctx.cardBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: ctx.accentMid, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      color: ctx.isLight ? const Color(0xFF3E2000) : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )),
                Text(subtitle,
                    style: TextStyle(
                      color: ctx.isLight ? const Color(0xFF8D6030) : const Color(0xFF78909C),
                      fontSize: 11,
                    )),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios,
                color: ctx.isLight ? const Color(0xFF8D6030) : const Color(0xFF455A64),
                size: 14),
          ],
        ),
      ),
    );
  }
}
