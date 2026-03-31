import 'package:flutter/material.dart';
import '../app_theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const _questions = [
    _Question(
      question: 'Quelle architecture utilise Mixtral 8x7B ?',
      options: ['Dense Transformer', 'Mixture of Experts (MoE)', 'Ring Attention', 'State Space Model'],
      correct: 1,
      explanation: 'Mixtral 8x7B utilise une architecture Mixture of Experts (MoE) : '
          '8 experts FFN par couche, mais seulement 2 sont activés par token, '
          'ce qui donne 13B de paramètres actifs pour 47B au total.',
    ),
    _Question(
      question: 'Quelle est la taille de la fenêtre de contexte de Codestral ?',
      options: ['8 192 tokens', '32 768 tokens', '128 000 tokens', '1 000 000 tokens'],
      correct: 1,
      explanation: 'Codestral dispose d\'une fenêtre de contexte de 32 768 tokens (32K), '
          'suffisante pour analyser des fichiers de code entiers et maintenir '
          'la cohérence sur de grands projets.',
    ),
    _Question(
      question: 'Qu\'est-ce que le Fill-in-the-Middle (FIM) dans Codestral ?',
      options: [
        'Un mode de résumé de code',
        'La complétion de code entre un préfixe et un suffixe',
        'Un système de détection de bugs',
        'Un mode de génération de tests unitaires'
      ],
      correct: 1,
      explanation: 'FIM (Fill-in-the-Middle) permet à Codestral de compléter du code '
          'en tenant compte du contexte avant ET après le curseur. '
          'Idéal pour l\'autocomplétion inline dans les IDEs.',
    ),
    _Question(
      question: 'Quel est l\'URL de base de l\'API Mistral AI ?',
      options: [
        'https://api.openai.com/v1',
        'https://api.mistral.ai/v1',
        'https://mistral.anthropic.com',
        'https://api.mistral.com/v2'
      ],
      correct: 1,
      explanation: 'L\'API Mistral utilise https://api.mistral.ai/v1 comme endpoint de base. '
          'Elle est compatible avec le format OpenAI, ce qui facilite la migration '
          'depuis d\'autres providers.',
    ),
    _Question(
      question: 'Quelle commande installe le SDK Python officiel de Mistral ?',
      options: [
        'pip install mistral-python',
        'pip install mistralai',
        'pip install mistral-sdk',
        'pip install pymistral'
      ],
      correct: 1,
      explanation: 'pip install mistralai installe le SDK officiel Python de Mistral AI. '
          'Utilisez ensuite : from mistralai import Mistral pour importer le client.',
    ),
    _Question(
      question: 'Mistral 7B est-il open source ?',
      options: [
        'Non, propriétaire',
        'Oui, licence Apache 2.0',
        'Oui, mais uniquement pour usage non-commercial',
        'Partiellement, les poids sont publics mais pas le code'
      ],
      correct: 1,
      explanation: 'Mistral 7B est publié sous licence Apache 2.0, ce qui permet '
          'un usage commercial libre. Les poids sont disponibles sur Hugging Face. '
          'C\'est l\'un des LLMs open-weight les plus permissifs.',
    ),
    _Question(
      question: 'Quel modèle Mistral faut-il utiliser pour les tâches nécessitant le plus de raisonnement ?',
      options: ['mistral-small-latest', 'codestral-latest', 'mistral-large-latest', 'open-mistral-7b'],
      correct: 2,
      explanation: 'mistral-large-latest est le modèle flagship de Mistral AI, '
          'optimisé pour les tâches complexes de raisonnement, d\'analyse '
          'et de génération multilingue. Contexte de 128K tokens.',
    ),
    _Question(
      question: 'Sur quel port Ollama expose-t-il son API par défaut ?',
      options: ['8080', '3000', '11434', '5000'],
      correct: 2,
      explanation: 'Ollama expose son API REST sur le port 11434 par défaut. '
          'L\'endpoint est http://localhost:11434/api/generate ou '
          'http://localhost:11434/v1 (format compatible OpenAI).',
    ),
    _Question(
      question: 'Quel format de données est requis pour le fine-tuning Mistral ?',
      options: ['CSV avec colonnes input/output', 'JSONL avec messages au format chat', 'XML structuré', 'Parquet files'],
      correct: 1,
      explanation: 'Le fine-tuning Mistral utilise le format JSONL où chaque ligne '
          'est un objet JSON avec une clé "messages" contenant le dialogue '
          '(role: user/assistant). Minimum 32 exemples recommandé.',
    ),
    _Question(
      question: 'Quelle est la principale différence entre Mistral Nemo et Mistral 7B ?',
      options: [
        'Nemo est plus grand avec 12B paramètres',
        'Nemo est spécialisé pour le code uniquement',
        'Nemo utilise MoE, 7B est dense',
        '7B a un meilleur contexte que Nemo'
      ],
      correct: 0,
      explanation: 'Mistral Nemo est un modèle de 12B paramètres développé en collaboration '
          'avec NVIDIA. Il offre de meilleures performances que Mistral 7B '
          'tout en restant léger, avec une fenêtre de contexte de 128K tokens.',
    ),
    _Question(
      question: 'Comment activer le mode JSON dans l\'API Mistral ?',
      options: [
        'Ajouter json=True au prompt',
        'response_format={"type": "json_object"}',
        'output_format="json"',
        'Ajouter "Respond in JSON" au system prompt uniquement'
      ],
      correct: 1,
      explanation: 'Pour forcer une sortie JSON valide avec l\'API Mistral, '
          'utilisez response_format={"type": "json_object"} dans vos paramètres. '
          'Mentionnez aussi "JSON" dans le prompt pour de meilleurs résultats.',
    ),
    _Question(
      question: 'Quelle RAM minimum faut-il pour exécuter Mixtral 8x7B localement ?',
      options: ['8 GB', '16 GB', '32 GB', '64 GB'],
      correct: 2,
      explanation: 'Mixtral 8x7B nécessite environ 32 GB de RAM minimum pour s\'exécuter '
          'en précision 4-bit quantisée. En précision complète, il faut environ '
          '90 GB. Privilégiez les versions GGUF Q4 pour usage desktop.',
    ),
    _Question(
      question: 'Quelle est la meilleure pratique pour structurer un prompt complexe avec Mistral ?',
      options: [
        'Tout mettre en une seule longue phrase',
        'Utiliser des délimiteurs clairs et séparer le contexte de la tâche',
        'Répéter la question trois fois pour plus de clarté',
        'Ne jamais donner d\'exemples pour éviter le biais'
      ],
      correct: 1,
      explanation: 'Pour les prompts complexes, utilisez des délimiteurs comme ### ou --- '
          'pour séparer le contexte, les instructions et la tâche. '
          'Structurez votre prompt : contexte → instruction → format attendu → exemples.',
    ),
    _Question(
      question: 'Quel est l\'avantage de l\'API Batch de Mistral ?',
      options: [
        'Résultats en temps réel plus rapides',
        'Accès aux modèles exclusifs non disponibles en standard',
        '50% de réduction du coût pour les traitements différés',
        'Pas de limite de tokens par requête'
      ],
      correct: 2,
      explanation: 'La Batch API de Mistral offre une réduction de 50% sur les coûts '
          'en échange d\'un traitement asynchrone (jusqu\'à 24h). '
          'Idéal pour les analyses en masse, la classification de données ou le fine-tuning.',
    ),
    _Question(
      question: 'Comment utiliser le role prompting avec Mistral pour améliorer les réponses ?',
      options: [
        'Utiliser uniquement le message "user", jamais le "system"',
        'Définir un rôle expert dans le message "system" pour guider le comportement',
        'Répéter le rôle dans chaque message "user"',
        'Le role prompting ne fonctionne pas avec Mistral'
      ],
      correct: 1,
      explanation: 'Définissez un rôle expert dans le message system : '
          '"Tu es un expert en cybersécurité avec 15 ans d\'expérience." '
          'Cela oriente le ton, le niveau de détail et le domaine de réponse de Mistral Large.',
    ),
    _Question(
      question: 'Quelle interface web officielle utiliser pour tester les modèles Mistral sans coder ?',
      options: ['mistral.studio', 'Le Chat sur chat.mistral.ai', 'console.mistral.ai/playground', 'playground.mistral.com'],
      correct: 1,
      explanation: 'Le Chat (chat.mistral.ai) est l\'interface web officielle de Mistral AI. '
          'La console La Plateforme (console.mistral.ai) propose aussi un playground '
          'pour tester les modèles avec contrôle des paramètres (température, top_p).',
    ),
  ];

  int _current = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;

  void _answer(int idx) {
    if (_answered) return;
    final correct = _questions[_current].correct == idx;
    setState(() {
      _selected = idx;
      _answered = true;
      if (correct) _score++;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
    } else {
      setState(() => _finished = true);
    }
  }

  void _restart() {
    setState(() {
      _current = 0;
      _selected = null;
      _answered = false;
      _score = 0;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) =>
          _finished ? _buildResult(context) : _buildQuestion(context),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final q = _questions[_current];
    final accent = context.accentLight;
    final progress = (_current + 1) / _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Progress
        Row(children: [
          Text('${_current + 1}/${_questions.length}',
              style: TextStyle(
                  color: accent, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: accent.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(accent),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('Score: $_score',
              style: TextStyle(
                  color: accent, fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
        const SizedBox(height: 20),

        // Question
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withValues(alpha: 0.3)),
          ),
          child: Text(q.question,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.4)),
        ),
        const SizedBox(height: 16),

        // Options
        ...List.generate(q.options.length, (i) {
          Color borderColor = accent.withValues(alpha: 0.2);
          Color bgColor = context.cardBg;
          Color textColor = Theme.of(context).colorScheme.onSurface;
          IconData? trailingIcon;

          if (_answered) {
            if (i == q.correct) {
              borderColor = Colors.green;
              bgColor = Colors.green.withValues(alpha: 0.1);
              textColor = Colors.green;
              trailingIcon = Icons.check_circle;
            } else if (i == _selected) {
              borderColor = Colors.red;
              bgColor = Colors.red.withValues(alpha: 0.1);
              textColor = Colors.red;
              trailingIcon = Icons.cancel;
            }
          } else if (_selected == i) {
            borderColor = accent;
            bgColor = accent.withValues(alpha: 0.1);
            textColor = accent;
          }

          return GestureDetector(
            onTap: () => _answer(i),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: Row(children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      ['A', 'B', 'C', 'D'][i],
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(q.options[i],
                        style:
                            TextStyle(color: textColor, fontSize: 14, height: 1.3))),
                if (trailingIcon != null)
                  Icon(trailingIcon, color: textColor, size: 20),
              ]),
            ),
          );
        }),

        // Explanation
        if (_answered) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.lightbulb_outline, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(q.explanation,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.5))),
            ]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                _current < _questions.length - 1 ? 'Question suivante →' : 'Voir le résultat',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildResult(BuildContext context) {
    final accent = context.accentLight;
    final pct = (_score / _questions.length * 100).round();
    final color = pct >= 80
        ? Colors.green
        : pct >= 50
            ? Colors.orange
            : Colors.red;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                width: 130,
                height: 130,
                child: CircularProgressIndicator(
                  value: _score / _questions.length,
                  strokeWidth: 10,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$_score/${_questions.length}',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color)),
                Text('$pct%',
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          Text(
            pct >= 80
                ? 'Excellent ! Vous maîtrisez Mistral AI !'
                : pct >= 50
                    ? 'Bien ! Continuez à explorer Mistral.'
                    : 'Révisez le guide et réessayez !',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Score : $_score bonne${_score > 1 ? 's' : ''} réponse${_score > 1 ? 's' : ''} sur ${_questions.length}',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.refresh),
              label: const Text('Recommencer le quiz',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Question {
  final String question;
  final List<String> options;
  final int correct;
  final String explanation;

  const _Question({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });
}
