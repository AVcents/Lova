import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lova/core/theme/theme_extensions.dart';
import 'package:lova/shared/widgets/cards/loova_card.dart';

/// Widget de la barre de saisie du chat LOVA
///
/// Design:
/// - Card flottante pill-shaped (radius 28px)
/// - TextField multiline (1-5 lignes)
/// - Bouton Send circulaire (48×48) avec animations
/// - Haptic feedback au tap
///
/// États:
/// - Enabled/Disabled selon [enabled]
/// - Send button actif seulement si texte non vide
/// - Animations scale + opacity sur le bouton
///
/// Usage:
/// ```dart
/// ChatInputBar(
///   controller: _textController,
///   onSend: (text) => _sendMessage(text),
///   enabled: !isLovaTyping,
/// )
/// ```
class ChatInputBar extends StatefulWidget {
  /// Controller du TextField
  final TextEditingController controller;

  /// Callback appelé quand on envoie un message
  final void Function(String text) onSend;

  /// Si false, le TextField et le bouton sont désactivés
  final bool enabled;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final FocusNode _focusNode = FocusNode();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateSendButton);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateSendButton);
    _focusNode.dispose();
    super.dispose();
  }

  /// Met à jour l'état du bouton Send selon le contenu du TextField
  void _updateSendButton() {
    final newCanSend = widget.controller.text.trim().isNotEmpty && widget.enabled;
    if (newCanSend != _canSend) {
      setState(() {
        _canSend = newCanSend;
      });
    }
  }

  /// Envoie le message et reset le TextField
  void _send() {
    if (!_canSend) return;

    final text = widget.controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.sm),
        child: LoovaCard(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.md,
            vertical: context.spacing.xs,
          ),
          borderRadius: 28, // Pill-shaped
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // TextField
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  maxLines: 5,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Écris quelque chose…',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: context.spacing.sm,
                    ),
                    isDense: true,
                  ),
                ),
              ),

              SizedBox(width: context.spacing.xs),

              // Send button
              AnimatedScale(
                scale: _canSend ? 1.0 : 0.9,
                duration: context.durations.fast,
                curve: context.motion.easeOut,
                child: AnimatedOpacity(
                  opacity: _canSend ? 1.0 : 0.5,
                  duration: context.durations.fast,
                  child: GestureDetector(
                    onTap: _canSend
                        ? () {
                      HapticFeedback.mediumImpact();
                      _send();
                    }
                        : null,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: _canSend
                            ? [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                            : null,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: colorScheme.onPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}