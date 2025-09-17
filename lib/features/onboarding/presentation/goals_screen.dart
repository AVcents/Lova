// lib/features/onboarding/presentation/goals_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_controller.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  static const List<Map<String, String>> availableGoals = [
    {'id': 'communication', 'label': 'Améliorer la communication', 'emoji': '💬'},
    {'id': 'passion', 'label': 'Raviver la passion', 'emoji': '🔥'},
    {'id': 'trust', 'label': 'Renforcer la confiance', 'emoji': '🤝'},
    {'id': 'intimacy', 'label': 'Développer l\'intimité', 'emoji': '💕'},
    {'id': 'conflict', 'label': 'Gérer les conflits', 'emoji': '⚖️'},
    {'id': 'growth', 'label': 'Grandir ensemble', 'emoji': '🌱'},
    {'id': 'fun', 'label': 'Plus de moments fun', 'emoji': '🎉'},
    {'id': 'understanding', 'label': 'Mieux se comprendre', 'emoji': '🧠'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Titre
          Text(
            'Quels sont vos objectifs ?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            'Sélectionnez tout ce qui vous correspond',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Grille d'objectifs
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: availableGoals.length,
              itemBuilder: (context, index) {
                final goal = availableGoals[index];
                final isSelected = state.selectedGoals.contains(goal['id']);

                return _GoalCard(
                  emoji: goal['emoji']!,
                  label: goal['label']!,
                  isSelected: isSelected,
                  onTap: () => controller.toggleGoal(goal['id']!),
                  index: index,
                );
              },
            ),
          ),

          // Compteur de sélection
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${state.selectedGoals.length} objectif${state.selectedGoals.length > 1 ? 's' : ''} sélectionné${state.selectedGoals.length > 1 ? 's' : ''}',
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Bouton continuer
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: state.selectedGoals.isEmpty
                  ? null
                  : () => controller.saveGoals(),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                'Continuer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Message d'erreur
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                state.error!,
                style: TextStyle(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatefulWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const _GoalCard({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  State<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<_GoalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animation d'entrée décalée
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (50 * widget.index)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: _handleTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withOpacity(0.2),
                        width: widget.isSelected ? 2 : 1,
                      ),
                      boxShadow: widget.isSelected
                          ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Emoji avec animation de bounce
                        AnimatedScale(
                          scale: widget.isSelected ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.elasticOut,
                          child: Text(
                            widget.emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          widget.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: widget.isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: widget.isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Indicateur de sélection
                        if (widget.isSelected)
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 400),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}