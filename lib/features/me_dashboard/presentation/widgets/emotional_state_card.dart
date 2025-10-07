// lib/features/me_dashboard/presentation/widgets/emotional_state_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/me_dashboard/providers/me_providers.dart';

class EmotionalStateCard extends ConsumerWidget {
  const EmotionalStateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Récupérer le nombre de check-ins du mois en cours
    final currentMonthCheckinsAsync = ref.watch(currentMonthCheckinsCountProvider);

    // Récupérer le résumé du mois précédent
    final lastMonthSummaryAsync = ref.watch(lastMonthSummaryProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigation vers la page d'historique
          context.push('/emotional-history');
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.psychology_outlined,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'État émotionnel',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Nombre de check-ins du mois en cours
              currentMonthCheckinsAsync.when(
                data: (count) => _buildCurrentMonthSection(
                  context,
                  count,
                  colorScheme,
                  textTheme,
                ),
                loading: () => const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, __) => Text(
                  'Erreur de chargement',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Divider
              Divider(
                color: colorScheme.outline.withOpacity(0.2),
              ),

              const SizedBox(height: 16),

              // Résumé du mois précédent
              lastMonthSummaryAsync.when(
                data: (summary) {
                  if (summary == null) {
                    return Text(
                      'Aucune analyse disponible pour le mois dernier',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    );
                  }
                  return _buildLastMonthSummary(
                    context,
                    summary,
                    colorScheme,
                    textTheme,
                  );
                },
                loading: () => const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentMonthSection(
      BuildContext context,
      int count,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    final now = DateTime.now();
    final monthName = _getMonthName(now.month);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final progress = count / daysInMonth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              monthName,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$count check-ins',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: colorScheme.outline.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Analyse disponible fin $monthName',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildLastMonthSummary(
      BuildContext context,
      Map<String, dynamic> summary,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    final monthName = _getMonthName(summary['month'] as int);
    final shortSummary = summary['short_summary'] as String;
    final sentiment = summary['sentiment'] as String; // 'positive', 'neutral', 'difficult'

    Color sentimentColor;
    IconData sentimentIcon;

    switch (sentiment) {
      case 'positive':
        sentimentColor = Colors.green;
        sentimentIcon = Icons.sentiment_satisfied_alt;
        break;
      case 'difficult':
        sentimentColor = Colors.orange;
        sentimentIcon = Icons.sentiment_dissatisfied;
        break;
      default:
        sentimentColor = Colors.blue;
        sentimentIcon = Icons.sentiment_neutral;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              sentimentIcon,
              size: 20,
              color: sentimentColor,
            ),
            const SizedBox(width: 8),
            Text(
              monthName,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          shortSummary,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.8),
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          'Voir le détail →',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
}

// Providers nécessaires
final currentMonthCheckinsCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(meRepositoryProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final checkins = await repository.getCheckinsHistory(days: now.day);

  // Filtrer pour ne garder que ceux du mois en cours
  return checkins.where((checkin) {
    final checkinDate = checkin.timestamp;
    return checkinDate.isAfter(startOfMonth) || checkinDate.isAtSameMomentAs(startOfMonth);
  }).length;
});

final lastMonthSummaryProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repository = ref.watch(meRepositoryProvider);

  // Récupérer le résumé du mois précédent depuis la DB
  // Cette méthode sera à implémenter dans le repository
  return await repository.getMonthSummary(
    year: DateTime.now().month == 1 ? DateTime.now().year - 1 : DateTime.now().year,
    month: DateTime.now().month == 1 ? 12 : DateTime.now().month - 1,
  );
});