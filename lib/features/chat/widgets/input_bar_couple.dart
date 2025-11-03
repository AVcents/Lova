// lib/features/chat/widgets/input_bar_couple.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat_lova/providers/lova_metrics_provider.dart';
import 'package:lova/features/chat_lova/ui/composer_assist_sheet.dart';
import 'package:lova/features/sos/providers/sos_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InputBarCouple extends ConsumerStatefulWidget {
  final Function(String) onSend;
  final List<String> messageHistory;
  final String? sosSessionId;
  final String? relationId;

  const InputBarCouple({
    super.key,
    required this.onSend,
    this.messageHistory = const [],
    this.sosSessionId,
    this.relationId,
  });

  @override
  InputBarCoupleState createState() => InputBarCoupleState();
}

class InputBarCoupleState extends ConsumerState<InputBarCouple> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSending = false;

  bool _canSend(bool canSpeak) => _controller.text.trim().isNotEmpty && !_isSending && canSpeak;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    print('📤 Sending message: $text');
    setState(() => _isSending = true);

    try {
      if (widget.sosSessionId != null) {
        print('🆘 SOS Mode - session: ${widget.sosSessionId}');

        final sb = Supabase.instance.client;
        final userId = sb.auth.currentUser!.id;

        final members = await sb
            .from('relation_members')
            .select('relation_id')
            .eq('user_id', userId)
            .limit(1);

        if (members.isEmpty) {
          throw Exception('Aucune relation trouvée');
        }

        final relationId = members.first['relation_id'] as String;

        print('📞 Calling Edge Function...');
        final service = ref.read(sosServiceProvider);
        final aiResponse = await service.sendMessage(
          sessionId: widget.sosSessionId!,
          userId: userId,
          message: text,
          relationId: relationId,
        );

        final aiPreview = aiResponse.length > 50
            ? '${aiResponse.substring(0, 50)}...'
            : aiResponse;
        print('✅ AI Response received: $aiPreview');
      } else {
        widget.onSend(text);
      }

      _controller.clear();
    } catch (e) {
      print('❌ Error sending: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text('Erreur: $e')),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
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
      builder: (context) =>
          ComposerAssistSheet(history: recentHistory, initialContext: ''),
    );

    if (selectedText != null && selectedText.isNotEmpty) {
      insertText(selectedText);
      ref.read(lovaMetricsProvider.notifier).logInserted();
    }
  }

  void insertText(String text) {
    final currentText = _controller.text.trim();

    if (currentText.isEmpty) {
      _controller.text = text;
    } else {
      _controller.text = '$currentText $text';
    }

    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
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

    // NEW: Récupérer session SOS active si existe
    final sosSession = widget.sosSessionId != null && widget.relationId != null
        ? ref.watch(activeSosSessionProvider(widget.relationId!)).value
        : null;

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final canSpeak = sosSession == null ||
        sosSession.currentSpeaker == null ||
        sosSession.currentSpeaker == currentUserId;

    // DESIGN FIX: Hauteur uniforme pour tous les éléments
    const double buttonHeight = 52.0;

    return Padding(
      padding: const EdgeInsets.all(16), // DESIGN FIX: Padding généreux
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end, // DESIGN FIX: Alignement bottom
        children: [
          // DESIGN FIX: TextField avec contraintes de hauteur
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: buttonHeight,
                maxHeight: 120,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA), // DESIGN FIX: Background subtil
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1), // DESIGN FIX: Border très subtile
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: canSpeak && !_isSending,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: canSpeak
                      ? "Écris ton message…"
                      : "C'est le tour de ton partenaire...",
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: canSpeak
                        ? colorScheme.onSurface.withOpacity(0.4)
                        : Colors.orange.withOpacity(0.7),
                  ),
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16, // DESIGN FIX: Padding pour centrer verticalement
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.primary.withOpacity(0.4), // DESIGN FIX: Focus subtil
                      width: 2,
                    ),
                  ),
                ),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12), // DESIGN FIX: Spacing cohérent

          // DESIGN FIX: Button LOVA Assist avec hauteur fixe
          Container(
            width: buttonHeight,
            height: buttonHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(buttonHeight / 2),
                onTap: canSpeak ? _openComposerAssist : null,
                child: Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12), // DESIGN FIX: Spacing cohérent

          // DESIGN FIX: Send button avec hauteur fixe et état visuel clair
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: buttonHeight,
            height: buttonHeight,
            decoration: BoxDecoration(
              gradient: _canSend(canSpeak)
                  ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withOpacity(0.8),
                ],
              )
                  : null,
              color: _canSend(canSpeak) ? null : colorScheme.outline.withOpacity(0.2),
              shape: BoxShape.circle,
              boxShadow: _canSend(canSpeak)
                  ? [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(buttonHeight / 2),
                onTap: _canSend(canSpeak)
                    ? () {
                  HapticFeedback.lightImpact();
                  _handleSend();
                }
                    : null,
                child: Center(
                  child: _isSending
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  )
                      : Icon(
                    Icons.send_rounded,
                    color: _canSend(canSpeak)
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface.withOpacity(0.3),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}