// lib/features/chat/widgets/couple/chat_empty_state_couple.dart

import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';

/// Empty state pour le Chat Couple
///
/// Affiche:
/// - 2 dots colorés (rose + violet) avec taille 40x40
/// - Message d'accueil "Votre espace privé 💕"
/// - Sous-titre "Échangez, partagez, grandissez ensemble"
/// - 3 suggestions de messages starter
///
/// Design:
/// - Dots avec shadow et espacement harmonieux
/// - Chips avec primaryContainer background
/// - Suggestions adaptées au couple
///
/// Usage:
/// ```dart
/// ChatEmptyStateCouple(
///   onSuggestionTap: (suggestion) => _sendMessage(suggestion),
/// )
/// ```
class ChatEmptyStateCouple extends StatelessWidget {
  /// Callback appelé quand une suggestion est tappée
  final void Function(String suggestion) onSuggestionTap;

  const ChatEmptyStateCouple({
    super.key,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dots couple (rose + violet)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dot rose
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B9D),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B9D).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.spacing.sm),
                // Dot violet
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C27B0).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacing.xl),

            // Titre d'accueil
            Text(
              'Votre espace privé 💕',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.spacing.xs),

            // Sous-titre
            Text(
              'Échangez, partagez, grandissez ensemble',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.spacing.xxl),

            // Suggestions chips
            Wrap(
              spacing: context.spacing.sm,
              runSpacing: context.spacing.sm,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip(
                  context,
                  'Salut mon amour ! 💕',
                ),
                _buildSuggestionChip(
                  context,
                  'J\'ai pensé à toi aujourd\'hui',
                ),
                _buildSuggestionChip(
                  context,
                  'On fait quoi ce weekend ? 🌟',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit un chip de suggestion cliquable
  Widget _buildSuggestionChip(BuildContext context, String suggestion) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ActionChip(
      label: Text(suggestion),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onPrimaryContainer,
      ),
      backgroundColor: colorScheme.primaryContainer,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.md,
        vertical: context.spacing.sm,
      ),
      onPressed: () => onSuggestionTap(suggestion),
    );
  }
}