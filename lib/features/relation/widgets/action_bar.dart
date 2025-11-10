// lib/features/relation/widgets/action_bar.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lova/shared/providers/dashboard_mode_provider.dart';
import 'package:lova/shared/providers/tanks_provider.dart';
import 'package:lova/shared/ui/semantic_colors.dart';
import 'package:lova/features/relation/widgets/love_tank_gauge.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/profile/providers/profile_providers.dart';
import 'package:lova/shared/animations/circle_reveal_route.dart';
import 'package:lova/shared/animations/circle_reveal_route.dart';
import 'package:lova/features/profile/presentation/checkin_page.dart';
import 'package:lova/features/profile/presentation/journal_page.dart';
import 'package:lova/features/profile/presentation/rituals_selection_page.dart';
import 'package:lova/features/relation/dashboard/screens/checkin/couple_checkin_screen.dart';
import 'package:lova/features/relation/dashboard/screens/games/games_library_screen.dart';
import 'package:lova/features/relation/dashboard/screens/rituals/couple_rituals_library_screen.dart';
class RelationActionBar extends ConsumerStatefulWidget {
  final DashboardMode mode;

  const RelationActionBar({super.key, required this.mode});

  @override
  ConsumerState<RelationActionBar> createState() => _RelationActionBarState();
}

class _RelationActionBarState extends ConsumerState<RelationActionBar>
    with TickerProviderStateMixin {
  // ============================================
  // VARIABLES D'ÉTAT - MODE US (COUPLE)
  // ============================================
  final GlobalKey _coupleCheckinButtonKey = GlobalKey();
  final GlobalKey _coupleRitualsButtonKey = GlobalKey();
  final GlobalKey _connectionGamesButtonKey = GlobalKey();

// ============================================
// VARIABLES D'ÉTAT - MODE ME (ANIMATION)
// ============================================
  final GlobalKey _checkinButtonKey = GlobalKey();
  final GlobalKey _ritualsButtonKey = GlobalKey();
  final GlobalKey _journalButtonKey = GlobalKey();

  // ============================================
  // LIFECYCLE
  // ============================================
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ============================================
  // BUILD PRINCIPAL
  // ============================================
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: widget.mode == DashboardMode.us
            ? _buildUsActions(key: const ValueKey('us'))
            : _buildMeActions(key: const ValueKey('me')),
      ),
    );
  }

  // ============================================
  // 💑 MODE US (COUPLE) - ACTIONS
  // ============================================
  Widget _buildUsActions({Key? key}) {
    // TODO: brancher relationshipProvider, todayCoupleCheckinProvider, todayCoupleRitualProvider
    final double relationshipGauge = 0.85; // valeur par défaut 85%
    final bool hasCheckinNotification = false;
    final bool hasRitualNotification = false;

    return Row(
      key: key,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bouton Check-in de couple (gauche)
        _buildCoupleCheckinButton(hasNotification: hasCheckinNotification),

        // Gauge centrale Rituels de couple (centre)
        _buildCoupleRitualsGauge(
          value: relationshipGauge,
          hasNotification: hasRitualNotification,
        ),

        // Bouton Jeux de connexion (droite)
        _buildConnectionGamesButton(),
      ],
    );
  }


  // ============================================
  // 💑 MODE US (COUPLE) — NOUVEAUX BOUTONS MODERNES
  // ============================================
  Widget _buildCoupleCheckinButton({bool hasNotification = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      key: _coupleCheckinButtonKey,
      onTap: () {
        HapticFeedback.mediumImpact();
        context.pushWithCircleReveal(
          page: const CoupleCheckinScreen(),
          buttonKey: _coupleCheckinButtonKey,
          gradientColors: hasNotification
              ? const [Color(0xFFFF6B9D), Color(0xFFFFA06B)]
              : [colorScheme.primaryContainer, colorScheme.secondaryContainer],
        );
      },
      child: Semantics(
        label: 'Check-in de couple',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 65.0,
          height: 65.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: hasNotification
                  ? [const Color(0xFFFF6B9D), const Color(0xFFFFA06B)]
                  : [colorScheme.primaryContainer, colorScheme.secondaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: hasNotification
                    ? const Color(0xFFFF6B9D).withOpacity(0.4)
                    : colorScheme.primary.withOpacity(0.2),
                blurRadius: hasNotification ? 16.0 : 10.0,
                offset: const Offset(0.0, 4.0),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              if (hasNotification)
                Positioned(
                  top: 6.0,
                  right: 6.0,
                  child: Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFFF6B9D), width: 2.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoupleRitualsGauge({
    required double value,
    bool hasNotification = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final percentage = (value * 100).round();

    return GestureDetector(
      key: _coupleRitualsButtonKey,
      onTap: () {
        HapticFeedback.mediumImpact();
        context.pushWithCircleReveal(
          page: const CoupleRitualsLibraryScreen(),
          buttonKey: _coupleRitualsButtonKey,
          gradientColors: hasNotification
              ? const [Color(0xFFFF6B35), Color(0xFFFF9068)]
              : [colorScheme.primaryContainer, colorScheme.secondaryContainer],
        );
      },
      child: Semantics(
        label: 'Rituels de couple',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: hasNotification
                  ? [const Color(0xFFFF6B35), const Color(0xFFFF9068)]
                  : [
                      colorScheme.primaryContainer.withOpacity(0.8),
                      colorScheme.secondaryContainer.withOpacity(0.8),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: hasNotification
                    ? const Color(0xFFFF6B35).withOpacity(0.5)
                    : colorScheme.primary.withOpacity(0.25),
                blurRadius: hasNotification ? 20.0 : 12.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 70.0,
                  height: 70.0,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 4.0,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.white,
                      size: 26.0,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasNotification)
                Positioned(
                  top: 4.0,
                  right: 4.0,
                  child: Container(
                    width: 16.0,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFFF6B35), width: 2.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionGamesButton({bool hasNotification = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      key: _connectionGamesButtonKey,
      onTap: () {
        HapticFeedback.mediumImpact();
        context.pushWithCircleReveal(
          page: const GamesLibraryScreen(),
          buttonKey: _connectionGamesButtonKey,
          gradientColors: const [Color(0xFFE91E63), Color(0xFF9C27B0)],
        );
      },
      child: Semantics(
        label: 'Jeux de connexion',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 65.0,
          height: 65.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.sports_esports_rounded,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================
  // 🧘 MODE ME - ACTIONS
  // ============================================
  Widget _buildMeActions({Key? key}) {
    final meTankState = ref.watch(meTankProvider);
    final todayCheckinAsync = ref.watch(todayCheckinProvider);
    final todayRitualAsync = ref.watch(todayRitualProvider);
    final todayJournalAsync = ref.watch(todayJournalProvider);

    return Row(
      key: key,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        todayCheckinAsync.when(
          data: (checkin) =>
              _buildModernCheckinButton(hasNotification: checkin == null),
          loading: () => _buildModernCheckinButton(hasNotification: false),
          error: (_, __) => _buildModernCheckinButton(hasNotification: false),
        ),
        todayRitualAsync.when(
          data: (ritual) =>
              _buildModernTankGauge(
                value: meTankState.value.toDouble(),
                hasNotification: ritual == null,
              ),
          loading: () =>
              _buildModernTankGauge(
                value: meTankState.value.toDouble(),
                hasNotification: false,
              ),
          error: (_, __) =>
              _buildModernTankGauge(
                value: meTankState.value.toDouble(),
                hasNotification: false,
              ),
        ),
        todayJournalAsync.when(
          data: (journal) =>
              _buildModernJournalButton(hasNotification: journal == null),
          loading: () => _buildModernJournalButton(hasNotification: false),
          error: (_, __) => _buildModernJournalButton(hasNotification: false),
        ),
      ],
    );
  }

  // ============================================
  // 🧘 MODE ME - BOUTON CHECK-IN (MODERNE)
  // ============================================
  Widget _buildModernCheckinButton({bool hasNotification = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      key: _checkinButtonKey,
      onTap: () {
        HapticFeedback.mediumImpact();

        // ✅ Animation toujours activée
        context.pushWithCircleReveal(
          page: const CheckinPage(),
          buttonKey: _checkinButtonKey,
          gradientColors: hasNotification
              ? const [
            Color(0xFFFF6B9D),
            Color(0xFFFFA06B),
          ]
              : [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        );
      },
      child: Semantics(
        label: 'Check-in',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 65.0,
          height: 65.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: hasNotification
                  ? [
                const Color(0xFFFF6B9D),
                const Color(0xFFFFA06B),
              ]
                  : [
                colorScheme.primaryContainer,
                colorScheme.secondaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: hasNotification
                    ? const Color(0xFFFF6B9D).withOpacity(0.4)
                    : colorScheme.primary.withOpacity(0.2),
                blurRadius: hasNotification ? 16.0 : 10.0,
                offset: const Offset(0.0, 4.0),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  hasNotification ? Icons.favorite : Icons.favorite_rounded,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              if (hasNotification)
                Positioned(
                  top: 6.0,
                  right: 6.0,
                  child: Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFF6B9D),
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // 🧘 MODE ME - TANK GAUGE (MODERNE)
  // ============================================
  Widget _buildModernTankGauge({
    required double value,
    bool hasNotification = false,
  }) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    final percentage = (value * 100).round();

    return GestureDetector(
      key: _ritualsButtonKey,
      onTap: () {
        HapticFeedback.mediumImpact();

        // ✅ Animation toujours activée
        context.pushWithCircleReveal(
          page: const RitualsSelectionPage(),
          buttonKey: _ritualsButtonKey,
          gradientColors: hasNotification
              ? const [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ]
              : [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        );
      },
      child: Semantics(
        label: 'Rituels rapides',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: hasNotification
                  ? [
                const Color(0xFF667EEA),
                const Color(0xFF764BA2),
              ]
                  : [
                colorScheme.primaryContainer.withOpacity(0.8),
                colorScheme.secondaryContainer.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: hasNotification
                    ? const Color(0xFF667EEA).withOpacity(0.5)
                    : colorScheme.primary.withOpacity(0.25),
                blurRadius: hasNotification ? 20.0 : 12.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 70.0,
                  height: 70.0,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 4.0,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.self_improvement,
                      color: Colors.white,
                      size: 26.0,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasNotification)
                Positioned(
                  top: 4.0,
                  right: 4.0,
                  child: Container(
                    width: 16.0,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF667EEA),
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // 🧘 MODE ME - BOUTON JOURNAL (MODERNE)
  // ============================================
  Widget _buildModernJournalButton({bool hasNotification = false}) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return GestureDetector(
      key: _journalButtonKey,
      onTap: () {
        HapticFeedback.mediumImpact();

        // ✅ Animation toujours activée
        context.pushWithCircleReveal(
          page: const JournalPage(),
          buttonKey: _journalButtonKey,
          gradientColors: hasNotification
              ? const [
            Color(0xFFF093FB),
            Color(0xFFF5576C),
          ]
              : [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        );
      },
      child: Semantics(
        label: 'Journal rapide',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 65.0,
          height: 65.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: hasNotification
                  ? [
                const Color(0xFFF093FB),
                const Color(0xFFF5576C),
              ]
                  : [
                colorScheme.primaryContainer,
                colorScheme.secondaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: hasNotification
                    ? const Color(0xFFF093FB).withOpacity(0.4)
                    : colorScheme.primary.withOpacity(0.2),
                blurRadius: hasNotification ? 16.0 : 10.0,
                offset: const Offset(0.0, 4.0),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: hasNotification ? Colors.white : colorScheme.primary,
                  size: 30.0,
                ),
              ),
              if (hasNotification)
                Positioned(
                  top: 6.0,
                  right: 6.0,
                  child: Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF093FB),
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}