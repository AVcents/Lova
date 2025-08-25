// lib/features/chat_lova/ui/input_bar_lova.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat_lova/providers/lova_chat_providers.dart';

class InputBarLova extends ConsumerStatefulWidget {
  const InputBarLova({super.key});

  @override
  ConsumerState<InputBarLova> createState() => _InputBarLovaState();
}

class _InputBarLovaState extends ConsumerState<InputBarLova> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    ref.read(lovaMessagesProvider.notifier).sendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Écris quelque chose...",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _send,
              icon: const Icon(Icons.send),
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}