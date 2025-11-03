import 'package:flutter/material.dart';
import '../models/sos_session.dart';

class SosMessageBubble extends StatelessWidget {
  final SosEvent event;
  final String? currentUserId; // DESIGN FIX: Ajout pour différencier les utilisateurs

  const SosMessageBubble({
    super.key,
    required this.event,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isAI = event.eventType == 'ai_response';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // DESIGN FIX: Si c'est LOOVA, on centre tout
    if (isAI) {
      return _buildAIMessage(context, colorScheme, textTheme);
    }

    // DESIGN FIX: Messages users = comportement normal (droite/gauche)
    final isSentByMe = event.userId == currentUserId;

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isSentByMe ? colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isSentByMe ? 20 : 4),
            bottomRight: Radius.circular(isSentByMe ? 4 : 20),
          ),
          border: Border.all(
            color: isSentByMe
                ? colorScheme.primary.withOpacity(0.2)
                : colorScheme.outline.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSentByMe
                  ? colorScheme.primary.withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Text(
          event.content ?? '',
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            height: 1.4,
            color: isSentByMe ? colorScheme.onPrimary : colorScheme.onSurface,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  // DESIGN FIX: Message LOOVA centré avec avatar
  Widget _buildAIMessage(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar LOOVA centré
          Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF9C27B0),
                  Color(0xFFBA68C8),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C27B0).withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Badge "LOOVA"
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF9C27B0).withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Text(
              'LOOVA',
              style: textTheme.labelSmall?.copyWith(
                color: const Color(0xFF9C27B0),
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 0.8,
              ),
            ),
          ),

          // Bulle centrée
          Container(
            constraints: const BoxConstraints(
              maxWidth: 320,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF9C27B0).withOpacity(0.1),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF9C27B0).withOpacity(0.03),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C27B0).withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            child: Text(
              event.content ?? '',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                height: 1.5,
                color: colorScheme.onSurface,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}