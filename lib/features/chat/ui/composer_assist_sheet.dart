// lib/features/chat_lova/ui/composer_assist_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ComposerAssistSheet extends StatefulWidget {
  final int initialTone;
  final int initialLength;
  final int initialEmpathy;

  /// Contexte optionnel (clé/valeur) – non utilisé ici mais conservé pour intégration.
  final List<Map<String, String>>? context;

  const ComposerAssistSheet({
    super.key,
    this.initialTone = 1,
    this.initialLength = 1,
    this.initialEmpathy = 1,
    this.context,
  });

  @override
  State<ComposerAssistSheet> createState() => _ComposerAssistSheetState();
}

class _ComposerAssistSheetState extends State<ComposerAssistSheet> {
  late int _tone;
  late int _length;
  late int _empathy;
  final TextEditingController _inputController = TextEditingController();
  String _generatedText = '';
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _tone = widget.initialTone;
    _length = widget.initialLength;
    _empathy = widget.initialEmpathy;

    // Activer/désactiver dynamiquement le bouton "Utiliser ce message".
    _inputController.addListener(() => setState(() {}));

    _generateResponse();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _generateResponse() async {
    setState(() {
      _isGenerating = true;
    });

    // Simule une petite latence
    await Future.delayed(const Duration(seconds: 1));

    String response = '';

    // Tonalité
    if (_tone == 0) {
      response = 'Je comprends ta position. ';
    } else if (_tone == 1) {
      response = 'Je vois ce que tu veux dire. ';
    } else {
      response = 'J\'apprécie que tu partages ça avec moi. ';
    }

    // Empathie
    if (_empathy == 2) {
      response +=
          'Je sais que c\'est difficile pour toi et j\'aimerais qu\'on trouve une solution ensemble. ';
    } else if (_empathy == 1) {
      response += 'On peut en discuter calmement. ';
    } else {
      response += 'Parlons-en. ';
    }

    // Longueur
    if (_length == 0) {
      response = response.trim();
    } else if (_length == 1) {
      response += 'Qu\'est-ce qui te ferait sentir mieux?';
    } else {
      response +=
          'Dis-moi ce dont tu as besoin pour qu\'on avance. J\'ai vraiment envie qu\'on se comprenne mieux.';
    }

    setState(() {
      _generatedText = response;
      _inputController.text = response;
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Assistant de reformulation',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ajustez les paramètres pour créer votre message',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSlider(
                    label: 'Ton',
                    value: _tone,
                    options: const ['Neutre', 'Chaleureux', 'Affectueux'],
                    onChanged: (value) {
                      setState(() => _tone = value);
                      _generateResponse();
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSlider(
                    label: 'Longueur',
                    value: _length,
                    options: const ['Court', 'Moyen', 'Détaillé'],
                    onChanged: (value) {
                      setState(() => _length = value);
                      _generateResponse();
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSlider(
                    label: 'Empathie',
                    value: _empathy,
                    options: const ['Basique', 'Modérée', 'Forte'],
                    onChanged: (value) {
                      setState(() => _empathy = value);
                      _generateResponse();
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Message généré',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_isGenerating)
                    Container(
                      height: 120,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    )
                  else
                    TextField(
                      controller: _inputController,
                      maxLines: 5,
                      minLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(color: colorScheme.outline.withOpacity(0.12)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _inputController.text.trim().isNotEmpty
                          ? () {
                              HapticFeedback.mediumImpact();
                              Navigator.of(
                                context,
                              ).pop(_inputController.text.trim());
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
                      child: const Text(
                        'Utiliser ce message',
                        style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildSlider({
    required String label,
    required int value,
    required List<String> options,
    required Function(int) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(options.length, (index) {
            final isSelected = value == index;
            return Expanded(
              child: Semantics(
                button: true,
                selected: isSelected,
                label: options[index],
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onChanged(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.only(
                      right: index < options.length - 1 ? 8 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        options[index],
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
