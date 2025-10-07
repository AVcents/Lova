// lib/features/me_dashboard/presentation/pages/checkins_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:lova/features/me_dashboard/providers/me_providers.dart';
import 'package:lova/features/me_dashboard/presentation/rituals_selection_page.dart';

class CheckinsHistoryPage extends ConsumerStatefulWidget {
  const CheckinsHistoryPage({super.key});

  @override
  ConsumerState<CheckinsHistoryPage> createState() => _CheckinsHistoryPageState();
}

class _CheckinsHistoryPageState extends ConsumerState<CheckinsHistoryPage> {
  int _selectedDays = 30;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final checkinsAsync = ref.watch(checkinsHistoryProvider(_selectedDays));

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Historique des check-ins'),
        backgroundColor: colorScheme.surface,
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.filter_list, color: colorScheme.onSurface),
            onSelected: (value) {
              setState(() {
                _selectedDays = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 7, child: Text('7 derniers jours')),
              const PopupMenuItem(value: 30, child: Text('30 derniers jours')),
              const PopupMenuItem(value: 90, child: Text('3 derniers mois')),
              const PopupMenuItem(value: 365, child: Text('Cette année')),
            ],
          ),
        ],
      ),
      body: checkinsAsync.when(
        data: (checkins) {
          if (checkins.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_satisfied_outlined,
                    size: 80,
                    color: colorScheme.onSurface.withOpacity(0.2),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Aucun check-in',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Commencez à suivre votre humeur quotidienne',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          // Calculer les statistiques
          final avgMood = checkins.fold<double>(0, (sum, c) => sum + c.mood) / checkins.length;
          final moodCounts = <int, int>{};
          for (final checkin in checkins) {
            moodCounts[checkin.mood] = (moodCounts[checkin.mood] ?? 0) + 1;
          }
          final mostFrequentMood = moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

          // Grouper par date
          final groupedCheckins = <String, List<dynamic>>{};
          for (final checkin in checkins) {
            final dateKey = DateFormat('yyyy-MM-dd').format(checkin.timestamp);
            groupedCheckins.putIfAbsent(dateKey, () => []).add(checkin);
          }

          final sortedDates = groupedCheckins.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return SingleChildScrollView(
            child: Column(
              children: [
                // Statistiques en haut
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Statistiques sur $_selectedDays jours',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatCard(
                            label: 'Total',
                            value: '${checkins.length}',
                            icon: Icons.calendar_today,
                            color: colorScheme.primary,
                          ),
                          _StatCard(
                            label: 'Moyenne',
                            value: avgMood.toStringAsFixed(1),
                            icon: Icons.trending_up,
                            color: Colors.green,
                          ),
                          _StatCard(
                            label: 'Le plus fréquent',
                            value: _getMoodEmoji(mostFrequentMood),
                            icon: Icons.star,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Graphique de tendance simple
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tendance',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            checkins.length > 14 ? 14 : checkins.length,
                                (index) {
                              final checkin = checkins[checkins.length - 1 - index];
                              final height = (checkin.mood / 5) * 60;
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Il y a ${checkins.length > 14 ? 14 : checkins.length} jours',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            'Aujourd\'hui',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Liste des check-ins par jour
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final dateKey = sortedDates[index];
                    final date = DateTime.parse(dateKey);
                    final dayCheckins = groupedCheckins[dateKey]!;
                    final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == dateKey;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: isToday
                            ? Border.all(color: colorScheme.primary, width: 2)
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isToday)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Aujourd\'hui',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (isToday) const SizedBox(width: 8),
                              Text(
                                DateFormat('EEEE d MMMM', 'fr_FR').format(date),
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...dayCheckins.map((checkin) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Text(
                                  _getMoodEmoji(checkin.mood),
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getMoodLabel(checkin.mood),
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (checkin.note != null && checkin.note!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          checkin.note!,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurface.withOpacity(0.7),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                      Text(
                                        DateFormat('HH:mm').format(checkin.timestamp),
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Erreur de chargement', style: textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }

  String _getMoodEmoji(int mood) {
    switch (mood) {
      case 1:
        return '😔';
      case 2:
        return '😐';
      case 3:
        return '🙂';
      case 4:
        return '😊';
      case 5:
        return '🥰';
      default:
        return '😐';
    }
  }

  String _getMoodLabel(int mood) {
    switch (mood) {
      case 1:
        return 'Difficile';
      case 2:
        return 'Neutre';
      case 3:
        return 'Bien';
      case 4:
        return 'Heureux';
      case 5:
        return 'Excellent';
      default:
        return 'Neutre';
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}