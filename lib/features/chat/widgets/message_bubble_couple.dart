// lib/features/chat/widgets/message_bubble_couple.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/chat/database/drift_database.dart';

import 'package:lova/shared/models/message_annotation.dart';
import 'package:lova/shared/providers/annotations_provider.dart';
import 'package:lova/features/chat/widgets/tag_action_sheet.dart';

class MessageBubbleCouple extends ConsumerWidget {
  final Message message;
  final String currentUserId;
  final String coupleId;
  final VoidCallback? onTap;

  const MessageBubbleCouple({
    super.key,
    required this.message,
    required this.currentUserId,
    this.coupleId = 'couple_001', // Default pour le sprint
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSentByMe = message.senderId == currentUserId;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bubbleColor = isSentByMe
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final textColor = isSentByMe
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    // Récupérer les annotations pour ce message
    final annotationsAsync = ref.watch(
      annotationsByMessageProvider(message.id),
    );

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSentByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Bulle de message avec long press
          GestureDetector(
            onLongPress: () {
              HapticFeedback.mediumImpact();
              showTagActionSheet(
                context,
                coupleId: coupleId,
                messageId: message.id,
                currentUserId: currentUserId,
              );
            },
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: bubbleColor,
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.15),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isSentByMe ? 12 : 0),
                  bottomRight: Radius.circular(isSentByMe ? 0 : 12),
                ),
              ),
              child: Text(
                message.content,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: textColor,
                ),
              ),
            ),
          ),

          // Chips des tags
          annotationsAsync.when(
            data: (annotations) {
              if (annotations.isEmpty) return const SizedBox.shrink();

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Container(
                  key: ValueKey(annotations.length),
                  margin: const EdgeInsets.only(top: 4, bottom: 4),
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    alignment: isSentByMe
                        ? WrapAlignment.end
                        : WrapAlignment.start,
                    children: _buildTagChips(context, ref, annotations),
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTagChips(
    BuildContext context,
    WidgetRef ref,
    List<MessageAnnotation> annotations,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Grouper les annotations par tag
    final Map<AnnotationTag, int> tagCounts = {};
    for (final annotation in annotations) {
      tagCounts[annotation.tag] = (tagCounts[annotation.tag] ?? 0) + 1;
    }

    final chips = <Widget>[];
    int displayedCount = 0;
    const maxChips = 3;

    for (final entry in tagCounts.entries) {
      if (displayedCount >= maxChips) {
        // Ajouter le chip "+N"
        final remaining = tagCounts.length - displayedCount;
        chips.add(
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // Naviguer vers la bibliothèque avec filtre
              context.push('/library-us?filter=${entry.key.name}');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.15),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+$remaining',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
        break;
      }

      chips.add(
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // Naviguer vers la bibliothèque avec ce filtre
            context.push('/library-us?filter=${entry.key.name}');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.15),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.key.emoji, style: const TextStyle(fontSize: 12)),
                if (entry.value > 1) ...[
                  const SizedBox(width: 4),
                  Text(
                    '${entry.value}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
      displayedCount++;
    }

    return chips;
  }
}
