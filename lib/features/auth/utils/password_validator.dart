import 'package:flutter/material.dart';

/// Niveau de force du mot de passe
enum PasswordStrength { weak, medium, strong, veryStrong }

/// Politique de mot de passe configurable
class PasswordPolicy {
  final int minLength;
  final bool requireUpper;
  final bool requireLower;
  final bool requireDigit;
  final bool requireSpecial;
  final int minCategories;

  const PasswordPolicy({
    this.minLength = 8,
    this.requireUpper = false,
    this.requireLower = false,
    this.requireDigit = false,
    this.requireSpecial = false,
    this.minCategories = 3,
  });

  static const PasswordPolicy strict = PasswordPolicy(
    minLength: 12,
    requireUpper: true,
    requireLower: true,
    requireDigit: true,
    requireSpecial: true,
    minCategories: 4,
  );
}

class PasswordValidator {
  static const _specialPattern = r'[!@#\$%\^&\*()\[\]{}:;,.<>?/\\|\-+=_~`]';

  static PasswordValidationResult validate(
    String password, {
    PasswordPolicy policy = const PasswordPolicy(),
  }) {
    final hasMinLength = password.length >= policy.minLength;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(_specialPattern).hasMatch(password);

    int categoriesMet = 0;
    if (hasUpperCase) categoriesMet++;
    if (hasLowerCase) categoriesMet++;
    if (hasDigit) categoriesMet++;
    if (hasSpecialChar) categoriesMet++;

    final explicitOk =
        (!policy.requireUpper || hasUpperCase) &&
        (!policy.requireLower || hasLowerCase) &&
        (!policy.requireDigit || hasDigit) &&
        (!policy.requireSpecial || hasSpecialChar);

    final meetsCategories = categoriesMet >= policy.minCategories;

    final lengthScore = (password.length / (policy.minLength + 8))
        .clamp(0, 1)
        .toDouble();
    final varietyScore = (categoriesMet / 4).clamp(0, 1).toDouble();
    final score01 = (0.5 * lengthScore + 0.5 * varietyScore)
        .clamp(0, 1)
        .toDouble();

    final strength = _strengthFromScore(score01);

    final isValid = hasMinLength && meetsCategories && explicitOk;

    return PasswordValidationResult(
      isValid: isValid,
      strength: strength,
      hasMinLength: hasMinLength,
      hasUpperCase: hasUpperCase,
      hasLowerCase: hasLowerCase,
      hasDigit: hasDigit,
      hasSpecialChar: hasSpecialChar,
      categoriesMet: categoriesMet,
      score01: score01,
      policy: policy,
    );
  }

  static PasswordStrength _strengthFromScore(double s) {
    if (s < 0.35) return PasswordStrength.weak;
    if (s < 0.6) return PasswordStrength.medium;
    if (s < 0.85) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  static Color getStrengthColor(
    PasswordStrength strength,
    BuildContext context,
  ) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.lightGreen;
      case PasswordStrength.veryStrong:
        return Colors.green;
    }
  }

  static String getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Faible';
      case PasswordStrength.medium:
        return 'Moyen';
      case PasswordStrength.strong:
        return 'Fort';
      case PasswordStrength.veryStrong:
        return 'Très fort';
    }
  }
}

class PasswordValidationResult {
  final bool isValid;
  final PasswordStrength strength;
  final bool hasMinLength;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasDigit;
  final bool hasSpecialChar;
  final int categoriesMet;
  final double score01;
  final PasswordPolicy policy;

  const PasswordValidationResult({
    required this.isValid,
    required this.strength,
    required this.hasMinLength,
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasDigit,
    required this.hasSpecialChar,
    required this.categoriesMet,
    required this.score01,
    required this.policy,
  });
}

class PasswordStrengthMeter extends StatelessWidget {
  final String password;
  final PasswordPolicy policy;
  final EdgeInsetsGeometry padding;
  final bool showChecklist;

  const PasswordStrengthMeter({
    super.key,
    required this.password,
    this.policy = const PasswordPolicy(),
    this.padding = const EdgeInsets.only(top: 8),
    this.showChecklist = true,
  });

  @override
  Widget build(BuildContext context) {
    final res = PasswordValidator.validate(password, policy: policy);
    final color = PasswordValidator.getStrengthColor(res.strength, context);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: res.score01.clamp(0, 1),
              minHeight: 8,
              color: color,
              backgroundColor: color.withOpacity(0.15),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                PasswordValidator.getStrengthText(res.strength),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                res.isValid ? 'Valide' : 'Non valide',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: res.isValid ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (showChecklist) ...[
            const SizedBox(height: 6),
            _Checklist(res: res),
          ],
        ],
      ),
    );
  }
}

class _Checklist extends StatelessWidget {
  final PasswordValidationResult res;

  const _Checklist({required this.res});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget item(bool ok, String text) => Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: ok ? Colors.green : theme.colorScheme.error,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        item(res.hasMinLength, 'Au moins ${res.policy.minLength} caractères'),
        item(res.hasUpperCase, 'Une majuscule'),
        item(res.hasLowerCase, 'Une minuscule'),
        item(res.hasDigit, 'Un chiffre'),
        item(res.hasSpecialChar, 'Un caractère spécial'),
      ],
    );
  }
}
