// lib/features/chat_couple/ui/intervention_banner.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InterventionBanner extends StatelessWidget {
  final String reason;
  final VoidCallback onDismiss;
  final VoidCallback onRephrase;
  final VoidCallback onPause;
  final VoidCallback onSos;
  final bool isTension;

  const InterventionBanner({
    super.key,
    required this.reason,
    required this.onDismiss,
    required this.onRephrase,
    required this.onPause,
    required this.onSos,
    this.isTension = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isTension ? Icons.warning_amber_rounded : Icons.access_time,
                color: isTension ? colorScheme.error : colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isTension
                      ? 'Moment de tension détecté'
                      : 'Ça fait un moment sans échange',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Semantics(
                label: 'Fermer',
                button: true,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onDismiss();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isTension
                ? 'Prenons un moment pour adoucir la conversation'
                : 'Un petit message peut faire toute la différence',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ActionButton(
                  label: 'Reformuler',
                  icon: Icons.auto_awesome,
                  onTap: onRephrase,
                  isPrimary: true,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  label: 'Pause 5min',
                  icon: Icons.pause,
                  onTap: onPause,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  label: 'SOS',
                  icon: Icons.support_rounded,
                  onTap: onSos,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: isPrimary
            ? colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isPrimary
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: isPrimary
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}