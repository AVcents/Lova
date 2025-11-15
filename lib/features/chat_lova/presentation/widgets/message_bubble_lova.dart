// lib/features/chat_lova/presentation/widgets/message_bubble_lova.dart

import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';
import 'package:lova/core/theme/loova_colors.dart';
import 'package:lova/features/chat_lova/models/lova_message.dart';

/// Bulle de message LOOVA (IA)
///
/// Affiche un message envoyé par LOOVA avec :
/// - Gradient signature LOOVA (rose → corail)
/// - Avatar 32x32 avec gradient + emoji 💜
/// - Label "LOOVA"
/// - Alignement à gauche
/// - Coin inférieur gauche coupé (modern look)
/// - Shadow avec teinte corail
/// - Timestamp
///
/// Usage :
/// ```dart
/// MessageBubbleLova(message: lovaMessage)
/// ```
class MessageBubbleLova extends StatelessWidget {
  final LovaMessage message;

  const MessageBubbleLova({
    super.key,
    required this.message,
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
          maxWidth: screenWidth * 0.80, // 80% de la largeur d'écran
        ),
        margin: EdgeInsets.only(
          bottom: context.spacing.md,
          right: context.spacing.xxxl, // 40px - empêche bulle trop large
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header : Avatar + Label "LOOVA"
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar LOOVA avec gradient
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LoovaColors.gradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: LoovaColors.shadowColor(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/loova_avatar.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
                  ),
                ),

                SizedBox(width: context.spacing.xs),

                // Label "LOOVA"
                Text(
                  'LOVA',
                  style: textTheme.labelMedium?.copyWith(
                    color: LoovaColors.gradientEnd,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacing.xs),

            // Bulle de message avec gradient
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.md,
                vertical: context.spacing.sm,
              ),
              decoration: BoxDecoration(
                gradient: LoovaColors.gradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4), // Coin coupé
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: LoovaColors.shadowColor(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
                _formatTime(message.timestamp),
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
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}