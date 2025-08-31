import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputBarCouple extends StatefulWidget {
  final Function(String) onSend;

  const InputBarCouple({super.key, required this.onSend});

  @override
  State<InputBarCouple> createState() => _InputBarCoupleState();
}

class _InputBarCoupleState extends State<InputBarCouple> {
  final TextEditingController _controller = TextEditingController();
  bool get _canSend => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                maxLines: 5, // grandit verticalement au lieu de décaler le texte
                decoration: InputDecoration(
                  hintText: "Écris ton message…",
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
                  ),
                ),
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              label: 'Envoyer',
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: _canSend ? () { HapticFeedback.lightImpact(); _handleSend(); } : null,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _canSend ? 1.0 : 0.5,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.send_rounded, color: colorScheme.onPrimary),
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