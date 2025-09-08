// lib/features/chat/widgets/tag_action_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lova/shared/models/message_annotation.dart';
import 'package:lova/shared/providers/annotations_provider.dart';
import 'package:lova/shared/providers/tanks_provider.dart';
import 'package:lova/shared/ui/semantic_colors.dart';

/// Affiche la bottom sheet pour tagger un message
Future<void> showTagActionSheet(
  BuildContext context, {
  required String coupleId,
  required int messageId,
  required String currentUserId,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _TagActionSheetContent(
      coupleId: coupleId,
      messageId: messageId,
      currentUserId: currentUserId,
    ),
  );
}

class _TagActionSheetContent extends ConsumerStatefulWidget {
  final String coupleId;
  final int messageId;
  final String currentUserId;

  const _TagActionSheetContent({
    required this.coupleId,
    required this.messageId,
    required this.currentUserId,
  });

  @override
  ConsumerState<_TagActionSheetContent> createState() =>
      _TagActionSheetContentState();
}

class _TagActionSheetContentState
    extends ConsumerState<_TagActionSheetContent> {
  bool _isProcessing = false;

  Future<void> _handleTagSelection(AnnotationTag tag) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    HapticFeedback.lightImpact();

    try {
      // Créer l'annotation
      final annotation = MessageAnnotation(
        messageId: widget.messageId,
        coupleId: widget.coupleId,
        authorUserId: widget.currentUserId,
        tag: tag,
      );

      // Ajouter l'annotation via le notifier
      await ref
          .read(annotationsNotifierProvider.notifier)
          .addAnnotation(annotation);

      // Si c'est un tag utile, incrémenter le Love Tank
      if (tag.isUseful) {
        try {
          // Créer une action custom pour le tagging
          await ref
              .read(loveTankProvider.notifier)
              .incrementBy(
                LoveTankAction
                    .applyAdvice, // On utilise une action existante (+3 points)
              );
        } catch (e) {
          // Si le quota est atteint ou autre erreur, on continue silencieusement
          print('Impossible d\'incrémenter le Love Tank: $e');
        }
      }

      if (mounted) {
        // Fermer la bottom sheet
        Navigator.of(context).pop();

        // Afficher le SnackBar de confirmation
        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Text(
                  '${tag.emoji} ${tag.label} ajouté',
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
                if (tag.isUseful) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.favorite, size: 16, color: colorScheme.onPrimary),
                  const SizedBox(width: 4),
                  Text(
                    '+3',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            backgroundColor: SemanticColors.success(context),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Afficher une erreur si le tag existe déjà
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: SemanticColors.border(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Tagger ce message',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Ajoute un tag pour retrouver facilement ce message',
              style: textTheme.bodyMedium?.copyWith(
                color: SemanticColors.neutralOnSurface(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Tag options
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              )
            else
              ...AnnotationTag.values.map((tag) => _buildTagOption(tag)),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTagOption(AnnotationTag tag) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Couleur spécifique selon le type de tag
    Color getTagColor() {
      switch (tag) {
        case AnnotationTag.loveQuality:
        case AnnotationTag.favorite:
          return colorScheme.primary;
        case AnnotationTag.dealbreaker:
        case AnnotationTag.trigger:
          return SemanticColors.errorSoft(context);
        case AnnotationTag.giftIdea:
        case AnnotationTag.need:
          return SemanticColors.warning(context);
        case AnnotationTag.fact:
          return colorScheme.secondary;
      }
    }

    final tagColor = getTagColor();

    return Semantics(
      button: true,
      label: tag.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTagSelection(tag),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                // Emoji dans un container circulaire
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: tagColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tag.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag.label,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (tag.isUseful)
                        Text(
                          '+3 points Love Tank',
                          style: textTheme.bodySmall?.copyWith(
                            color: SemanticColors.success(context),
                          ),
                        ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: SemanticColors.neutralOnSurface(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
