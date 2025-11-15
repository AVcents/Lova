// lib/features/chat_lova/presentation/widgets/typing_indicator.dart

import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';
import 'package:lova/core/theme/loova_colors.dart';
import 'package:lova/shared/widgets/animations/typing_dots_indicator.dart';

/// Indicateur "LOOVA est en train d'écrire..."
///
/// Affiche une bulle avec avatar LOOVA + 3 dots animés
/// pour indiquer que LOOVA génère une réponse.
///
/// Usage :
/// ```dart
/// if (isLovaTyping) TypingIndicator()
/// ```
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.80,
        ),
        margin: EdgeInsets.only(
          bottom: context.spacing.md,
          right: context.spacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header : Avatar + Label "LOOVA"
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar LOOVA avec gradient
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LoovaColors.gradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: LoovaColors.shadowColor(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '💜',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                SizedBox(width: context.spacing.xs),

                // Label "LOAVA"
                Text(
                  'LOVA',
                  style: textTheme.labelMedium?.copyWith(
                    color: LoovaColors.gradientEnd,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacing.xs),

            // Bulle avec dots animés
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.lg,
                vertical: context.spacing.md,
              ),
              decoration: BoxDecoration(
                gradient: LoovaColors.gradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: LoovaColors.shadowColor(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const TypingDotsIndicator(
                color: Colors.white,
                size: 8,
                spacing: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}