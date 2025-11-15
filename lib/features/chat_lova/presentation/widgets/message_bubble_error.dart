// lib/features/chat_lova/presentation/widgets/message_bubble_error.dart

import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';

/// Bulle de message d'erreur LOOVA
///
/// Affiche un message d'erreur quand LOOVA ne peut pas répondre avec :
/// - Background errorContainer
/// - Icône warning
/// - Message d'erreur
/// - Bouton "Réessayer"
/// - Alignement à gauche (comme LOOVA)
///
/// Usage :
/// ```dart
/// MessageBubbleError(
///   onRetry: () => retryLastMessage(),
/// )
/// ```
class MessageBubbleError extends StatelessWidget {
  /// Callback appelé quand l'utilisateur tape sur "Réessayer"
  final VoidCallback onRetry;

  /// Message d'erreur personnalisé (optionnel)
  final String? errorMessage;

  const MessageBubbleError({
    super.key,
    required this.onRetry,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
            // Header : Label "LOVA" (cohérence avec MessageBubbleLova)
            Padding(
              padding: EdgeInsets.only(left: context.spacing.xs),
              child: Text(
                'LOVA',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            SizedBox(height: context.spacing.xs),

            // Bulle d'erreur
            Container(
              padding: EdgeInsets.all(context.spacing.md),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: colorScheme.error.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône + Message d'erreur
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: colorScheme.error,
                        size: 20,
                      ),
                      SizedBox(width: context.spacing.xs),
                      Expanded(
                        child: Text(
                          errorMessage ?? 'Oups, je n\'ai pas pu répondre...',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: context.spacing.sm),

                  // Bouton "Réessayer"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                      ),
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
}