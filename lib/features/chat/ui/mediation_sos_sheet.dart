// lib/features/chat_couple/ui/mediation_sos_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MediationSosSheet extends StatefulWidget {
  final Function(String)? onInsertToChat;

  const MediationSosSheet({
    super.key,
    this.onInsertToChat,
  });

  @override
  State<MediationSosSheet> createState() => _MediationSosSheetState();
}

class _MediationSosSheetState extends State<MediationSosSheet> {
  int _currentStep = 0;
  final List<String> _responses = ['', '', ''];

  final List<_MediationStep> _steps = [
    _MediationStep(
      title: 'Nommer le ressenti',
      description: 'Prenez un moment pour identifier ce que vous ressentez maintenant',
      icon: Icons.favorite_outline,
      prompts: [
        'Je ressens de la frustration',
        'Je me sens incompris(e)',
        'J\'ai besoin d\'espace',
        'Je suis blessé(e)',
      ],
    ),
    _MediationStep(
      title: 'Écouter et valider',
      description: 'Reconnaissez les émotions de votre partenaire sans jugement',
      icon: Icons.hearing,
      prompts: [
        'J\'entends que tu es...',
        'Je comprends que c\'est difficile',
        'Tes sentiments sont valides',
        'Je vois que tu as besoin de...',
      ],
    ),
    _MediationStep(
      title: 'Planifier un moment',
      description: 'Convenez d\'un moment calme pour discuter en profondeur',
      icon: Icons.schedule,
      prompts: [
        'Parlons-en ce soir après dîner',
        'Prenons 30 min demain matin',
        'Faisons une pause et reparlons dans 1h',
        'Retrouvons-nous dans un endroit calme',
      ],
    ),
  ];

  void _selectPrompt(String prompt) {
    setState(() {
      _responses[_currentStep] = prompt;
    });
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeMediation();
    }
  }

  void _completeMediation() {
    final plan = _responses.where((r) => r.isNotEmpty).join('\n');

    if (widget.onInsertToChat != null && plan.isNotEmpty) {
      widget.onInsertToChat!(plan);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currentStep = _steps[_currentStep];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Médiation SOS',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index <= _currentStep
                            ? colorScheme.primary
                            : colorScheme.outline.withOpacity(0.3),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      currentStep.icon,
                      size: 32,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Étape ${_currentStep + 1}: ${currentStep.title}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentStep.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ...currentStep.prompts.map((prompt) {
                    final isSelected = _responses[_currentStep] == prompt;
                    return Semantics(
                      button: true,
                      selected: isSelected,
                      label: prompt,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: isSelected
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _selectPrompt(prompt);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.outline.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      prompt,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: colorScheme.primary,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withOpacity(0.12),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _currentStep--;
                          });
                        },
                        child: Text('Retour'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _responses[_currentStep].isNotEmpty
                          ? () {
                        HapticFeedback.mediumImpact();
                        _nextStep();
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentStep < _steps.length - 1
                            ? 'Suivant'
                            : 'Terminer',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediationStep {
  final String title;
  final String description;
  final IconData icon;
  final List<String> prompts;

  _MediationStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.prompts,
  });
}