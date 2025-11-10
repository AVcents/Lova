// lib/features/chat/chat_couple_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:lova/features/chat/controllers/chat_couple_controller.dart';
import 'package:lova/features/chat/database/drift_database.dart';
import 'package:lova/features/chat/widgets/input_bar_couple.dart';
import 'package:lova/features/chat/widgets/message_bubble_couple.dart';

class ChatCouplePage extends ConsumerStatefulWidget {
  final int? initialMessageId;

  const ChatCouplePage({super.key, this.initialMessageId});

  @override
  ConsumerState<ChatCouplePage> createState() => _ChatCouplePageState();
}

class _ChatCouplePageState extends ConsumerState<ChatCouplePage> {
  String currentUserId = 'userA';
  String coupleId = 'couple_001';
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _messageKeys = {};
  final GlobalKey<InputBarCoupleState> _inputBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();

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

  void scrollToMessage(int messageId) {
    final key = _messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: 0.5,
      );

      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatCoupleControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    for (final message in messages) {
      _messageKeys.putIfAbsent(message.id, () => GlobalKey());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withOpacity(0.06),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B9D),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF9C27B0),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Nous',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Espace couple',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_outline_rounded),
                    tooltip: 'Bibliothèque',
                    onPressed: () {
                      context.push(
                        '/library-us',
                        extra: {
                          'coupleId': coupleId,
                          'scrollToMessage': scrollToMessage,
                        },
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.swap_horiz_rounded,
                        color: colorScheme.primary,
                      ),
                      tooltip: 'Changer d\'utilisateur',
                      onPressed: toggleUser,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 100,
                ),
                reverse: true,
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  final isTargeted = widget.initialMessageId == message.id;

                  return AnimatedContainer(
                    key: _messageKeys[message.id],
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    decoration: isTargeted
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF9C27B0).withOpacity(0.04),
                            border: Border.all(
                              color: const Color(0xFF9C27B0).withOpacity(0.15),
                              width: 2,
                            ),
                          )
                        : null,
                    padding: isTargeted ? const EdgeInsets.all(12) : null,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: MessageBubbleCouple(
                      message: message,
                      currentUserId: currentUserId,
                      coupleId: coupleId,
                      onTap: isTargeted
                          ? () {
                              if (mounted) {
                                setState(() {});
                              }
                            }
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withOpacity(0.06),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: InputBarCouple(
                      key: _inputBarKey,
                      onSend: (content) {
                        final receiverId =
                            currentUserId == 'userA' ? 'userB' : 'userA';
                        ref
                            .read(chatCoupleControllerProvider.notifier)
                            .sendMessage(
                              senderId: currentUserId,
                              receiverId: receiverId,
                              content: content,
                            );
                      },
                    ),
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
