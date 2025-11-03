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
    this.coupleId = 'couple_001',
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSentByMe = message.senderId == currentUserId;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // DESIGN FIX: Couleurs sophistiquées selon l'expéditeur
    final bubbleColor = isSentByMe
        ? colorScheme.primary
        : Colors.white;
    final textColor = isSentByMe
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

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
          // DESIGN FIX: Bulle premium avec shadow et glassmorphism subtil
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
              constraints: const BoxConstraints(maxWidth: 280), // DESIGN FIX: Largeur optimale
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20), // DESIGN FIX: Radius cohérent
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isSentByMe ? 20 : 4), // DESIGN FIX: Asymétrie élégante
                  bottomRight: Radius.circular(isSentByMe ? 4 : 20),
                ),
                border: Border.all(
                  // DESIGN FIX: Border ultra-subtile
                  color: isSentByMe
                      ? colorScheme.primary.withOpacity(0.2)
                      : colorScheme.outline.withOpacity(0.08),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    // DESIGN FIX: Shadow colorée subtile pour messages envoyés
                    color: isSentByMe
                        ? colorScheme.primary.withOpacity(0.12)
                        : Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16, // DESIGN FIX: Breathing room
                vertical: 14,
              ),
              child: Text(
                message.content,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.4, // DESIGN FIX: Line-height confortable
                  color: textColor,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),

          // DESIGN FIX: Tags chips redesignés
          annotationsAsync.when(
            data: (annotations) {
              if (annotations.isEmpty) return const SizedBox.shrink();

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOutCubic, // DESIGN FIX: Animation premium
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey(annotations.length),
                  margin: const EdgeInsets.only(top: 8), // DESIGN FIX: Spacing cohérent
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Wrap(
                    spacing: 6, // DESIGN FIX: Spacing généreux
                    runSpacing: 6,
                    alignment: isSentByMe
                        ? WrapAlignment.end
                        : WrapAlignment.start,
                    children: _buildTagChips(context, ref, annotations, isSentByMe),
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
      bool isSentByMe,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final Map<AnnotationTag, int> tagCounts = {};
    for (final annotation in annotations) {
      tagCounts[annotation.tag] = (tagCounts[annotation.tag] ?? 0) + 1;
    }

    final chips = <Widget>[];
    int displayedCount = 0;
    const maxChips = 4; // DESIGN FIX: Afficher plus car ils sont discrets

    for (final entry in tagCounts.entries) {
      if (displayedCount >= maxChips) {
        final remaining = tagCounts.length - displayedCount;
        chips.add(
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.push('/library-us?filter=${entry.key.name}');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.06), // DESIGN FIX: Background ultra-subtil
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+$remaining',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
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
            context.push('/library-us?filter=${entry.key.name}');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // DESIGN FIX: Emoji nu, sans fond, plus petit
              Text(
                entry.key.emoji,
                style: const TextStyle(
                  fontSize: 16, // DESIGN FIX: Taille délicate
                ),
              ),
              if (entry.value > 1) ...[
                const SizedBox(width: 3), // DESIGN FIX: Spacing minimal
                // DESIGN FIX: Counter ultra-discret
                Text(
                  '${entry.value}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.4), // DESIGN FIX: Très subtil
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
      displayedCount++;
    }

    return chips;
  }
  // DESIGN FIX: Helper pour chips élégants et cohérents
  Widget _buildChip({
    required BuildContext context,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required bool isSentByMe,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // DESIGN FIX: Radius cohérent
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.08), // DESIGN FIX: Border ultra-subtile
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03), // DESIGN FIX: Shadow subtile
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}