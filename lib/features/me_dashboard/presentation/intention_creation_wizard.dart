// lib/features/me_dashboard/presentation/intention_creation_wizard.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/me_dashboard/data/models/life_intention_model.dart';
import 'package:lova/features/me_dashboard/providers/intentions_providers.dart';
import 'package:lova/features/me_dashboard/presentation/widgets/intention_category_badge.dart';

class IntentionCreationWizard extends ConsumerStatefulWidget {
  const IntentionCreationWizard({super.key});

  @override
  ConsumerState<IntentionCreationWizard> createState() => _IntentionCreationWizardState();
}

class _IntentionCreationWizardState extends ConsumerState<IntentionCreationWizard> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Type et durée
  IntentionType? _selectedType;

  // Step 2: Catégorie et contenu
  IntentionCategory? _selectedCategory;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Step 3: Tracking
  bool _wantsTracking = false;
  int? _targetValue;
  String? _selectedUnit;
  String? _selectedFrequency;
  final List<String> _selectedRituals = [];
  bool _autoTrack = false;

  final List<String> _units = ['fois', 'minutes', 'heures', 'jours', 'sessions'];
  final List<String> _frequencies = ['par jour', 'par semaine', 'par mois'];

  final Map<String, String> _ritualLabels = {
    'respiration': 'Respiration',
    'meditation': 'Méditation',
    'gratitude': 'Gratitude',
    'lecture': 'Lecture',
    'marche': 'Marche',
    'etirement': 'Étirement',
  };

  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> _createIntention() async {
    if (_selectedType == null || _selectedCategory == null || _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    // ✅ DEBUG : Vérifier les valeurs avant création
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🎯 Valeurs du wizard:');
    print('  _wantsTracking: $_wantsTracking');
    print('  _targetValue: $_targetValue');
    print('  _selectedUnit: $_selectedUnit');
    print('  _selectedFrequency: $_selectedFrequency');
    print('  _autoTrack: $_autoTrack');
    print('  _selectedRituals: $_selectedRituals');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (_wantsTracking && (_targetValue == null || _selectedUnit == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez définir un objectif chiffré et une unité'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Calculer les dates
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    DateTime? endDate;

    switch (_selectedType!) {
      case IntentionType.monthly:
        final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
        endDate = DateTime(lastDayOfMonth.year, lastDayOfMonth.month, lastDayOfMonth.day);
        break;
      case IntentionType.seasonal:
        endDate = DateTime(now.year, now.month + 3, now.day);
        break;
      case IntentionType.ongoing:
        endDate = null;
        break;
    }

    final intention = LifeIntention(
      id: '', // Sera généré par Supabase
      userId: '', // Sera rempli par le repository
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      category: _selectedCategory!,
      iconName: null,
      type: _selectedType!,
      startDate: startDate,
      endDate: endDate,
      status: IntentionStatus.active,
      isTrackable: _wantsTracking,
      targetValue: _wantsTracking ? _targetValue : null,
      currentValue: 0,
      unit: _wantsTracking ? _selectedUnit : null,
      frequency: _wantsTracking ? _selectedFrequency : null,
      linkedRitualTypes: _autoTrack ? _selectedRituals : [],
      autoTrack: _autoTrack,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final notifier = ref.read(intentionsNotifierProvider.notifier);
    final success = await notifier.createIntention(intention);

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
              Expanded(child: Text('✨ Intention créée avec succès !')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      context.pop();
    } else {
      final error = ref.read(intentionsNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error?.toString() ?? 'Erreur lors de la création'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Nouvelle intention'),
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: colorScheme.surfaceContainerHighest,
            minHeight: 4,
          ),

          // Steps indicator
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepIndicator(0, 'Type'),
                _buildStepLine(),
                _buildStepIndicator(1, 'Contenu'),
                _buildStepLine(),
                _buildStepIndicator(2, 'Suivi'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1Type(),
                _buildStep2Content(),
                _buildStep3Tracking(),
              ],
            ),
          ),

          // Navigation buttons
          _buildNavigationButtons(colorScheme),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isActive = step == _currentStep;
    final isDone = step < _currentStep;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDone || isActive
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check, color: colorScheme.onPrimary, size: 20)
                : Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive
                ? colorScheme.onSurface
                : colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 28),
      color: colorScheme.surfaceContainerHighest,
    );
  }

  // ============================================
  // STEP 1: Type et durée
  // ============================================

  Widget _buildStep1Type() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quelle intention voulez-vous cultiver ?',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choisissez la durée qui vous convient',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 32),

          ...IntentionType.values.map((type) {
            final isSelected = _selectedType == type;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTypeCard(type, isSelected),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTypeCard(IntentionType type, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedType = type);
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<IntentionType>(
              value: type,
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() => _selectedType = value);
                HapticFeedback.lightImpact();
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // STEP 2: Catégorie et contenu
  // ============================================

  Widget _buildStep2Content() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donnez vie à votre intention',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          // Catégories
          Text(
            'Catégorie',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: IntentionCategory.values.map((category) {
              return IntentionCategoryBadge(
                category: category,
                isSelected: _selectedCategory == category,
                onTap: () {
                  setState(() => _selectedCategory = category);
                  HapticFeedback.lightImpact();
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Titre
          Text(
            'Titre de votre intention',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Ex: Méditer régulièrement',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
            ),
            maxLength: 100,
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            'Description (optionnel)',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'Pourquoi cette intention est importante pour vous...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
            ),
            maxLines: 4,
            maxLength: 500,
          ),
        ],
      ),
    );
  }

  // ============================================
  // STEP 3: Tracking
  // ============================================

  Widget _buildStep3Tracking() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voulez-vous suivre votre progrès ?',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          // Choix tracking ou non
          _buildTrackingChoice(
            'Oui, je veux mesurer',
            'Définir un objectif chiffré',
            true,
          ),
          const SizedBox(height: 12),
          _buildTrackingChoice(
            'Non, intention qualitative',
            'Pas de mesure quantitative',
            false,
          ),

          if (_wantsTracking) ...[
            const SizedBox(height: 32),

            // Objectif
            // Objectif
            Text(
              'Objectif',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '10',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _targetValue = int.tryParse(value);
                      });
                      print('🎯 Target value changé: $_targetValue'); // ✅ Debug
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                    ),
                    hint: const Text('Unité'),
                    items: _units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedUnit = value);
                      print('📊 Unit changée: $_selectedUnit'); // ✅ Debug
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Fréquence
            DropdownButtonFormField<String>(
              value: _selectedFrequency,
              decoration: InputDecoration(
                labelText: 'Fréquence',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              items: _frequencies.map((freq) {
                return DropdownMenuItem(
                  value: freq,
                  child: Text(freq),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedFrequency = value);
              },
            ),

            const SizedBox(height: 32),

            // Lier aux rituels
            Text(
              'Lier à des rituels ?',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._ritualLabels.entries.map((entry) {
              final isSelected = _selectedRituals.contains(entry.key);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedRituals.add(entry.key);
                    } else {
                      _selectedRituals.remove(entry.key);
                    }
                  });
                },
                title: Text(entry.value),
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),

            const SizedBox(height: 20),

            // Auto-track
            SwitchListTile(
              value: _autoTrack,
              onChanged: _selectedRituals.isEmpty
                  ? null
                  : (value) {
                setState(() => _autoTrack = value);
              },
              title: const Text('Tracker automatiquement'),
              subtitle: const Text(
                'Le progrès sera ajouté automatiquement quand vous faites ces rituels',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingChoice(String title, String subtitle, bool value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = _wantsTracking == value;

    return GestureDetector(
      onTap: () {
        setState(() => _wantsTracking = value);
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: value,
              groupValue: _wantsTracking,
              onChanged: (val) {
                setState(() => _wantsTracking = val!);
                HapticFeedback.lightImpact();
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // Navigation buttons
  // ============================================

  Widget _buildNavigationButtons(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Retour'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  if (_currentStep == 2) {
                    _createIntention();
                  } else if (_canProceed()) {
                    _nextStep();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(_currentStep == 2 ? 'Créer' : 'Suivant'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedType != null;
      case 1:
        return _selectedCategory != null && _titleController.text.trim().isNotEmpty;
      case 2:
        if (!_wantsTracking) return true;
        // ✅ CRITIQUE : Vérifier que target_value ET unit sont définis
        final hasTarget = _targetValue != null && _targetValue! > 0;
        final hasUnit = _selectedUnit != null;
        print('🔍 Can proceed step 3: target=$_targetValue, unit=$_selectedUnit, hasTarget=$hasTarget, hasUnit=$hasUnit');
        return hasTarget && hasUnit;
      default:
        return false;
    }
  }
}