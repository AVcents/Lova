// lib/features/chat_lova/ui/chat_lova_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat_lova/providers/lova_chat_providers.dart';
import 'package:lova/features/chat_lova/ui/input_bar_lova.dart';
import 'package:lova/features/chat_lova/ui/message_bubble_lova.dart';

class ChatLovaPage extends ConsumerWidget {
  const ChatLovaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(lovaMessagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat avec LOVA 🤖'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubbleLova(message: message);
              },
            ),
          ),
          const InputBarLova(),
        ],
      ),
    );
  }
}
