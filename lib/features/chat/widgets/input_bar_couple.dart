// lib/features/chat/widgets/input_bar_couple.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat_lova/ui/composer_assist_sheet.dart';
import 'package:lova/features/chat_lova/providers/lova_metrics_provider.dart';

class InputBarCouple extends ConsumerStatefulWidget {
  final Function(String) onSend;
  final List<String> messageHistory;

  const InputBarCouple({
    super.key,
    required this.onSend,
    this.messageHistory = const [],
  });

  @override
  InputBarCoupleState createState() => InputBarCoupleState();
}

class InputBarCoupleState extends ConsumerState<InputBarCouple> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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

  Future<void> _openComposerAssist() async {
    HapticFeedback.lightImpact();
    ref.read(lovaMetricsProvider.notifier).logOpened();

    final recentHistory = widget.messageHistory.length > 15
        ? widget.messageHistory.sublist(widget.messageHistory.length - 15)
        : widget.messageHistory;

    final selectedText = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ComposerAssistSheet(
        history: recentHistory,
        initialContext: '',
      ),
    );

    if (selectedText != null && selectedText.isNotEmpty) {
      insertText(selectedText);
      ref.read(lovaMetricsProvider.notifier).logInserted();
    }
  }

  /// Public method so other widgets (e.g., banners/SOS) can insert text via GlobalKey<InputBarCoupleState>.
  void insertText(String text) {
    final currentText = _controller.text.trim();

    if (currentText.isEmpty) {
      _controller.text = text;
    } else {
      _controller.text = '$currentText $text';
    }

    _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
                focusNode: _focusNode,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Écris ton message…",
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
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
              label: 'Aide LOVA',
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _openComposerAssist,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
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