import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';
import 'package:lova/core/theme/loova_colors.dart';

/// Widget affichant l'état vide du chat LOVA
///
/// Affiche:
/// - Avatar LOVA avec gradient signature (80×80)
/// - Message d'accueil "Salut ! Je suis LOVA 💜"
/// - Sous-titre "Pose-moi une question sur ta relation"
/// - 3 suggestions de questions sous forme de chips cliquables
///
/// Design:
/// - Avatar avec shadow subtile
/// - Chips avec primaryContainer background
/// - Espacement harmonisé avec design system
///
/// Usage:
/// ```dart
/// ChatEmptyState(
///   onSuggestionTap: (suggestion) => _sendMessage(suggestion),
/// )
/// ```
class ChatEmptyState extends StatelessWidget {
  /// Callback appelé quand une suggestion est tappée
  final void Function(String suggestion) onSuggestionTap;

  const ChatEmptyState({
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
            // Avatar LOVA (image réelle)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: LoovaColors.gradientEnd.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/loova_avatar.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: context.spacing.xl),

            // Titre d'accueil
            Text(
              'Salut ! Je suis LOVA',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.spacing.xs),

            // Sous-titre
            Text(
              'Pose-moi une question sur ta relation',
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
                  'Comment améliorer notre communication ?',
                ),
                _buildSuggestionChip(
                  context,
                  'Des idées de date night ?',
                ),
                _buildSuggestionChip(
                  context,
                  'Gérer un conflit',
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