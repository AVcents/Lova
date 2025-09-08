import 'package:flutter/material.dart';
import '../utils/password_validator.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordValidationResult validation;

  const PasswordStrengthIndicator({
    super.key,
    required this.validation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barre de progression animée
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [
                PasswordValidator.getStrengthColor(validation.strength, context),
                PasswordValidator.getStrengthColor(validation.strength, context).withOpacity(0.3),
              ],
              stops: [
                _getProgressValue(validation.strength),
                _getProgressValue(validation.strength),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Texte de force
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Force: ${PasswordValidator.getStrengthText(validation.strength)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: PasswordValidator.getStrengthColor(validation.strength, context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Critères de validation
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _buildCriteria(
              '8+ caractères',
              validation.hasMinLength,
              context,
            ),
            _buildCriteria(
              'Majuscule',
              validation.hasUpperCase,
              context,
            ),
            _buildCriteria(
              'Minuscule',
              validation.hasLowerCase,
              context,
            ),
            _buildCriteria(
              'Chiffre',
              validation.hasDigit,
              context,
            ),
            _buildCriteria(
              'Caractère spécial',
              validation.hasSpecialChar,
              context,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCriteria(String label, bool met, BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: met
            ? Colors.green.withOpacity(0.1)
            : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: met
              ? Colors.green
              : theme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: met ? Colors.green : theme.textTheme.bodySmall?.color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: met ? Colors.green : theme.textTheme.bodySmall?.color,
              fontWeight: met ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  double _getProgressValue(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }
}