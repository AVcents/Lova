// lib/features/profile/presentation/intention_reflection_page.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/profile/data/models/intention_reflection_model.dart';
import 'package:lova/features/profile/providers/intentions_providers.dart';

class IntentionReflectionPage extends ConsumerStatefulWidget {
  final int? year;
  final int? month;

  const IntentionReflectionPage({
    super.key,
    this.year,
    this.month,
  });

  @override
  ConsumerState<IntentionReflectionPage> createState() => _IntentionReflectionPageState();
}

class _IntentionReflectionPageState extends ConsumerState<IntentionReflectionPage> {
  late int _year;
  late int _month;

  final _whatWorkedController = TextEditingController();
  final _whatStruggledController = TextEditingController();
  final _learningsController = TextEditingController();
  final _nextFocusController = TextEditingController();
  int? _overallSatisfaction;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = widget.year ?? (now.month == 1 ? now.year - 1 : now.year);
    _month = widget.month ?? (now.month == 1 ? 12 : now.month - 1);

    _loadExistingReflection();
  }

  @override
  void dispose() {
    _whatWorkedController.dispose();
    _whatStruggledController.dispose();
    _learningsController.dispose();
    _nextFocusController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingReflection() async {
    final repository = ref.read(intentionsRepositoryProvider);
    final reflection = await repository.getReflection(year: _year, month: _month);

    if (reflection != null && mounted) {
      setState(() {
        _whatWorkedController.text = reflection.whatWorked ?? '';
        _whatStruggledController.text = reflection.whatStruggled ?? '';
        _learningsController.text = reflection.learnings ?? '';
        _nextFocusController.text = reflection.nextFocus ?? '';
        _overallSatisfaction = reflection.overallSatisfaction;
      });
    }
  }

  Future<void> _saveReflection() async {
    if (_overallSatisfaction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez noter votre satisfaction globale')),
      );
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    // ✅ CORRECTION : Accéder directement à l'userId via Supabase
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur non connecté')),
        );
      }
      return;
    }

    final reflection = IntentionReflection(
      id: '', // Sera généré ou récupéré via upsert
      userId: userId,
      year: _year,
      month: _month,
      whatWorked: _whatWorkedController.text.trim().isEmpty
          ? null
          : _whatWorkedController.text.trim(),
      whatStruggled: _whatStruggledController.text.trim().isEmpty
          ? null
          : _whatStruggledController.text.trim(),
      learnings: _learningsController.text.trim().isEmpty
          ? null
          : _learningsController.text.trim(),
      nextFocus: _nextFocusController.text.trim().isEmpty
          ? null
          : _nextFocusController.text.trim(),
      overallSatisfaction: _overallSatisfaction,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final notifier = ref.read(intentionsNotifierProvider.notifier);
    final success = await notifier.saveReflection(reflection);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('✨ Réflexion enregistrée !')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'enregistrement'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final monthName = _getMonthName(_month);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('Réflexion · $monthName $_year'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
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
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_stories,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prenez un moment',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Réfléchissez sur vos intentions du mois',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Questions guidées
            _buildQuestionSection(
              context,
              'Ce qui a bien fonctionné',
              'Qu\'est-ce qui vous a aidé ce mois-ci ?',
              _whatWorkedController,
              Icons.thumb_up_outlined,
            ),

            const SizedBox(height: 24),

            _buildQuestionSection(
              context,
              'Difficultés rencontrées',
              'Quels ont été vos défis ?',
              _whatStruggledController,
              Icons.psychology_outlined,
            ),

            const SizedBox(height: 24),

            _buildQuestionSection(
              context,
              'Apprentissages',
              'Qu\'avez-vous appris sur vous-même ?',
              _learningsController,
              Icons.lightbulb_outlined,
            ),

            const SizedBox(height: 24),

            _buildQuestionSection(
              context,
              'Focus pour le prochain mois',
              'Sur quoi voulez-vous vous concentrer ?',
              _nextFocusController,
              Icons.rocket_launch_outlined,
            ),

            const SizedBox(height: 32),

            // Satisfaction globale
            _buildSatisfactionSection(context),

            const SizedBox(height: 100), // Espace pour le bouton
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FloatingActionButton.extended(
          onPressed: _isLoading ? null : _saveReflection,
          backgroundColor: colorScheme.primary,
          icon: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Icon(Icons.save),
          label: const Text('Enregistrer ma réflexion'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildQuestionSection(
      BuildContext context,
      String title,
      String hint,
      TextEditingController controller,
      IconData icon,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSatisfactionSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Satisfaction globale',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Comment évaluez-vous ce mois ?',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),

          // Emojis de satisfaction
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final rating = index + 1;
              final isSelected = _overallSatisfaction == rating;
              final emoji = _getSatisfactionEmoji(rating);

              return GestureDetector(
                onTap: () {
                  setState(() => _overallSatisfaction = rating);
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    emoji,
                    style: TextStyle(
                      fontSize: isSelected ? 40 : 32,
                    ),
                  ),
                ),
              );
            }),
          ),

          if (_overallSatisfaction != null) ...[
            const SizedBox(height: 12),
            Center(
              child: Text(
                _getSatisfactionLabel(_overallSatisfaction!),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getSatisfactionEmoji(int rating) {
    switch (rating) {
      case 1:
        return '😔';
      case 2:
        return '😐';
      case 3:
        return '🙂';
      case 4:
        return '😊';
      case 5:
        return '🤩';
      default:
        return '🙂';
    }
  }

  String _getSatisfactionLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Mois difficile';
      case 2:
        return 'Mois mitigé';
      case 3:
        return 'Mois correct';
      case 4:
        return 'Bon mois';
      case 5:
        return 'Excellent mois !';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return months[month - 1];
  }
}