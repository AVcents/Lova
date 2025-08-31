import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../metrics/gauge_provider.dart';
import 'me_dashboard_view.dart';
import 'us_dashboard_view.dart';
import 'widgets/action_bar.dart';
import '../../shared/providers/dashboard_mode_provider.dart';
import 'package:go_router/go_router.dart';

class RelationDashboardPage extends ConsumerStatefulWidget {
  const RelationDashboardPage({super.key});

  @override
  ConsumerState<RelationDashboardPage> createState() => _RelationDashboardPageState();
}

class _RelationDashboardPageState extends ConsumerState<RelationDashboardPage>
    with TickerProviderStateMixin {
  bool isBreakupPressed = false;
  double breakupProgress = 0.0;
  late AnimationController _breakupController;
  late AnimationController _cardController;

  @override
  void initState() {
    super.initState();
    _breakupController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _breakupController.addListener(() {
      setState(() {
        breakupProgress = _breakupController.value;
      });

      if (_breakupController.value >= 1.0) {
        _showBreakupConfirmation();
      }
    });
  }

  @override
  void dispose() {
    _breakupController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _showBreakupConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fin de relation'),
          content: const Text('Êtes-vous sûr de vouloir mettre fin à cette relation ?'),
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
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  void _resetBreakup() {
    setState(() {
      isBreakupPressed = false;
      breakupProgress = 0.0;
    });
    _breakupController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardMode = ref.watch(dashboardModeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec profil, switch ME/US et notifications
            _buildHeader(dashboardMode),

            // Corps principal avec AnimatedSwitcher
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.98,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: dashboardMode == DashboardMode.me
                    ? const MeDashboardView(key: ValueKey('me'))
                    : const UsDashboardView(key: ValueKey('us')),
              ),
            ),

            // Boutons d'action (croix, cœur, message)
            RelationActionBar(mode: dashboardMode),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DashboardMode currentMode) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Bouton profil
          GestureDetector(
            onTap: () => context.go('/settings'),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.onBackground.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person,
                color: colorScheme.onBackground,
                size: 24,
              ),
            ),
          ),

          const Spacer(),

          // Switch ME/US
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: colorScheme.onBackground.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModeButton(
                  'ME',
                  DashboardMode.me,
                  currentMode == DashboardMode.me,
                ),
                _buildModeButton(
                  'US',
                  DashboardMode.us,
                  currentMode == DashboardMode.us,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bouton notifications
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications')),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.onBackground.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: colorScheme.onBackground,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String text, DashboardMode mode, bool isActive) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await ref.read(dashboardModeProvider.notifier).setMode(mode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: textTheme.bodyMedium?.copyWith(
            color: isActive
                ? colorScheme.onSecondary
                : colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton de rupture avec progress
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                isBreakupPressed = true;
              });
              _breakupController.forward();
            },
            onTapUp: (_) => _resetBreakup(),
            onTapCancel: () => _resetBreakup(),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface,
                border: Border.all(
                  color: isBreakupPressed
                      ? colorScheme.error
                      : colorScheme.onSurface.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isBreakupPressed)
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        value: breakupProgress,
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.error),
                      ),
                    ),
                  Icon(
                    Icons.close,
                    color: isBreakupPressed
                        ? colorScheme.error
                        : colorScheme.onSurface,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),

          // Bouton principal (like/love)
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.favorite,
              color: colorScheme.onPrimary,
              size: 32,
            ),
          ),

          // Bouton message
          GestureDetector(
            onTap: () => context.go('/chat-couple'),
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
                Icons.chat_bubble_outline,
                color: colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Classe SuggestionCard conservée pour la compatibilité
class SuggestionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const SuggestionCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 3,
      color: colorScheme.surface,
      child: ListTile(
        title: Text(
          title,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          description,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: colorScheme.onSurface.withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }
}