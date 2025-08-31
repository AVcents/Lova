// lib/features/chat_lova/ui/input_bar_lova.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat_lova/providers/lova_chat_providers.dart';

class InputBarLova extends ConsumerStatefulWidget {
  const InputBarLova({super.key});

  @override
  ConsumerState<InputBarLova> createState() => _InputBarLovaState();
}

class _InputBarLovaState extends ConsumerState<InputBarLova> {
  final TextEditingController _controller = TextEditingController();

  bool get _canSend => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    ref.read(lovaMessagesProvider.notifier).sendMessage(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 5, // grandit verticalement
                decoration: InputDecoration(
                  hintText: "Écris quelque chose…",
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  // Transparent pour garder le même background que l'écran de chat
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.4),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onSubmitted: (_) {}, // on reste en multiline
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              label: 'Envoyer',
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: _canSend ? _send : null,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _canSend ? 1.0 : 0.5,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.send_rounded, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}