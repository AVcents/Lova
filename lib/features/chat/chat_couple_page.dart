// lib/features/chat/chat_couple_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/chat/controllers/chat_couple_controller.dart';
import 'package:lova/features/chat/database/drift_database.dart';
import 'package:lova/features/chat/widgets/input_bar_couple.dart';
import 'package:lova/features/chat/widgets/message_bubble_couple.dart';
import 'package:lova/features/chat/analysis/conversation_analyzer.dart';
import 'package:lova/features/chat/ui/intervention_banner.dart';
import 'package:lova/features/chat/ui/mediation_sos_sheet.dart';
import 'package:lova/features/chat/ui/breath_sheet.dart';
import 'package:lova/features/chat/providers/intervention_metrics_provider.dart';
import 'package:lova/features/chat_lova/ui/composer_assist_sheet.dart';

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
  String coupleId = 'couple_001';
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _messageKeys = {};
  final GlobalKey<InputBarCoupleState> _inputBarKey = GlobalKey();
  bool _ranInitialAnalysis = false;

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
        curve: Curves.easeOut,
        alignment: 0.5,
      );

      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  void _handleRephrase(List<Message> messages) async {
    ref.read(interventionMetricsProvider).logRephrase();

    // Build a simple textual history for the composer (last 12 messages)
    final history = messages
        .take(12)
        .map((m) => m.content)
        .toList()
        .reversed
        .toList();

    // Short initial context from the last two messages
    final initialContext = messages.take(2).map((m) => m.content).join(' · ');

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ComposerAssistSheet(
        history: history,
        initialContext: initialContext,
      ),
    );

    if (result != null && mounted) {
      _inputBarKey.currentState?.insertText(result);
    }
  }

  void _handlePause() async {
    ref.read(interventionMetricsProvider).logPause();
    ref.read(conversationAnalyzerProvider.notifier).setSnooze(
      const Duration(minutes: 5),
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BreathSheet(),
    );
  }

  void _handleSos() async {
    ref.read(interventionMetricsProvider).logSos();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MediationSosSheet(
        onInsertToChat: (text) {
          if (mounted) {
            _inputBarKey.currentState?.insertText(text);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatCoupleControllerProvider);

    // Listen to message updates -> analyze
    ref.listen<List<Message>>(chatCoupleControllerProvider, (previous, next) {
      ref.read(conversationAnalyzerProvider.notifier).analyzeMessages(next);
    });

    // Log when banner becomes visible
    ref.listen(conversationAnalyzerProvider, (previous, next) {
      if ((previous == null || previous.status != next.status) &&
          next.status != InterventionStatus.calm) {
        ref.read(interventionMetricsProvider).logBannerShown(next.status.toString());
      }
    });

    // Run initial analysis once after first build
    if (!_ranInitialAnalysis) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(conversationAnalyzerProvider.notifier).analyzeMessages(messages);
        }
      });
      _ranInitialAnalysis = true;
    }

    final interventionState = ref.watch(conversationAnalyzerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final metrics = ref.read(interventionMetricsProvider);

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
            if (interventionState.status != InterventionStatus.calm)
              InterventionBanner(
                reason: interventionState.reason ?? '',
                isTension: interventionState.status == InterventionStatus.tension,
                onDismiss: () {
                  metrics.logDismiss(interventionState.status.toString());
                  ref.read(conversationAnalyzerProvider.notifier).dismissBanner();
                },
                onRephrase: () => _handleRephrase(messages),
                onPause: _handlePause,
                onSos: _handleSos,
              ),
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
                          if (mounted) {
                            setState(() {});
                          }
                        } : null,
                      ),
                    );
                  },
                ),
              ),
            ),
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
                  key: _inputBarKey,
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