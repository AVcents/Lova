import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat/controllers/chat_couple_controller.dart';
import 'package:lova/features/chat/database/drift_database.dart';
import 'package:lova/features/chat/widgets/input_bar_couple.dart';
import 'package:lova/features/chat/widgets/message_bubble_couple.dart';

class ChatCouplePage extends ConsumerStatefulWidget {
  const ChatCouplePage({super.key});

  @override
  ConsumerState<ChatCouplePage> createState() => _ChatCouplePageState();
}

class _ChatCouplePageState extends ConsumerState<ChatCouplePage> {
  String currentUserId = 'userA';

  void toggleUser() {
    setState(() {
      currentUserId = currentUserId == 'userA' ? 'userB' : 'userA';
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatCoupleControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat : $currentUserId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: 'Changer d’utilisateur',
            onPressed: toggleUser,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return MessageBubbleCouple(
                  message: message,
                  currentUserId: currentUserId,
                );
              },
            ),
          ),
          InputBarCouple(
            onSend: (content) {
              final receiverId = currentUserId == 'userA' ? 'userB' : 'userA';
              ref.read(chatCoupleControllerProvider.notifier).sendMessage(
                senderId: currentUserId,
                receiverId: receiverId,
                content: content,
              );
            },
          ),
        ],
      ),
    );
  }
}