import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:lova/features/profile/providers/profile_providers.dart';

class JournalHistorySection extends ConsumerStatefulWidget {
  const JournalHistorySection({super.key});

  @override
  ConsumerState<JournalHistorySection> createState() => _JournalHistorySectionState();
}

class _JournalHistorySectionState extends ConsumerState<JournalHistorySection> {
  int _selectedDays = 30;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final journalsAsync = ref.watch(journalsHistoryProvider(_selectedDays));

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Historique du journal'),
        backgroundColor: colorScheme.surface,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedDays = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 7, child: Text('7 derniers jours')),
              const PopupMenuItem(value: 30, child: Text('30 derniers jours')),
              const PopupMenuItem(value: 90, child: Text('3 derniers mois')),
            ],
          ),
        ],
      ),
      body: journalsAsync.when(
        data: (journals) {
          if (journals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 80,
                    color: colorScheme.onSurface.withOpacity(0.2),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Aucune entrée',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Commencez à écrire votre journal',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          // Calculer les stats
          final totalEntries = journals.length;
          final totalWords = journals.fold<int>(
            0,
                (sum, j) => sum + (j['word_count'] as int? ?? 0),
          );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            _buildJournalStat(
                              context,
                              '$totalEntries',
                              'Entrées',
                              Icons.edit_note,
                              colorScheme.primary,
                            ),
                            _buildJournalStat(
                              context,
                              '$totalWords',
                              'Mots',
                              Icons.text_fields,
                              Colors.blue,
                            ),
                            _buildJournalStat(
                              context,
                              totalEntries > 0 ? '${(totalWords / totalEntries).round()}' : '0',
                              'Moy/entrée',
                              Icons.analytics,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Liste des entrées
                  Text(
                    'Entrées récentes',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...journals.map((journal) {
                    final dateString = (journal['date'] ?? '').toString();
                    if (dateString.isEmpty) {
                      return const SizedBox.shrink(); // Ne rien afficher si la date est invalide
                    }
                    final date = DateTime.parse(dateString);
                    final text = (journal['text'] ?? '').toString();
                    final wordCount = journal['word_count'] as int? ?? 0;
                    final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
                        DateFormat('yyyy-MM-dd').format(date);

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
                              const Spacer(),
                              Text(
                                '$wordCount mots',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            text,
                            style: textTheme.bodyMedium,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
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

  Widget _buildJournalStat(
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
}
