// lib/features/me_dashboard/presentation/emotional_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/me_dashboard/providers/me_providers.dart';

class EmotionalHistoryPage extends ConsumerStatefulWidget {
  const EmotionalHistoryPage({super.key});

  @override
  ConsumerState<EmotionalHistoryPage> createState() => _EmotionalHistoryPageState();
}

class _EmotionalHistoryPageState extends ConsumerState<EmotionalHistoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final monthlyAnalysesAsync = ref.watch(monthlyAnalysesProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Historique émotionnel'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: monthlyAnalysesAsync.when(
        data: (analyses) {
          if (analyses.isEmpty) {
            return _buildEmptyState(context, colorScheme, textTheme);
          }
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: analyses.length,
              itemBuilder: (context, index) {
                final analysis = analyses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _MonthAnalysisCard(analysis: analysis),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 80,
              color: colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune analyse disponible',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Continuez vos check-ins quotidiens.\nVotre première analyse sera disponible fin du mois.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthAnalysisCard extends ConsumerWidget {
  final Map<String, dynamic> analysis;

  const _MonthAnalysisCard({required this.analysis});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final month = analysis['month'] as int;
    final year = analysis['year'] as int;
    final monthName = _getMonthName(month);
    final sentiment = analysis['sentiment'] as String;
    final stats = analysis['stats'] as Map<String, dynamic>;
    final aiInsight = analysis['ai_insight'] as String?;

    Color sentimentColor = _getSentimentColor(sentiment);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: sentimentColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: sentimentColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec mois et sentiment
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  sentimentColor.withOpacity(0.15),
                  sentimentColor.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sentimentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getSentimentIcon(sentiment),
                    color: sentimentColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$monthName $year',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getSentimentLabel(sentiment),
                        style: textTheme.bodyMedium?.copyWith(
                          color: sentimentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Statistiques
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistiques du mois',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatsGrid(context, stats, colorScheme, textTheme),

                const SizedBox(height: 24),

                // Déclencheurs principaux
                if (stats['top_triggers'] != null) ...[
                  Text(
                    'Déclencheurs principaux',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTriggersList(
                    context,
                    stats['top_triggers'] as List<dynamic>,
                    colorScheme,
                    textTheme,
                  ),
                  const SizedBox(height: 24),
                ],

                // Analyse IA
                if (aiInsight != null && aiInsight.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Analyse Loova',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          aiInsight,
                          style: textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
      BuildContext context,
      Map<String, dynamic> stats,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            Icons.check_circle,
            '${stats['checkin_count']}',
            'Check-ins',
            colorScheme,
            textTheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            Icons.sentiment_satisfied,
            '${stats['average_mood'].toStringAsFixed(1)}',
            'Humeur moy.',
            colorScheme,
            textTheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            Icons.trending_up,
            '${stats['positive_days']}',
            'Jours +',
            colorScheme,
            textTheme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      IconData icon,
      String value,
      String label,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTriggersList(
      BuildContext context,
      List<dynamic> triggers,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: triggers.map((trigger) {
        final name = trigger['name'] as String;
        final count = trigger['count'] as int;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count×',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return months[month - 1];
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'positive':
        return Colors.green;
      case 'difficult':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getSentimentIcon(String sentiment) {
    switch (sentiment) {
      case 'positive':
        return Icons.sentiment_satisfied_alt;
      case 'difficult':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  String _getSentimentLabel(String sentiment) {
    switch (sentiment) {
      case 'positive':
        return 'Mois positif';
      case 'difficult':
        return 'Mois difficile';
      default:
        return 'Mois neutre';
    }
  }
}

// Provider pour récupérer toutes les analyses mensuelles
final monthlyAnalysesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(meRepositoryProvider);
  return await repository.getMonthlyAnalyses();
});