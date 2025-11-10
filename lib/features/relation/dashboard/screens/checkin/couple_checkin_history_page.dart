import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lova/features/relation/dashboard/models/couple_checkin.dart';
import 'package:lova/features/relation/dashboard/models/emotion_type.dart';
import 'package:lova/features/relation/dashboard/providers/couple_checkin_provider.dart';

class CoupleCheckinHistoryPage extends ConsumerWidget {
  const CoupleCheckinHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(coupleCheckinHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique Check-ins Couple'),
        centerTitle: true,
      ),
      body: historyAsync.when(
        data: (checkins) {
          if (checkins.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildHistoryContent(context, checkins);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun check-in pour le moment',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez à faire vos check-ins couple !',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(BuildContext context, List<CoupleCheckin> checkins) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Stats sur 30 jours
          _buildStatsCard(context, checkins),
          const SizedBox(height: 20),

          // 2. Graphe Tendance (7 derniers jours)
          _buildTrendChart(context, checkins),
          const SizedBox(height: 20),

          // 3. Liste chronologique
          _buildCheckinsList(context, checkins),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, List<CoupleCheckin> checkins) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Calculs
    final total = checkins.length;
    final avgScore = checkins.isEmpty
        ? 0.0
        : checkins
                .map((c) =>
                    (c.scoreConnection +
                        c.scoreSatisfaction +
                        c.scoreCommunication) /
                    3)
                .reduce((a, b) => a + b) /
            checkins.length;

    // Émotion la plus fréquente
    final emotionCounts = <EmotionType, int>{};
    for (var checkin in checkins) {
      emotionCounts[checkin.emotion] = (emotionCounts[checkin.emotion] ?? 0) + 1;
    }
    final mostFrequentEmotion = emotionCounts.entries.isEmpty
        ? null
        : emotionCounts.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.secondaryContainer.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Stats sur 30 jours',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Total',
                  value: total.toString(),
                  icon: Icons.favorite,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Moyenne',
                  value: avgScore.toStringAsFixed(1),
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Émotion',
                  value: mostFrequentEmotion?.emoji ?? '—',
                  subtitle: mostFrequentEmotion?.label ?? '',
                  icon: Icons.emoji_emotions,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    String? subtitle,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(BuildContext context, List<CoupleCheckin> checkins) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Prendre les 7 derniers jours
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return DateTime(date.year, date.month, date.day);
    });

    // Grouper les check-ins par date
    final checkinsMap = <DateTime, List<CoupleCheckin>>{};
    for (var checkin in checkins) {
      final date = DateTime(
        checkin.checkinDate.year,
        checkin.checkinDate.month,
        checkin.checkinDate.day,
      );
      checkinsMap.putIfAbsent(date, () => []).add(checkin);
    }

    // Calculer la moyenne par jour
    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < last7Days.length; i++) {
      final date = last7Days[i];
      final dayCheckins = checkinsMap[date] ?? [];
      final avgScore = dayCheckins.isEmpty
          ? 0.0
          : dayCheckins
                  .map((c) =>
                      (c.scoreConnection +
                          c.scoreSatisfaction +
                          c.scoreCommunication) /
                      3)
                  .reduce((a, b) => a + b) /
              dayCheckins.length;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: avgScore,
              color: const Color(0xFFFF69B4), // Rose
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Tendance 7 derniers jours',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                minY: 0,
                barGroups: barGroups,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 2,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colorScheme.outline.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < last7Days.length) {
                          final date = last7Days[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('E', 'fr_FR').format(date)[0].toUpperCase(),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: colorScheme.inverseSurface,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final date = last7Days[group.x.toInt()];
                      return BarTooltipItem(
                        '${DateFormat('dd/MM', 'fr_FR').format(date)}\n${rod.toY.toStringAsFixed(1)}',
                        textTheme.bodySmall!.copyWith(
                          color: colorScheme.onInverseSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckinsList(BuildContext context, List<CoupleCheckin> checkins) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Grouper par date
    final groupedCheckins = <String, List<CoupleCheckin>>{};
    for (var checkin in checkins) {
      final dateKey = DateFormat('yyyy-MM-dd').format(checkin.checkinDate);
      groupedCheckins.putIfAbsent(dateKey, () => []).add(checkin);
    }

    // Trier les dates en ordre décroissant
    final sortedDates = groupedCheckins.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Historique complet',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sortedDates.map((dateKey) {
            final date = DateTime.parse(dateKey);
            final dayCheckins = groupedCheckins[dateKey]!;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Text(
                    DateFormat('EEEE d MMMM', 'fr_FR').format(date),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Checkins pour cette date
                  ...dayCheckins.map((checkin) {
                    final avgScore = (checkin.scoreConnection +
                            checkin.scoreSatisfaction +
                            checkin.scoreCommunication) /
                        3;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Émotion
                          Text(
                            checkin.emotion.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 12),
                          // Détails
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  checkin.emotion.label,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Score moyen: ${avgScore.toStringAsFixed(1)}/10',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Heure
                          Text(
                            DateFormat('HH:mm').format(checkin.createdAt),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
