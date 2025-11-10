import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lova/features/relation/dashboard/screens/rituals/providers/couple_rituals_provider.dart';

class CoupleRitualHistoryPage extends ConsumerWidget {
  const CoupleRitualHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(coupleRitualHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Historique Rituels Couple'),
        centerTitle: true,
      ),
      body: historyAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildHistoryContent(context, sessions);
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
            Icons.self_improvement,
            size: 64,
            color: const Color(0xFFFF69B4).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun rituel complété',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez à pratiquer vos rituels de couple !',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(BuildContext context, List<Map<String, dynamic>> sessions) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Stats sur 30 jours
          _buildStatsCard(context, sessions),
          const SizedBox(height: 20),

          // 2. Graphe Tendance (7 derniers jours)
          _buildTrendChart(context, sessions),
          const SizedBox(height: 20),

          // 3. Liste chronologique
          _buildSessionsList(context, sessions),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, List<Map<String, dynamic>> sessions) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Calculs
    final totalSessions = sessions.length;
    final totalMinutes = sessions.fold<int>(
      0,
      (sum, session) => sum + (session['duration_actual_minutes'] as int? ?? 0),
    );

    // Rituel le plus fréquent
    final ritualCounts = <String, int>{};
    String? mostFrequentRitual;
    String? mostFrequentRitualEmoji;

    for (var session in sessions) {
      final ritualId = session['ritual_id'] as String;
      ritualCounts[ritualId] = (ritualCounts[ritualId] ?? 0) + 1;
    }

    if (ritualCounts.isNotEmpty) {
      final mostFrequent = ritualCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b);

      // Trouver le titre et emoji du rituel le plus fréquent
      final ritualData = sessions.firstWhere(
        (s) => s['ritual_id'] == mostFrequent.key,
        orElse: () => {},
      );

      if (ritualData.isNotEmpty && ritualData['ritual_catalog'] != null) {
        final catalog = ritualData['ritual_catalog'] as Map<String, dynamic>;
        mostFrequentRitual = catalog['title'] as String?;
        mostFrequentRitualEmoji = catalog['emoji'] as String?;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF69B4).withOpacity(0.15),
            const Color(0xFFFFA06B).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF69B4).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: Color(0xFFFF69B4), size: 24),
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
                  label: 'Sessions',
                  value: totalSessions.toString(),
                  icon: Icons.check_circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Minutes',
                  value: totalMinutes.toString(),
                  icon: Icons.timer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Favori',
                  value: mostFrequentRitualEmoji ?? '—',
                  subtitle: mostFrequentRitual ?? '',
                  icon: Icons.favorite,
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
          Icon(icon, color: const Color(0xFFFF69B4), size: 20),
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

  Widget _buildTrendChart(BuildContext context, List<Map<String, dynamic>> sessions) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Prendre les 7 derniers jours
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return DateTime(date.year, date.month, date.day);
    });

    // Grouper les sessions par date
    final sessionsMap = <DateTime, int>{};
    for (var session in sessions) {
      final completedAt = DateTime.parse(session['completed_at'] as String);
      final date = DateTime(
        completedAt.year,
        completedAt.month,
        completedAt.day,
      );
      sessionsMap[date] = (sessionsMap[date] ?? 0) + 1;
    }

    // Créer les barres
    final barGroups = <BarChartGroupData>[];
    double maxY = 5; // Minimum 5 pour avoir une échelle visible

    for (var i = 0; i < last7Days.length; i++) {
      final date = last7Days[i];
      final count = sessionsMap[date]?.toDouble() ?? 0.0;

      if (count > maxY) maxY = count;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count,
              color: const Color(0xFFFF69B4),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart, color: Color(0xFFFF69B4), size: 24),
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
                maxY: maxY + 1,
                minY: 0,
                barGroups: barGroups,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1,
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
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          );
                        }
                        return const SizedBox();
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
                      final count = rod.toY.toInt();
                      return BarTooltipItem(
                        '${DateFormat('dd/MM', 'fr_FR').format(date)}\n$count session${count > 1 ? 's' : ''}',
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

  Widget _buildSessionsList(BuildContext context, List<Map<String, dynamic>> sessions) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Grouper par date
    final groupedSessions = <String, List<Map<String, dynamic>>>{};
    for (var session in sessions) {
      final completedAt = DateTime.parse(session['completed_at'] as String);
      final dateKey = DateFormat('yyyy-MM-dd').format(completedAt);
      groupedSessions.putIfAbsent(dateKey, () => []).add(session);
    }

    // Trier les dates en ordre décroissant
    final sortedDates = groupedSessions.keys.toList()
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Color(0xFFFF69B4), size: 24),
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
            final daySessions = groupedSessions[dateKey]!;

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
                  // Sessions pour cette date
                  ...daySessions.map((session) {
                    final ritualCatalog = session['ritual_catalog'] as Map<String, dynamic>?;
                    final emoji = ritualCatalog?['emoji'] as String? ?? '🧘';
                    final title = ritualCatalog?['title'] as String? ?? 'Rituel';
                    final duration = session['duration_actual_minutes'] as int? ?? 0;
                    final completedAt = DateTime.parse(session['completed_at'] as String);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF69B4).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF69B4).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Emoji
                          Text(
                            emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 12),
                          // Détails
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$duration min',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Heure
                          Text(
                            DateFormat('HH:mm').format(completedAt),
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
