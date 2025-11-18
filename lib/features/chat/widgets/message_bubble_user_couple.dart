// lib/features/chat/widgets/couple/message_bubble_user_couple.dart

import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';
import 'package:lova/features/chat/models/couple_message.dart';

/// Bulle de message utilisateur (toi) dans le chat couple
///
/// Affiche un message que TU as envoyé avec :
/// - Couleur primaire (Hot Pink/Corail)
/// - Alignement à droite
/// - Coin inférieur droit coupé (modern look)
/// - Shadow subtile
/// - Timestamp
///
/// Usage :
/// ```dart
/// MessageBubbleUserCouple(message: coupleMessage)
/// ```
class MessageBubbleUserCouple extends StatelessWidget {
  final CoupleMessage message;

  const MessageBubbleUserCouple({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.75,
          ),
          margin: EdgeInsets.only(
            bottom: context.spacing.md,
            left: context.spacing.xxxl * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bulle de message
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing.md,
                  vertical: context.spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(4), // Coin coupé
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.content,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),

              // Timestamp
              Padding(
                padding: EdgeInsets.only(
                  top: context.spacing.xxs,
                  right: context.spacing.xs,
                ),
                child: Text(
                  _formatTime(message.createdAt),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
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
      return '${timestamp.day}/${timestamp.month} '
          '${timestamp.hour.toString().padLeft(2, '0')}:'
          '${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}