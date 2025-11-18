// lib/features/chat/widgets/couple/chat_couple_app_bar.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/core/theme/theme_extensions.dart';

/// AppBar custom pour le Chat Couple
///
/// Affiche:
/// - Titre "Nous" avec 2 dots colorés (rose + violet)
/// - Sous-titre "Espace couple"
/// - Bouton bibliothèque à droite
///
/// Design:
/// - Background blanc avec opacité
/// - Border bottom subtile
/// - Dots 8x8 avec couleurs signature couple
///
/// Usage:
/// ```dart
/// ChatCoupleAppBar(
///   coupleId: 'couple_001',
///   onLibraryTap: (scrollCallback) => navigateToLibrary(),
/// )
/// ```
class ChatCoupleAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// ID du couple
  final String coupleId;

  /// Callback pour le scroll vers un message
  final Function(String messageId)? scrollToMessage;

  const ChatCoupleAppBar({
    super.key,
    required this.coupleId,
    this.scrollToMessage,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.sm,
            vertical: context.spacing.xs,
          ),
          child: Row(
            children: [
              // Titre centré avec dots
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dots + "Nous"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Dot rose
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: context.spacing.xxs),
                        // Dot violet
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: context.spacing.sm),
                        // Titre
                        Text(
                          'Nous',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.spacing.xxs),
                    // Sous-titre
                    Text(
                      'Espace couple',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton bibliothèque
              IconButton(
                icon: const Icon(Icons.bookmark_outline_rounded),
                tooltip: 'Bibliothèque',
                onPressed: () {
                  context.push(
                    '/library-us',
                    extra: {
                      'coupleId': coupleId,
                      'scrollToMessage': scrollToMessage,
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}