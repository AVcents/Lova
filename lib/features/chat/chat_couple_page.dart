// lib/features/chat/chat_couple_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:lova/features/chat/analysis/conversation_analyzer.dart';
import 'package:lova/features/chat/controllers/chat_couple_controller.dart';
import 'package:lova/features/chat/database/drift_database.dart';
import 'package:lova/features/chat/providers/intervention_metrics_provider.dart';
import 'package:lova/features/chat/ui/breath_sheet.dart';
import 'package:lova/features/chat/ui/intervention_banner.dart';
import 'package:lova/features/chat/ui/mediation_sos_sheet.dart';
import 'package:lova/features/chat/widgets/input_bar_couple.dart';
import 'package:lova/features/chat/widgets/message_bubble_couple.dart';
import 'package:lova/features/chat_lova/ui/composer_assist_sheet.dart';
import 'package:lova/features/sos/providers/sos_provider.dart';
import 'package:lova/features/sos/widgets/sos_message_bubble.dart';
import 'package:lova/features/sos/models/sos_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatCouplePage extends ConsumerStatefulWidget {
  final int? initialMessageId;
  final String? sosSessionId;

  const ChatCouplePage({super.key, this.initialMessageId, this.sosSessionId});

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

  // SOS detection state
  String? _activeSosSessionId;
  bool _inMediationMode = false;
  bool _isCurrentUserSpeaker = true;
  String? _relationId;

  @override
  void initState() {
    super.initState();
    _checkActiveSosSession();

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

  Future<void> _checkActiveSosSession() async {
    try {
      final sb = Supabase.instance.client;
      final userId = sb.auth.currentUser!.id;

      // Get relation_id
      final members = await sb
          .from('relation_members')
          .select('relation_id')
          .eq('user_id', userId)
          .limit(1);

      if (members.isEmpty) return;

      final relationId = members.first['relation_id'] as String;

      // Store relationId for later use
      setState(() {
        _relationId = relationId;
      });

      // Check active SOS session
      final session = await sb
          .from('sos_sessions')
          .select()
          .eq('relation_id', relationId)
          .eq('status', 'active')
          .order('started_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (session != null && mounted) {
        setState(() {
          _activeSosSessionId = session['id'] as String;
          _inMediationMode = true;

          // Vérifier si c'est le tour de cet user
          final currentSpeaker = session['current_speaker'] as String?;
          _isCurrentUserSpeaker = currentSpeaker == null || currentSpeaker == userId;
        });

        // Si phase welcome et aucun message LOOVA
        final events = await sb
            .from('sos_events')
            .select()
            .eq('session_id', session['id'])
            .eq('event_type', 'ai_response')
            .limit(1);

        if (events.isEmpty && session['current_phase'] == 'welcome') {
          _sendInitialLovaMessage();
        }
      }
    } catch (e) {
      print('❌ Error checking SOS session: $e');
    }
  }

  Future<void> _sendInitialLovaMessage() async {
    if (_activeSosSessionId == null) return;

    try {
      final sb = Supabase.instance.client;
      final userId = sb.auth.currentUser!.id;

      final members = await sb
          .from('relation_members')
          .select('relation_id')
          .eq('user_id', userId)
          .limit(1);

      if (members.isEmpty) return;

      final relationId = members.first['relation_id'] as String;

      // Appeler Edge Function avec message vide pour trigger welcome
      await sb.functions.invoke(
        'generate-sos-response',
        body: {
          'session_id': _activeSosSessionId,
          'user_message': '__INIT_WELCOME__',
          'user_id': userId,
          'relation_id': relationId,
        },
      );

      print('✅ Initial LOOVA message sent');
    } catch (e) {
      print('❌ Error sending initial message: $e');
    }
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

  void _handleRephrase(List<Message> messages) async {
    ref.read(interventionMetricsProvider).logRephrase();

    final history = messages
        .take(12)
        .map((m) => m.content)
        .toList()
        .reversed
        .toList();

    final initialContext = messages.take(2).map((m) => m.content).join(' · ');

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ComposerAssistSheet(history: history, initialContext: initialContext),
    );

    if (result != null && mounted) {
      _inputBarKey.currentState?.insertText(result);
    }
  }

  void _handlePause() async {
    ref.read(interventionMetricsProvider).logPause();
    ref
        .read(conversationAnalyzerProvider.notifier)
        .setSnooze(const Duration(minutes: 5));

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BreathSheet(),
    );
  }

  void _handleSos() async {
    ref.read(interventionMetricsProvider).logSos();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MediationSosSheet(
        onInsertToChat: (text) {
          if (mounted) {
            _inputBarKey.currentState?.insertText(text);
          }
        },
      ),
    );
  }

  Future<void> _showEndSessionDialog() async {
    int rating = 3;
    final summaryController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6), // DESIGN FIX: Backdrop premium
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              // DESIGN FIX: Card glassmorphism subtile
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 80,
                    offset: const Offset(0, 40),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DESIGN FIX: Header avec gradient subtil
                  Container(
                    padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF9C27B0).withOpacity(0.04),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DESIGN FIX: Icon badge élégant
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9C27B0).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            color: const Color(0xFF9C27B0),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Terminer la médiation',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Prenez un moment pour évaluer cette session',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // DESIGN FIX: Content avec padding cohérent
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DESIGN FIX: Rating section moderne
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber.shade700,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Note de résolution',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // DESIGN FIX: Stars élégantes
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final isSelected = index < rating;
                                  return GestureDetector(
                                    onTap: () => setState(() => rating = index + 1),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.amber.shade100
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        isSelected
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        color: isSelected
                                            ? Colors.amber.shade700
                                            : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.3),
                                        size: 32,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // DESIGN FIX: TextField moderne avec label séparé
                        Text(
                          'Résumé (optionnel)',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: summaryController,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Comment vous sentez-vous maintenant ?',
                              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.4),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            maxLines: 3,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // DESIGN FIX: Actions modernes
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  'Annuler',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  backgroundColor: const Color(0xFF9C27B0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Terminer'),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.check_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (result == true && mounted) {
      try {
        final service = ref.read(sosServiceProvider);
        await service.endSession(
          sessionId: _activeSosSessionId!,
          rating: rating,
          summary: summaryController.text.trim().isEmpty
              ? null
              : summaryController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  const Text('Médiation terminée avec succès'),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          );

          context.go('/dashboard');
        }
      } catch (e) {
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          );
        }
      }
    }
  }

  Widget _buildMediationBanner(SosSession session) {
    final phaseLabels = {
      'welcome': 'Accueil',
      'dialogue_1': 'Dialogue - Tour 1/3',
      'dialogue_2': 'Dialogue - Tour 2/3',
      'dialogue_3': 'Dialogue - Tour 3/3',
      'ritual': 'Suggestion rituel',
      'future_vision': 'Projection future',
      'closing': 'Clôture',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B9D).withOpacity(0.12),
            const Color(0xFFFFA06B).withOpacity(0.08),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFFF6B9D).withOpacity(0.25),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text('🆘', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Médiation LOOVA en cours',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF6B9D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  phaseLabels[session.currentPhase] ?? session.currentPhase,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black87.withOpacity(0.65),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!_isCurrentUserSpeaker)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Text(
                'Écoute...',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatCoupleControllerProvider);

    // Watch SOS events si médiation active
    final sosSessionAsync = _inMediationMode && _activeSosSessionId != null
        ? ref.watch(sosEventsProvider(_activeSosSessionId!))
        : null;

    if (sosSessionAsync != null) {
      sosSessionAsync.whenData((events) {
        print('🔥 SOS Events: ${events.length} events');
        for (var event in events) {
          final contentPreview = event.content != null && event.content!.length > 50
              ? '${event.content!.substring(0, 50)}...'
              : event.content ?? 'null';
          print('  - ${event.eventType}: $contentPreview');
        }
      });
    }

    ref.listen<List<Message>>(chatCoupleControllerProvider, (previous, next) {
      ref.read(conversationAnalyzerProvider.notifier).analyzeMessages(next);
    });

    ref.listen(conversationAnalyzerProvider, (previous, next) {
      if ((previous == null || previous.status != next.status) &&
          next.status != InterventionStatus.calm) {
        ref
            .read(interventionMetricsProvider)
            .logBannerShown(next.status.toString());
      }
    });

    if (!_ranInitialAnalysis) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(conversationAnalyzerProvider.notifier)
              .analyzeMessages(messages);
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
      // DESIGN FIX: Background blanc pur, PAS de rose
      backgroundColor: const Color(0xFFF8F9FA),
      // DESIGN FIX: AppBar avec glassmorphism subtil
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
                            // DESIGN FIX: Avatar dual moderne
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B9D),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0),
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
                  if (_inMediationMode)
                  // DESIGN FIX: Button premium pour terminer
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9C27B0).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF9C27B0),
                        ),
                        tooltip: 'Terminer la médiation',
                        onPressed: () => _showEndSessionDialog(),
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
                  // DESIGN FIX: Switch user button moderne
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
          if (_inMediationMode && _relationId != null)
            Consumer(
              builder: (context, ref, _) {
                final sessionAsync = ref.watch(activeSosSessionProvider(_relationId!));
                return sessionAsync.when(
                  data: (session) => session != null
                      ? _buildMediationBanner(session)
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            )
          else if (interventionState.status != InterventionStatus.calm)
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
              child: sosSessionAsync != null
                  ? sosSessionAsync.when(
                data: (sosEvents) {
                  print('📄 Building SOS ListView with ${sosEvents.length} events');

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 20,
                      bottom: 100,
                    ),
                    itemCount: sosEvents.length,
                    itemBuilder: (context, index) {
                      final event = sosEvents[sosEvents.length - 1 - index];

                      print('  Rendering event: ${event.eventType}');

                      if (event.eventType == 'user_message' ||
                          event.eventType == 'ai_response') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SosMessageBubble(
                            event: event,
                            currentUserId: Supabase.instance.client.auth.currentUser?.id,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                },
                loading: () {
                  print('⏳ SOS Events loading...');
                  // DESIGN FIX: Loading premium avec animation
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF9C27B0).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Chargement de la conversation...',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                error: (e, stack) {
                  print('❌ SOS Events error: $e');
                  // DESIGN FIX: Error state élégant et actionnable
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.all(32),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.08),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.error.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.wifi_off_rounded,
                              color: colorScheme.error.withOpacity(0.7),
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Connexion perdue',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Impossible de charger les messages.\nVérifiez votre connexion internet.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () {
                              // Retry logic
                              setState(() {});
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 20),
                            label: const Text('Réessayer'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : ListView.builder(
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
                      // DESIGN FIX: Highlight subtil, pas rose
                      color: const Color(0xFF9C27B0).withOpacity(0.04),
                      border: Border.all(
                        color: const Color(0xFF9C27B0).withOpacity(0.15),
                        width: 2,
                      ),
                    )
                        : null,
                    padding: isTargeted
                        ? const EdgeInsets.all(12)
                        : null,
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
// DESIGN FIX: Input bar avec glassmorphism + hauteur cohérente
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
                      vertical: 12, // DESIGN FIX: Padding vertical uniforme
                    ),
                    child: InputBarCouple(
                      key: _inputBarKey,
                      sosSessionId: _activeSosSessionId,
                      relationId: _relationId,
                      onSend: (content) {
                        final receiverId = currentUserId == 'userA'
                            ? 'userB'
                            : 'userA';
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