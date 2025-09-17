// lib/features/onboarding/presentation/widgets/onboarding_completion_dialog.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingCompletionDialog extends StatefulWidget {
  final String firstName;
  final String status;
  final VoidCallback onComplete;

  const OnboardingCompletionDialog({
    super.key,
    required this.firstName,
    required this.status,
    required this.onComplete,
  });

  static Future<void> show({
    required BuildContext context,
    required String firstName,
    required String status,
    required VoidCallback onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) => OnboardingCompletionDialog(
        firstName: firstName,
        status: status,
        onComplete: onComplete,
      ),
    );
  }

  @override
  State<OnboardingCompletionDialog> createState() => _OnboardingCompletionDialogState();
}

class _OnboardingCompletionDialogState extends State<OnboardingCompletionDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  late List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();

    // Animation principale du dialog
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Animation des confettis
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Particules de confettis
    _particles = List.generate(50, (index) => _ConfettiParticle());

    // Démarrage
    _scaleController.forward();
    _confettiController.forward();

    // Auto-navigation après 3 secondes
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      widget.onComplete();
      context.go('/dashboard');
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Confettis en arrière-plan
        ...List.generate(_particles.length, (index) {
          return AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              final particle = _particles[index];
              final progress = _confettiController.value;

              return Positioned(
                left: particle.x * MediaQuery.of(context).size.width,
                top: (particle.y + progress * 2) * MediaQuery.of(context).size.height,
                child: Transform.rotate(
                  angle: progress * particle.rotation * 2 * math.pi,
                  child: Opacity(
                    opacity: 1 - progress * 0.8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: particle.color,
                        shape: particle.isCircle ? BoxShape.circle : BoxShape.rectangle,
                        borderRadius: particle.isCircle ? null : BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // Dialog principal
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.secondaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icône de succès animée (flutter_animate)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🎉', style: TextStyle(fontSize: 40)),
                      ),
                    )
                        .animate()
                        .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 800.ms, curve: Curves.elasticOut, delay: 300.ms),

                    const SizedBox(height: 24),

                    // Message de félicitations
                    Text(
                      'Félicitations ${widget.firstName} !',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 300.ms),

                    const SizedBox(height: 12),

                    // Sous-titre personnalisé
                    Text(
                      widget.status == 'couple'
                          ? 'Votre voyage à deux commence maintenant'
                          : 'Votre voyage vers l\'amour commence',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

                    const SizedBox(height: 32),

                    // Barre de progression
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 3),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                              minHeight: 4,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Redirection automatique...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.6),
                              ),
                            ),
                          ],
                        );
                      },
                    ).animate().fadeIn(duration: 300.ms, delay: 250.ms),

                    const SizedBox(height: 24),

                    // Bouton pour continuer immédiatement
                    TextButton(
                      onPressed: () {
                        widget.onComplete();
                        context.go('/dashboard');
                      },
                      child: Text(
                        'Continuer maintenant →',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Classe pour les particules de confetti
class _ConfettiParticle {
  final double x;
  final double y;
  final double rotation;
  final Color color;
  final bool isCircle;

  _ConfettiParticle()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble() * 0.5 - 0.5,
        rotation = math.Random().nextDouble(),
        color = _randomColor(),
        isCircle = math.Random().nextBool();

  static Color _randomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    return colors[math.Random().nextInt(colors.length)];
  }
}