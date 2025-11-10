import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:lova/features/profile/providers/profile_providers.dart';

// lib/features/profile/presentation/pages/journal_history_page.dart

class RitualsHistorySection extends ConsumerStatefulWidget {
  const RitualsHistorySection({super.key});

  @override
  ConsumerState<RitualsHistorySection> createState() => _RitualsHistorySectionState();
}

class _RitualsHistorySectionState extends ConsumerState<RitualsHistorySection> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final ritualsAsync = ref.watch(ritualsHistoryProvider(30));

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Historique des rituels'),
        backgroundColor: colorScheme.surface,
        actions: [
          PopupMenuButton<String?>(
            icon: Icon(Icons.filter_list, color: colorScheme.onSurface),
            onSelected: (value) {
              setState(() {
                _selectedType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('Tous')),
              const PopupMenuItem(value: 'respiration', child: Text('Respiration')),
              const PopupMenuItem(value: 'meditation', child: Text('Méditation')),
              const PopupMenuItem(value: 'gratitude', child: Text('Gratitude')),
              const PopupMenuItem(value: 'lecture', child: Text('Lecture')),
              const PopupMenuItem(value: 'marche', child: Text('Marche')),
              const PopupMenuItem(value: 'etirement', child: Text('Étirement')),
            ],
          ),
        ],
      ),
      body: ritualsAsync.when(
        data: (itemsRaw) {
          final items = List<Map<String, dynamic>>.from(itemsRaw);
          // Filtre éventuel par type
          final filtered = _selectedType == null
              ? items
              : items.where((e) => (e['type'] ?? '') == _selectedType).toList();

          // Fenêtre 7 jours glissants
          final now = DateTime.now();
          final weekStart = now.subtract(const Duration(days: 7));
          final weekItems = filtered.where((e) {
            final d = e['date'] ?? e['ts'] ?? e['created_at'];
            if (d == null) return false;
            final dt = DateTime.tryParse(d.toString());
            if (dt == null) return false;
            return !dt.isBefore(weekStart);
          }).toList();

          // Stats
          final weekCount = weekItems.length;
          final weekMinutes = weekItems.fold<int>(
            0,
            (sum, e) => sum + (e['duration_min'] is int
                ? e['duration_min'] as int
                : int.tryParse('${e['duration_min'] ?? 0}') ?? 0),
          );

          // Streak jours consécutifs
          final daySet = <String>{};
          for (final e in filtered) {
            final d = e['date'] ?? e['ts'] ?? e['created_at'];
            final dt = d == null ? null : DateTime.tryParse(d.toString());
            if (dt != null) {
              daySet.add(DateFormat('yyyy-MM-dd').format(dt.toLocal()));
            }
          }
          int streak = 0;
          var cursor = DateTime(now.year, now.month, now.day);
          while (daySet.contains(DateFormat('yyyy-MM-dd').format(cursor))) {
            streak += 1;
            cursor = cursor.subtract(const Duration(days: 1));
          }

          // Répartition par type
          final byType = <String, Map<String, int>>{};
          for (final e in filtered) {
            final t = (e['type'] ?? 'unknown').toString();
            final mins = e['duration_min'] is int
                ? e['duration_min'] as int
                : int.tryParse('${e['duration_min'] ?? 0}') ?? 0;
            byType.putIfAbsent(t, () => {'count': 0, 'minutes': 0});
            byType[t]!['count'] = (byType[t]!['count'] ?? 0) + 1;
            byType[t]!['minutes'] = (byType[t]!['minutes'] ?? 0) + mins;
          }
          int getCount(String t) => byType[t]?['count'] ?? 0;
          int getMins(String t) => byType[t]?['minutes'] ?? 0;

          Widget historyList(BuildContext context) {
            if (filtered.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.spa_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun rituel pour le moment',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Commencez votre premier rituel',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final e = filtered[index];
                final type = (e['type'] ?? 'rituel').toString();
                final title = (e['title'] ?? '').toString().isEmpty ? type : e['title'].toString();
                final mins = e['duration_min'] is int
                    ? e['duration_min'] as int
                    : int.tryParse('${e['duration_min'] ?? 0}') ?? 0;
                final dateStr = (e['date'] ?? e['ts'] ?? e['created_at'])?.toString() ?? '';
                final dt = DateTime.tryParse(dateStr);
                final pretty = dt != null ? DateFormat('EEE d MMM • HH:mm', 'fr_FR').format(dt.toLocal()) : '';

                IconData icon;
                switch (type) {
                  case 'respiration':
                    icon = Icons.air;
                    break;
                  case 'meditation':
                    icon = Icons.self_improvement;
                    break;
                  case 'gratitude':
                    icon = Icons.favorite_border;
                    break;
                  case 'lecture':
                    icon = Icons.menu_book;
                    break;
                  case 'marche':
                    icon = Icons.directions_walk;
                    break;
                  case 'etirement':
                    icon = Icons.accessibility_new;
                    break;
                  default:
                    icon = Icons.spa_outlined;
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '$pretty  •  ${mins} min',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                );
              },
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats hebdo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cette semaine',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              context,
                              '$weekCount',
                              'Rituels',
                              Icons.self_improvement,
                              Theme.of(context).colorScheme.primary,
                            ),
                            _buildStatItem(
                              context,
                              '${weekMinutes} min',
                              'Temps total',
                              Icons.timer,
                              Colors.blue,
                            ),
                            _buildStatItem(
                              context,
                              '${streak} j',
                              'Streak',
                              Icons.local_fire_department,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Répartition par type
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Répartition par type',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTypeRow(context, 'Respiration', Icons.air, getCount('respiration'), getMins('respiration')),
                        _buildTypeRow(context, 'Méditation', Icons.self_improvement, getCount('meditation'), getMins('meditation')),
                        _buildTypeRow(context, 'Gratitude', Icons.favorite_border, getCount('gratitude'), getMins('gratitude')),
                        _buildTypeRow(context, 'Lecture', Icons.menu_book, getCount('lecture'), getMins('lecture')),
                        _buildTypeRow(context, 'Marche', Icons.directions_walk, getCount('marche'), getMins('marche')),
                        _buildTypeRow(context, 'Étirement', Icons.accessibility_new, getCount('etirement'), getMins('etirement')),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Historique
                  Text(
                    'Historique',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  historyList(context),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Erreur de chargement: $e'),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String value,
      String label,
      IconData icon,
      Color color,
      ) {
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

  Widget _buildTypeRow(
      BuildContext context,
      String label,
      IconData icon,
      int count,
      int minutes,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$count fois',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '•',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$minutes min',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}