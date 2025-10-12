// lib/features/me_dashboard/presentation/me_dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lova/features/me_dashboard/providers/me_providers.dart';
import 'package:lova/features/me_dashboard/presentation/widgets/emotional_state_card.dart';
import 'package:lova/features/me_dashboard/presentation/widgets/no_intention_cta.dart';
import 'package:lova/features/me_dashboard/presentation/widgets/intention_dashboard_card.dart';
import 'package:lova/features/me_dashboard/providers/intentions_providers.dart';

class MeDashboardView extends ConsumerStatefulWidget {
  const MeDashboardView({super.key});

  @override
  ConsumerState<MeDashboardView> createState() => _MeDashboardViewState();
}

class _MeDashboardViewState extends ConsumerState<MeDashboardView> {
  @override
  void initState() {
    super.initState();
    // Après changement de compte/session, on invalide et on rafraîchit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(streakProvider);
      ref.invalidate(weekMetricsProvider);
      ref.invalidate(todayCheckinProvider);
      ref.invalidate(currentMonthCheckinsCountProvider);
      ref.invalidate(lastMonthSummaryProvider);

      ref.refresh(streakProvider);
      ref.refresh(weekMetricsProvider);
      ref.refresh(todayCheckinProvider);
      ref.refresh(currentMonthCheckinsCountProvider);
      ref.refresh(lastMonthSummaryProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final streakAsync = ref.watch(streakProvider);
    final todayCheckinAsync = ref.watch(todayCheckinProvider);
    final primaryIntentionAsync = ref.watch(primaryActiveIntentionProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🎯 1. ÉTAT ÉMOTIONNEL (HERO CARD)
          const EmotionalStateCard(),

          const SizedBox(height: 20),

          // 🔥 2. STREAK ENRICHI
          _buildEnrichedStreakCard(
            context,
            streakAsync,
            todayCheckinAsync,
          ),

          const SizedBox(height: 20),

          // ⚡ 3. QUICK ACTIONS (avec badge notification)
          todayCheckinAsync.when(
            data: (todayCheckin) {
              return Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      icon: Icons.check_circle_outline,
                      label: 'Check-in',
                      hasNotification: todayCheckin == null, // Badge si pas fait
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
              );
            },
            loading: () => _buildQuickActionsLoading(context),
            error: (_, __) => _buildQuickActionsLoading(context),
          ),

          const SizedBox(height: 20),

          // 🎯 4. MON INTENTION
          primaryIntentionAsync.when(
            data: (intention) {
              if (intention == null) {
                return const NoIntentionCTA();
              }
              return IntentionDashboardCard(intention: intention);
            },
            loading: () => Container(
              height: 200,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 🔥 NOUVEAU : Streak enrichi avec contexte
  // 🔥 CORRIGÉ : Streak enrichi sans lastCheckinDate
  Widget _buildEnrichedStreakCard(
      BuildContext context,
      AsyncValue<dynamic> streakAsync,
      AsyncValue<dynamic> todayCheckinAsync,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
      child: streakAsync.when(
        data: (streak) {
          final streakDays = streak?.currentStreak ?? 0;

          return Row(
            children: [
              // Icône de feu
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: colorScheme.primary,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // Contenu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$streakDays',
                          style: textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'jour${streakDays > 1 ? 's' : ''}',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Streak de connexion',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),

                    // Contexte enrichi : check-in du jour
                    const SizedBox(height: 8),
                    todayCheckinAsync.when(
                      data: (todayCheckin) {
                        if (todayCheckin != null) {
                          // Check-in fait aujourd'hui
                          final time = DateFormat.Hm('fr_FR').format(todayCheckin.timestamp);
                          return Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Check-in fait aujourd\'hui à $time',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Pas encore fait aujourd'hui
                          return Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 14,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Check-in pas encore fait aujourd\'hui',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) => Center(
          child: Text(
            'Erreur de chargement',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }

  // ⚡ Quick Action avec badge notification optionnel
  // ⚡ Quick Action avec badge notification optionnel - CORRIGÉ
  Widget _buildQuickAction(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
        bool hasNotification = false,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8), // ✅ Ajout padding horizontal
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasNotification
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outline.withOpacity(0.2),
            width: hasNotification ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none, // ✅ Permet au badge de dépasser
          children: [
            // ✅ Centré avec Center widget
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // ✅ Taille minimale
                mainAxisAlignment: MainAxisAlignment.center, // ✅ Centré verticalement
                crossAxisAlignment: CrossAxisAlignment.center, // ✅ Centré horizontalement
                children: [
                  Icon(
                    icon,
                    color: hasNotification
                        ? colorScheme.primary
                        : colorScheme.primary.withOpacity(0.7),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: hasNotification ? FontWeight.w600 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1, // ✅ Une seule ligne
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Badge de notification
            if (hasNotification)
              Positioned(
                top: -4, // ✅ Positionné au-dessus du container
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.surface,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Loading state pour les quick actions
  Widget _buildQuickActionsLoading(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
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
    );
  }
}