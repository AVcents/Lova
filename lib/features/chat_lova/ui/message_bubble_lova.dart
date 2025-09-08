// lib/features/chat_lova/ui/message_bubble_lova.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/chat_lova/models/lova_message.dart';

import 'package:lova/shared/models/message_annotation.dart';
import 'package:lova/shared/providers/annotations_provider.dart';
import 'package:lova/features/chat/widgets/tag_action_sheet.dart';

class MessageBubbleLova extends ConsumerWidget {
  final LovaMessage message;
  final String coupleId;
  final String currentUserId;

  const MessageBubbleLova({
    super.key,
    required this.message,
    this.coupleId = 'couple_001',
    this.currentUserId = 'userA',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = message.isFromUser;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Récupérer les annotations pour ce message
    // Pour LOVA, on utilise un hash du message.id comme int pour la compatibilité
    final messageIdAsInt = message.id.hashCode;
    final annotationsAsync = ref.watch(
      annotationsByMessageProvider(messageIdAsInt),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12,
          top: 4,
          left: isUser ? 40 : 0,
          right: isUser ? 0 : 40,
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Nom/Label avec avatar pour LOVA
            if (!isUser) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.secondary, colorScheme.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.secondary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('💜', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LOVA',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],

            // Bulle de message avec long-press
            GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                showTagActionSheet(
                  context,
                  coupleId: coupleId,
                  messageId: messageIdAsInt,
                  currentUserId: currentUserId,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                constraints: const BoxConstraints(maxWidth: 280),
                decoration: BoxDecoration(
                  color: isUser ? colorScheme.primary : null,
                  gradient: isUser
                      ? null
                      : LinearGradient(
                          colors: [colorScheme.secondary, colorScheme.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  border: Border.all(
                    color: isUser
                        ? colorScheme.outline.withOpacity(0.15)
                        : colorScheme.secondary.withOpacity(0.25),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isUser ? colorScheme.primary : colorScheme.secondary)
                              .withOpacity(0.20),
                      blurRadius: isUser ? 8 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  message.content,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    height: 1.4,
                    color: colorScheme.onPrimary,
                    fontWeight: isUser ? FontWeight.w500 : FontWeight.w600,
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
                    margin: const EdgeInsets.only(top: 4),
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      alignment: isUser
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

            // Timestamp
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                left: isUser ? 0 : 8,
                right: isUser ? 8 : 0,
              ),
              child: Text(
                _formatTime(message.timestamp),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
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

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      // Aujourd'hui - juste l'heure
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      // Autre jour - date + heure
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
