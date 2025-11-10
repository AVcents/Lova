// lib/features/relation/dashboard/screens/checkin/widgets/text_input_with_toggle.dart
import 'package:flutter/material.dart';

class TextInputWithToggle extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String toggleLabel;
  final bool isShared;
  final ValueChanged<bool> onSharedChanged;
  final int maxLength;

  const TextInputWithToggle({
    super.key,
    required this.controller,
    required this.hintText,
    required this.toggleLabel,
    required this.isShared,
    required this.onSharedChanged,
    this.maxLength = 500,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            maxLines: 5,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: cs.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: cs.outline.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: cs.primary, width: 1.5),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: isShared,
            onChanged: onSharedChanged,
            activeColor: cs.primary,
            title: Text(
              toggleLabel,
              style: textTheme.bodyMedium,
            ),
            subtitle: Text(
              isShared
                  ? '👀 Visible par votre partenaire'
                  : '🔒 Privé, pour vous uniquement',
              style: textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}