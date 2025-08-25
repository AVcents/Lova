// lib/features/chat_lova/ui/message_bubble_lova.dart

import 'package:flutter/material.dart';
import 'package:lova/features/chat_lova/models/lova_message.dart';

class MessageBubbleLova extends StatelessWidget {
  final LovaMessage message;

  const MessageBubbleLova({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isFromUser;

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
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF6B9D),
                          Color(0xFFFF8A9B),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B9D).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '💝',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'LOVA',
                    style: TextStyle(
                      color: Color(0xFFFF6B9D),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],

            // Bulle de message
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              constraints: const BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                  colors: [
                    Color(0xFF2A2A2A), // Gris foncé
                    Color(0xFF1A1A1A), // Plus foncé
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : const LinearGradient(
                  colors: [
                    Color(0xFF1A1A1A), // Base foncée
                    Color(0xFF2A1A2A), // Très subtile teinte rose
                  ],
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
                      ? Colors.white.withOpacity(0.1)
                      : const Color(0xFFFF6B9D).withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? Colors.black.withOpacity(0.3)
                        : const Color(0xFFFF6B9D).withOpacity(0.1),
                    blurRadius: isUser ? 8 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.white,
                  fontWeight: isUser ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
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
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      // Aujourd'hui - juste l'heure
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      // Autre jour - date + heure
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}