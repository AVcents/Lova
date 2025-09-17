// lib/features/onboarding/presentation/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  static const List<Map<String, String>> availableInterests = [
    {'id': 'travel', 'label': 'Voyages', 'emoji': '✈️'},
    {'id': 'food', 'label': 'Gastronomie', 'emoji': '🍜'},
    {'id': 'sports', 'label': 'Sport', 'emoji': '⚽'},
    {'id': 'music', 'label': 'Musique', 'emoji': '🎵'},
    {'id': 'movies', 'label': 'Cinéma', 'emoji': '🎬'},
    {'id': 'reading', 'label': 'Lecture', 'emoji': '📚'},
    {'id': 'gaming', 'label': 'Jeux vidéo', 'emoji': '🎮'},
    {'id': 'nature', 'label': 'Nature', 'emoji': '🌿'},
    {'id': 'art', 'label': 'Art', 'emoji': '🎨'},
    {'id': 'tech', 'label': 'Tech', 'emoji': '💻'},
    {'id': 'wellness', 'label': 'Bien-être', 'emoji': '🧘'},
    {'id': 'dancing', 'label': 'Danse', 'emoji': '💃'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      await ref.read(onboardingControllerProvider.notifier).saveProfile();
      final state = ref.read(onboardingControllerProvider);
      if (state.status == 'solo') {
        if (context.mounted) {
          context.go('/dashboard');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final theme = Theme.of(context);
      final state = ref.watch(onboardingControllerProvider);
      final controller = ref.read(onboardingControllerProvider.notifier);
      if (_nameController.text.isEmpty && (state.firstName?.isNotEmpty ?? false)) {
        _nameController.text = state.firstName!;
      }

      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Titre
              Text(
                'Créez votre profil',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Champ prénom
              TextFormField(
                controller: _nameController,
                onChanged: controller.updateFirstName,
                decoration: InputDecoration(
                  labelText: 'Votre prénom',
                  hintText: 'Comment souhaitez-vous être appelé ?',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le prénom est obligatoire';
                  }
                  if (value.trim().length < 2) {
                    return 'Le prénom doit contenir au moins 2 caractères';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Section intérêts
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vos centres d\'intérêt (optionnel)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aidez-nous à personnaliser votre expérience',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Chips d'intérêts
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableInterests.map((interest) {
                      final isSelected = state.selectedInterests.contains(interest['id']);
                      return _InterestChip(
                        emoji: interest['emoji']!,
                        label: interest['label']!,
                        isSelected: isSelected,
                        onTap: () => controller.toggleInterest(interest['id']!),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Compteur d'intérêts
              if (state.selectedInterests.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${state.selectedInterests.length} intérêt${state.selectedInterests.length > 1 ? 's' : ''} sélectionné${state.selectedInterests.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: theme.colorScheme.onSecondaryContainer,
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
                  onPressed: state.isLoading ? null : () => _handleSubmit(context, ref),
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
                      : Text(
                    state.status == 'solo' ? 'Terminer' : 'Continuer',
                    style: const TextStyle(
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
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _InterestChip extends StatefulWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestChip({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_InterestChip> createState() => _InterestChipState();
}

class _InterestChipState extends State<_InterestChip>
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

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.3),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: widget.isSelected
                    ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Emoji animé
                  AnimatedScale(
                    scale: widget.isSelected ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                    child: Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    widget.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: widget.isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: widget.isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),

                  // Check mark animé
                  if (widget.isSelected) ...[
                    const SizedBox(width: 8),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 400),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Icon(
                            Icons.check_circle,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}