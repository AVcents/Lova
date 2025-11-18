// lib/features/chat/widgets/couple/message_bubble_partner.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/core/theme/theme_extensions.dart';
import 'package:lova/features/auth/controller/auth_state_notifier.dart';
import 'package:lova/features/chat/models/couple_message.dart';
import 'package:lova/features/chat/widgets/tag_action_sheet.dart';
import 'package:lova/features/relation/providers/active_relation_provider.dart';
import 'package:lova/shared/providers/annotations_provider.dart';

/// Bulle de message du partenaire
///
/// Affiche un message envoyé par le partenaire avec :
/// - Dot coloré selon le sender (rose ou violet)
/// - Prénom du partenaire
/// - Alignement à gauche
/// - Couleur unie (violet clair)
/// - Coin inférieur gauche coupé (modern look)
/// - Timestamp
///
/// Usage :
/// ```dart
/// MessageBubblePartner(
///   message: coupleMessage,
///   senderName: 'Sarah',
/// )
/// ```
class MessageBubblePartner extends ConsumerWidget {
  final CoupleMessage message;
  final String senderName;

  const MessageBubblePartner({
    super.key,
    required this.message,
    required this.senderName,
  });

  /// Retourne la couleur du dot selon le sender
  Color _getDotColor(BuildContext context) {
    // Le partenaire utilise toujours la couleur primary
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerLeft,
        child: GestureDetector(
        onLongPress: () {
      HapticFeedback.mediumImpact();
      final authState = ref.read(authStateNotifierProvider);
      final currentUser = authState.maybeWhen(
        authenticated: (user) => user,
        orElse: () => null,
      );
      final activeRelation = ref.read(activeRelationProvider).value;

      if (currentUser != null && activeRelation != null) {
        showTagActionSheet(
          context,
          coupleId: activeRelation['id'] as String,
          messageId: message.id,
          currentUserId: currentUser.id,
        );
      }
    },
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
            // Header : Dot + Prénom
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dot coloré
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _getDotColor(context),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getDotColor(context).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: context.spacing.xs),

                // Prénom
                Text(
                  senderName,
                  style: textTheme.labelMedium?.copyWith(
                    color: _getDotColor(context),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacing.xs),

            // Bulle de message
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.md,
                vertical: context.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4), // Coin coupé
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: _getDotColor(context).withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),

            // Timestamp
            Padding(
              padding: EdgeInsets.only(
                top: context.spacing.xxs,
                left: context.spacing.xs,
              ),
              child: Text(
                _formatTime(message.createdAt),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
            ),
            // Annotations (emojis des tags)
            Consumer(
              builder: (context, ref, child) {
                final annotationsAsync = ref.watch(
                  annotationsByMessageProvider(message.id),
                );

                return annotationsAsync.when(
                  data: (annotations) {
                    if (annotations.isEmpty) return const SizedBox.shrink();

                    return Padding(
                      padding: EdgeInsets.only(
                        top: context.spacing.xxs,
                        left: context.spacing.xs,
                      ),
                      child: Wrap(
                        spacing: 6,
                        children: annotations.map((ann) {
                          return Text(
                            ann.tag.emoji,
                            style: const TextStyle(fontSize: 16),
                          );
                        }).toList(),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
        )
    );
  }

  /// Formate le timestamp en heure ou date+heure selon le jour
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