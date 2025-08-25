import 'package:flutter/material.dart';
import 'package:lova/features/chat/database/drift_database.dart';

class MessageBubbleCouple extends StatelessWidget {
  final Message message;
  final String currentUserId;

  const MessageBubbleCouple({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isSentByMe = message.senderId == currentUserId;

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.teal.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isSentByMe ? 12 : 0),
            bottomRight: Radius.circular(isSentByMe ? 0 : 12),
          ),
        ),
        child: Text(
          message.content,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}