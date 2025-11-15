import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/core/theme/theme_extensions.dart';
import 'package:lova/features/chat_lova/presentation/widgets/chat_empty_state.dart';
import 'package:lova/features/chat_lova/presentation/widgets/chat_input_bar.dart';
import 'package:lova/features/chat_lova/presentation/widgets/message_bubble_user.dart';
import 'package:lova/features/chat_lova/presentation/widgets/message_bubble_lova.dart';
import 'package:lova/features/chat_lova/presentation/widgets/typing_indicator.dart';
import 'package:lova/features/chat_lova/providers/lova_chat_providers.dart';

/// Page principale du Chat LOVA
class ChatLovaPage extends ConsumerStatefulWidget {
  const ChatLovaPage({super.key});

  @override
  ConsumerState<ChatLovaPage> createState() => _ChatLovaPageState();
}

class _ChatLovaPageState extends ConsumerState<ChatLovaPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// Scroll automatique vers le bas (dernier message)
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: context.durations.normal,
            curve: context.motion.easeOut,
          );
        }
      });
    }
  }

  /// Envoie un message texte
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Envoyer le message via le provider
    ref.read(lovaMessagesProvider.notifier).sendMessage(text);

    // Effacer le champ de texte
    _textController.clear();

    // Indiquer que LOVA est en train de taper
    setState(() {
      _isTyping = true;
    });

    // Scroll vers le bas après un court délai
    _scrollToBottom();

    // Simuler fin du typing après 2 secondes (à adapter selon votre logique)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  /// Gère le tap sur une suggestion de l'empty state
  void _handleSuggestionTap(String suggestion) {
    _sendMessage(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer les messages depuis le provider
    final messages = ref.watch(lovaMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        // AppBar minimaliste
        elevation: 0,
        title: const Text('Échange avec Loova'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Zone de messages (scrollable)
          Expanded(
            child: messages.isEmpty
                ? ChatEmptyState(
                    onSuggestionTap: _handleSuggestionTap,
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing.md,
                      vertical: context.spacing.lg,
                    ),
                    itemCount: messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Typing indicator en dernier
                      if (_isTyping && index == messages.length) {
                        return const TypingIndicator();
                      }

                      final message = messages[index];

                      // Afficher le bon type de bubble selon le message
                      if (message.isFromUser) {
                        return MessageBubbleUser(
                          message: message,
                        );
                      } else {
                        return MessageBubbleLova(
                          message: message,
                        );
                      }
                    },
                  ),
          ),

          // Input bar (flottante en bas)
          ChatInputBar(
            controller: _textController,
            onSend: _sendMessage,
            enabled: !_isTyping, // Désactiver pendant que LOVA écrit
          ),
        ],
      ),
    );
  }
}
