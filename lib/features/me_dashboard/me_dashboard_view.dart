// lib/features/relation/me_dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/me_dashboard/presentation/checkin_page.dart';
import 'package:lova/features/me_dashboard/presentation/journal_page.dart';
import 'package:lova/features/me_dashboard/presentation/rituals_selection_page.dart';
import 'package:lova/features/me_dashboard/providers/me_providers.dart';
import 'package:lova/features/me_dashboard/presentation/widgets/emotional_state_card.dart';

class MeDashboardView extends ConsumerStatefulWidget {
  const MeDashboardView({super.key});

  @override
  ConsumerState<MeDashboardView> createState() => _MeDashboardViewState();
}

class _MeDashboardViewState extends ConsumerState<MeDashboardView> {
  String? selectedMood;

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Heureux', 'value': 5},
    {'emoji': '😌', 'label': 'Calme', 'value': 4},
    {'emoji': '😐', 'label': 'Neutre', 'value': 3},
    {'emoji': '😔', 'label': 'Triste', 'value': 2},
    {'emoji': '😤', 'label': 'Frustré', 'value': 1},
  ];

  Future<void> _saveCheckin(int mood) async {
    final notifier = ref.read(checkinNotifierProvider.notifier);
    final success = await notifier.createCheckin(mood: mood);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Check-in enregistré'),
          duration: Duration(seconds: 2),
        ),
      );
      // Refresh les données
      ref.invalidate(streakProvider);
      ref.invalidate(weekMetricsProvider);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in déjà effectué aujourd\'hui'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch les données en temps réel
    final streakAsync = ref.watch(streakProvider);
    final metricsAsync = ref.watch(weekMetricsProvider);
    final todayCheckinAsync = ref.watch(todayCheckinProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Carte héro - Humeur du jour
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Gradient décoratif subtil
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                          const Color(0xFFA12539).withOpacity(0.1),
                          const Color(0xFFFF5A6E).withOpacity(0.1),
                        ]
                            : [
                          const Color(0xFFFFA38F).withOpacity(0.08),
                          const Color(0xFFFF6FA5).withOpacity(0.08),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comment je me sens',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // État du check-in
                      todayCheckinAsync.when(
                        data: (checkin) {
                          if (checkin != null) {
                            // Déjà fait aujourd'hui
                            final moodData = moods.firstWhere(
                                  (m) => m['value'] == checkin.mood,
                              orElse: () => moods[2],
                            );
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    moodData['emoji'],
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Check-in du jour',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                      ),
                                      Text(
                                        moodData['label'],
                                        style: textTheme.titleMedium?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }

                          // Pas encore fait - afficher les chips
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: moods.map((mood) {
                              final isSelected = selectedMood == mood['value'].toString();
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedMood = mood['value'].toString();
                                  });
                                  HapticFeedback.lightImpact();
                                  _saveCheckin(mood['value']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colorScheme.primaryContainer
                                        : colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.outline.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        mood['emoji'],
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        mood['label'],
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: isSelected
                                              ? colorScheme.onPrimaryContainer
                                              : colorScheme.onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (_, __) => const Text('Erreur de chargement'),
                      ),

                      const SizedBox(height: 20),

                      // Streak
                      streakAsync.when(
                        data: (streak) {
                          final streakDays = streak?.currentStreak ?? 0;
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color: colorScheme.primary,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$streakDays jour${streakDays > 1 ? 's' : ''}',
                                      style: textTheme.titleLarge?.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Streak de connexion',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CTA Principal
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: Text(
              'Conseil pour moi',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 20),

// Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  context,
                  icon: Icons.check_circle_outline,
                  label: 'Check-in',
                  onTap: () {
                    context.pushNamed('meCheckinsHistory');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  context,
                  icon: Icons.self_improvement,
                  label: 'Rituels',
                  onTap: () {
                    context.pushNamed('meRitualHistory');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  context,
                  icon: Icons.edit_note,
                  label: 'Journal',
                  onTap: () {
                    context.pushNamed('meJournalHistory');
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Insights personnels
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card État émotionnel améliorée
              const EmotionalStateCard(),
              const SizedBox(height: 16),
              // Conseil du jour (conservé)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Conseil personnalisé à venir'),
                    ),
                  );
                },
                child: _buildInsightCard(
                  context,
                  title: 'Conseil du jour',
                  value: 'Prendre du temps',
                  subtitle: 'Toucher pour voir',
                  icon: Icons.lightbulb_outline,
                  isInteractive: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: colorScheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(
      BuildContext context, {
        required String title,
        required String value,
        required String subtitle,
        required IconData icon,
        bool isInteractive = false,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
              Icon(icon, color: colorScheme.primary.withOpacity(0.7), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              if (isInteractive)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}