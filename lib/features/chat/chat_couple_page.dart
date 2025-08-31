// lib/features/chat/chat_couple_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/chat/controllers/chat_couple_controller.dart';
import 'package:lova/features/chat/database/drift_database.dart';
import 'package:lova/features/chat/widgets/input_bar_couple.dart';
import 'package:lova/features/chat/widgets/message_bubble_couple.dart';

class ChatCouplePage extends ConsumerStatefulWidget {
  final int? initialMessageId;

  const ChatCouplePage({
    super.key,
    this.initialMessageId,
  });

  @override
  ConsumerState<ChatCouplePage> createState() => _ChatCouplePageState();
}

class _ChatCouplePageState extends ConsumerState<ChatCouplePage> {
  String currentUserId = 'userA';
  String coupleId = 'couple_001'; // Pour le sprint 1
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _messageKeys = {};

  @override
  void initState() {
    super.initState();
    // Si on a un messageId initial, on scroll vers lui après le build
    if (widget.initialMessageId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToMessage(widget.initialMessageId!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void toggleUser() {
    setState(() {
      currentUserId = currentUserId == 'userA' ? 'userB' : 'userA';
    });
  }

  /// Fait défiler jusqu'à un message spécifique
  void scrollToMessage(int messageId) {
    final key = _messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        alignment: 0.5, // Centre le message dans la vue
      );

      // Effet visuel pour indiquer le message ciblé
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {
            // Force un rebuild pour animer le message
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatCoupleControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Créer les clés pour chaque message
    for (final message in messages) {
      _messageKeys.putIfAbsent(message.id, () => GlobalKey());
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nous',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Chat de couple',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Bibliothèque',
            onPressed: () {
              // Naviguer vers la bibliothèque avec callback
              context.push(
                '/library-us',
                extra: {
                  'coupleId': coupleId,
                  'scrollToMessage': scrollToMessage,
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: 'Changer d\'utilisateur',
            onPressed: toggleUser,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: colorScheme.outline.withOpacity(0.12),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.04),
              Colors.transparent,
            ],
            stops: const [0.0, 0.6],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isTargeted = widget.initialMessageId == message.id;

                    return AnimatedContainer(
                      key: _messageKeys[message.id],
                      duration: const Duration(milliseconds: 300),
                      decoration: isTargeted ? BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: colorScheme.primary.withOpacity(0.1),
                      ) : null,
                      padding: isTargeted ? const EdgeInsets.all(4) : null,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: MessageBubbleCouple(
                        message: message,
                        currentUserId: currentUserId,
                        coupleId: coupleId,
                        onTap: isTargeted ? () {
                          // Retirer le highlight après tap
                          if (mounted) {
                            setState(() {
                              // Force rebuild sans highlight
                            });
                          }
                        } : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Input bar on a surfaced container with a subtle top border
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(color: colorScheme.outline.withOpacity(0.12)),
                ),
              ),
              child: SafeArea(
                top: false,
                child: InputBarCouple(
                  onSend: (content) {
                    final receiverId = currentUserId == 'userA' ? 'userB' : 'userA';
                    ref.read(chatCoupleControllerProvider.notifier).sendMessage(
                      senderId: currentUserId,
                      receiverId: receiverId,
                      content: content,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}