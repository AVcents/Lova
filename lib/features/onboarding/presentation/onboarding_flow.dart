// lib/features/onboarding/presentation/onboarding_flow.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/onboarding_controller.dart';
import '../services/onboarding_analytics_service.dart';
import 'welcome_screen.dart';
import 'status_screen.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';
import 'invite_screen.dart';
import 'widgets/onboarding_completion_dialog.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  static const String name = 'onboarding';

  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController = ref.read(onboardingControllerProvider.notifier);

    // Écouter les changements d'étape
    ref.listen<OnboardingState>(
      onboardingControllerProvider,
          (previous, next) {
        if (previous?.currentStep != next.currentStep) {
          _animateToPage(next.currentStep);
        }
      },
    );

    // Si l'onboarding est complété, rediriger
    ref.listen<OnboardingState>(
      onboardingControllerProvider,
          (previous, next) async {
        final hasCompleted = await ref.read(hasCompletedOnboardingProvider.future);
        if (hasCompleted && context.mounted) {
          context.go('/dashboard');
        }
      },
    );

    // Déterminer le nombre total d'étapes
    final totalSteps = onboardingState.status == 'solo' ? 4 : 5;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Barre de progression
            if (onboardingState.currentStep > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Bouton retour et indicateur d'étape
                    Row(
                      children: [
                        IconButton(
                          onPressed: onboardingController.previousStep,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Spacer(),
                        Text(
                          'Étape ${onboardingState.currentStep} sur $totalSteps',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Barre de progression animée
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: onboardingState.currentStep / totalSteps,
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          minHeight: 4,
                        );
                      },
                    ),
                  ],
                ),
              ),

            // Contenu des écrans
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const WelcomeScreen(),
                  const StatusScreen(),
                  const GoalsScreen(),
                  const ProfileScreen(),
                  if (onboardingState.status == 'couple')
                    const InviteScreen(),
                ],
              ),
            ),

            // Indicateur de chargement global
            if (onboardingState.isLoading)
              const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}