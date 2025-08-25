import 'package:flutter/material.dart';

class InputBarCouple extends StatefulWidget {
  final Function(String) onSend;

  const InputBarCouple({super.key, required this.onSend});

  @override
  State<InputBarCouple> createState() => _InputBarCoupleState();
}

class _InputBarCoupleState extends State<InputBarCouple> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
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
                  hintText: "Écris ton message…",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _handleSend,
              icon: const Icon(Icons.send),
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}