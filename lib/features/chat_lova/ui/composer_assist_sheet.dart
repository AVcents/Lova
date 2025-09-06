// lib/features/chat_lova/ui/composer_assist_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat_lova/composer/composer_assist_provider.dart';
import '../providers/lova_metrics_provider.dart';

class ComposerAssistSheet extends ConsumerStatefulWidget {
  final List<String> history;
  final String? initialContext;

  const ComposerAssistSheet({
    super.key,
    required this.history,
    this.initialContext,
  });

  @override
  ConsumerState<ComposerAssistSheet> createState() => _ComposerAssistSheetState();
}

class _ComposerAssistSheetState extends ConsumerState<ComposerAssistSheet>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _contextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();

    if (widget.initialContext != null) {
      _contextController.text = widget.initialContext!;
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(composerAssistProvider);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              _buildHeader(context, colorScheme),

              const SizedBox(height: 20),

              // Champ contexte
              _buildContextField(context, colorScheme),

              const SizedBox(height: 20),

              // Sliders
              _buildSliders(context, state),

              const SizedBox(height: 24),

              // Bouton Générer
              _buildGenerateButton(context, state),

              const SizedBox(height: 20),

              // Variations
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildVariations(context, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistant de composition',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'LOVA t\'aide à écrire à ton partenaire',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextField(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contexte du message (optionnel)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contextController,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Ex : je veux m'excuser pour hier et proposer un moment",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              filled: true,
              fillColor: colorScheme.surfaceVariant,
              contentPadding: const EdgeInsets.all(12),
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
                  width: 1.4,
                ),
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliders(BuildContext context, ComposerAssistState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSlider(
            context,
            'Ton',
            state.params.tone,
            ['Chaleureux', 'Neutre', 'Assertif'],
                (value) => ref.read(composerAssistProvider.notifier).updateParams(tone: value),
          ),
          const SizedBox(height: 20),
          _buildSlider(
            context,
            'Longueur',
            state.params.length,
            ['Court', 'Moyen', 'Long'],
                (value) => ref.read(composerAssistProvider.notifier).updateParams(length: value),
          ),
          const SizedBox(height: 20),
          _buildSlider(
            context,
            'Empathie',
            state.params.empathy,
            ['Faible', 'Moyenne', 'Forte'],
                (value) => ref.read(composerAssistProvider.notifier).updateParams(empathy: value),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
      BuildContext context,
      String title,
      int value,
      List<String> labels,
      Function(int) onChanged,
      ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: labels.asMap().entries.map((entry) {
                  final index = entry.key;
                  final label = entry.value;
                  return Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: index == value
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: index == value ? FontWeight.w600 : FontWeight.w400,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  value: value.toDouble(),
                  min: 0,
                  max: 2,
                  divisions: 2,
                  onChanged: (newValue) {
                    HapticFeedback.lightImpact();
                    onChanged(newValue.round());
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton(BuildContext context, ComposerAssistState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: state.isLoading ? null : _onGenerate,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: state.isLoading
              ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
            ),
          )
              : const Text(
            'Générer',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildVariations(BuildContext context, ComposerAssistState state) {
    if (state.variations.isEmpty && !state.isLoading) {
      return const SizedBox.shrink();
    }

    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('Génération en cours...')),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggestions',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...state.variations.asMap().entries.map(
                (entry) => _buildVariationCard(context, entry.value, entry.key, state.params),
          ),
        ],
      ),
    );
  }

  Widget _buildVariationCard(BuildContext context, String variation, int index, ComposerAssistParams params) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasContext = _contextController.text.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        label: 'Variation ${index + 1}, appuyer pour insérer',
        button: true,
        child: InkWell(
          onTap: () => _onVariationTap(variation),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  variation,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.4,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        params.profileChip,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    if (hasContext) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Contexte utilisé',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.secondary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      'Appuyer pour insérer',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onGenerate() async {
    final contextText = _contextController.text.trim();
    await ref.read(composerAssistProvider.notifier).generateVariations(
      widget.history,
      contextText,
    );
    ref.read(lovaMetricsProvider.notifier).logGenerated(3);

    final state = ref.read(composerAssistProvider);
    if (state.variations.isEmpty && !state.isLoading) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible de générer, réessaye'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onVariationTap(String variation) {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop(variation);
  }
}