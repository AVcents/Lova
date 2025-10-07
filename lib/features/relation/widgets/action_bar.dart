import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lova/shared/providers/dashboard_mode_provider.dart';
import 'package:lova/shared/providers/tanks_provider.dart';
import 'package:lova/shared/ui/semantic_colors.dart';
import 'package:lova/features/relation/widgets/love_tank_gauge.dart';
import 'package:lova/features/relation/widgets/me_tank_gauge.dart';
import 'package:go_router/go_router.dart';

class RelationActionBar extends ConsumerStatefulWidget {
  final DashboardMode mode;

  const RelationActionBar({super.key, required this.mode});

  @override
  ConsumerState<RelationActionBar> createState() => _RelationActionBarState();
}

class _RelationActionBarState extends ConsumerState<RelationActionBar>
    with TickerProviderStateMixin {
  // Pour le mode US - Rupture
  bool _isBreakupPressed = false;
  double _breakupProgress = 0.0;
  late AnimationController _breakupController;
  int _warningStage = 0; // 0: none, 1: 30%, 2: 60%, 3: 90%

  @override
  void initState() {
    super.initState();
    _breakupController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _breakupController.addListener(() {
      setState(() {
        _breakupProgress = _breakupController.value;

        // Gestion des avertissements
        if (_breakupProgress >= 0.3 && _warningStage < 1) {
          _warningStage = 1;
          _showWarningBanner('Respirer 1 min ?');
          HapticFeedback.lightImpact();
        } else if (_breakupProgress >= 0.6 && _warningStage < 2) {
          _warningStage = 2;
          _showWarningBanner('Essayer Médiation SOS ?');
          HapticFeedback.mediumImpact();
        } else if (_breakupProgress >= 0.9 && _warningStage < 3) {
          _warningStage = 3;
          _showWarningBanner('Vraiment certain ?');
          HapticFeedback.heavyImpact();
        }
      });

      if (_breakupController.value >= 1.0) {
        _showBreakupConfirmation();
      }
    });
  }

  @override
  void dispose() {
    _breakupController.dispose();
    super.dispose();
  }

  void _showWarningBanner(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: SemanticColors.warning(context),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
      ),
    );
  }

  void _showBreakupConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          title: Text(
            'Fin de relation',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'C\'est important. Es-tu certain de vouloir mettre fin à cette relation ?',
            style: textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetBreakup();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Relation terminée')),
                );
                _resetBreakup();
              },
              style: TextButton.styleFrom(foregroundColor: colorScheme.error),
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  void _resetBreakup() {
    setState(() {
      _isBreakupPressed = false;
      _breakupProgress = 0.0;
      _warningStage = 0;
    });
    _breakupController.reset();
  }

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

  Widget _buildUsActions({Key? key}) {
    final loveTankState = ref.watch(loveTankProvider);

    return Row(
      key: key,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bouton Rupture (gauche)
        _buildBreakupButton(),

        // Love Tank Gauge (centre)
        Semantics(
          label: 'Booster notre jauge',
          child: LoveTankGauge(
            value: loveTankState.value,
            onTap: () => showLoveTankBoosterSheet(context, ref),
          ),
        ),

        // Moment+ (droite)
        _buildMomentButton(),
      ],
    );
  }

  Widget _buildMeActions({Key? key}) {
    final meTankState = ref.watch(meTankProvider);

    return Row(
      key: key,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Check-in (gauche)
        _buildCheckinButton(),

        // Me Tank Gauge (centre)
        Semantics(
          label: 'Rituels rapides',
          child: MeTankGauge(
            value: meTankState.value,
            onTap: () => context.pushNamed('meRituals'),
          ),
        ),

        // Journal+ (droite)
        _buildJournalButton(),
      ],
    );
  }

  Widget _buildBreakupButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isBreakupPressed = true;
        });
        _breakupController.forward();
      },
      onTapUp: (_) => _resetBreakup(),
      onTapCancel: () => _resetBreakup(),
      child: Semantics(
        label: 'Rupture',
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            border: Border.all(
              color: _isBreakupPressed
                  ? colorScheme.error.withOpacity(
                      0.5 + (_breakupProgress * 0.5),
                    )
                  : colorScheme.onSurface.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isBreakupPressed)
                SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    value: _breakupProgress,
                    strokeWidth: 3,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.error.withOpacity(0.7),
                    ),
                  ),
                ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _breakupProgress > 0.5 ? Icons.heart_broken : Icons.close,
                  color: _isBreakupPressed
                      ? colorScheme.error
                      : colorScheme.onSurface,
                  size: 28,
                  key: ValueKey(_breakupProgress > 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMomentButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showMomentSheet(),
      child: Semantics(
        label: 'Planifier un moment',
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            border: Border.all(
              color: colorScheme.onSurface.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.add_circle_outline,
            color: colorScheme.primary,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckinButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pushNamed('meCheckin');
      },
      child: Semantics(
        label: 'Check-in humeur',
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            border: Border.all(
              color: colorScheme.onSurface.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(Icons.mood, color: colorScheme.primary, size: 28),
        ),
      ),
    );
  }

  Widget _buildJournalButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pushNamed('meJournal');
      },
      child: Semantics(
        label: 'Journal rapide',
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            border: Border.all(
              color: colorScheme.onSurface.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.menu_book_outlined,
            color: colorScheme.primary,
            size: 28,
          ),
        ),
      ),
    );
  }

  void _showMomentSheet() {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        Widget tile(
          IconData icon,
          String title,
          String subtitle,
          VoidCallback onTap,
        ) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Material(
              color: colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: ListTile(
                  leading: Icon(icon, color: colorScheme.primary),
                  title: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '+8',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        Future<void> planAndClose(String label) async {
          HapticFeedback.lightImpact();
          await ref
              .read(loveTankProvider.notifier)
              .incrementBy(LoveTankAction.planMoment);
          if (mounted) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Moment planifié ($label) +8'),
                backgroundColor: SemanticColors.success(context),
              ),
            );
          }
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Planifier un moment',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              tile(
                Icons.schedule,
                '30 minutes',
                'Aujourd’hui',
                () => planAndClose('30 min aujourd’hui'),
              ),
              tile(
                Icons.alarm,
                '60 minutes',
                'Demain',
                () => planAndClose('60 min demain'),
              ),
              tile(
                Icons.weekend_outlined,
                '120 minutes',
                'Ce week-end',
                () => planAndClose('120 min ce week-end'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

}
