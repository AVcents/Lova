import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lova/features/us_dashboard/models/game_session.dart';
import 'package:lova/features/us_dashboard/models/game_card.dart';
import 'package:lova/features/us_dashboard/models/game_card_answer.dart';
import 'package:lova/features/us_dashboard/providers/games_provider.dart';

class IntimacyCardGameScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const IntimacyCardGameScreen({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<IntimacyCardGameScreen> createState() =>
      _IntimacyCardGameScreenState();
}

class _IntimacyCardGameScreenState
    extends ConsumerState<IntimacyCardGameScreen> {
  final _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch la session en temps réel
    final sessionAsync = ref.watch(currentGameSessionProvider(widget.sessionId));
    final cardsAsync = ref.watch(sessionCardsProvider(widget.sessionId));


    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: sessionAsync.when(
        data: (session) => cardsAsync.when(
          data: (cards) => _buildGameScreen(context, session, cards),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Erreur cartes: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur session: $e')),
      ),
    );
  }

  Widget _buildGameScreen(
      BuildContext context, GameSession session, List<GameCard> cards) {
    final currentUserId = ref.read(supabaseClientProvider).auth.currentUser!.id;
    final currentCardIndex = session.cardsCompleted;

    if (currentCardIndex >= cards.length) {
      return _buildCompletedScreen(session.gameId);
    }

    final currentCard = cards[currentCardIndex];
    final answers = ref.watch(sessionAnswersProvider(widget.sessionId)).maybeWhen(
      data: (list) => list,
      orElse: () => <GameCardAnswer>[],
    );
    final currentCardAnswer = answers.where((a) => a.cardId == currentCard.id).firstOrNull;

    final isMyTurn = session.isPlayerTurn(currentUserId);
    final hasAnswer = currentCardAnswer != null;

    final isView1 = isMyTurn && !hasAnswer;  // Mon tour, je réponds
    final isView2 = !isMyTurn && !hasAnswer; // Pas mon tour, j'attends
    final isView3 = !isMyTurn && hasAnswer;  // Pas mon tour, je lis
    final isView4 = isMyTurn && hasAnswer;   // J'ai répondu, en attente validation partenaire
    print('🔍 [${currentUserId == "b2b22420-b62e-4362-b516-b6549cf7562f" ? "USER_A" : "USER_B"}] DEBUG:');
    print('   currentUserId: $currentUserId');
    print('   current_turn_user_id: ${session.currentTurnUserId}');
    print('   currentCardIndex: $currentCardIndex');
    print('   currentCard.id: ${currentCard.id}');
    print('   answers count: ${answers.length}');
    if (currentCardAnswer != null) {
      print('   currentCardAnswer.cardId: ${currentCardAnswer.cardId}');
      print('   currentCardAnswer.answerText: ${currentCardAnswer.answerText}');
    }
    print('   isMyTurn: $isMyTurn');
    print('   hasAnswer: $hasAnswer');
    print('   isView1: $isView1');
    print('   isView2: $isView2');
    print('   isView3: $isView3');
    print('---');
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isView1
                ? [const Color(0xFFE91E63), const Color(0xFFFF6B9D)]
                : isView2
                    ? [const Color(0xFF9C27B0), const Color(0xFF673AB7)]
                    : [const Color(0xFFE91E63), const Color(0xFF9C27B0)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Close button
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => context.pop(),
                ),
              ),
              // Main card
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: _buildWhiteCard(
                    context,
                    session,
                    currentCard,
                    currentCardAnswer,
                    isView1,
                    isView2,
                    isView3,
                    currentCardIndex,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhiteCard(
    BuildContext context,
    GameSession session,
    GameCard card,
    GameCardAnswer? answer,
    bool isView1,
    bool isView2,
    bool isView3,
    int cardIndex,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Badge statut (texte seulement)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isView1
                        ? const Color(0xFFE8F5E9)
                        : isView2
                            ? const Color(0xFFFFF3E0)
                            : const Color(0xFFE1F5FE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isView1
                        ? 'Votre tour'
                        : isView2
                            ? 'En attente'
                            : 'Réponse reçue',
                    style: TextStyle(
                      color: isView1
                          ? const Color(0xFF2E7D32)
                          : isView2
                              ? const Color(0xFFE65100)
                              : const Color(0xFF01579B),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Badge carte (texte seulement)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Carte ${cardIndex + 1}/${session.cardsCount}',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Question
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Question principale (SANS emoji au-dessus)
                  Text(
                    card.question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (card.subtitle != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      card.subtitle!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Zone interactive
          Padding(
            padding: const EdgeInsets.all(24),
            child: isView1
                ? _buildAnswerZone(context, session, card)
                : isView2
                    ? _buildWaitingZone()
                    : isView3
                        ? _buildReadZone(context, session, answer!, card.id)
                        : _buildSentZone(), // VUE#4
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerZone(BuildContext context, GameSession session, GameCard card) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: TextField(
            controller: _answerController,
            maxLines: 4,
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 18,
              fontFamily: GoogleFonts.caveat().fontFamily,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: 'Écrivez votre réponse ici...',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontFamily: GoogleFonts.caveat().fontFamily,
                fontSize: 18,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _submitAnswer(context, ref, session, card),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Envoyer ma réponse',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaitingZone() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.hourglass_empty, color: Colors.orange[700], size: 48),
          const SizedBox(height: 16),
          Text(
            'Votre partenaire est en train de répondre...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.orange[900],
              fontSize: 16,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadZone(BuildContext context, GameSession session, GameCardAnswer answer, String cardId) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue[200]!, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('💬', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    'Réponse de votre partenaire :',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                answer.answerText,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 20,
                  fontFamily: GoogleFonts.caveat().fontFamily,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _markAsReadAndNext(context, ref, session, answer.id, cardId),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF01579B),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '✓ J\'ai lu · Carte suivante',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentZone() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green[700], size: 40),
          const SizedBox(height: 12),
          Text(
            'Réponse envoyée !\nEn attente de lecture par votre partenaire...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedScreen(String gameId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🎉',
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 20),
          const Text(
            'Partie terminée !',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              // Invalider avant de partir
              ref.invalidate(activeSessionForGameProvider(gameId));
              ref.invalidate(activeGamesCountProvider);
              context.go('/dashboard');
            },
            child: const Text('Retour au dashboard'),
          ),
        ],
      ),
    );
  }


  Future<void> _submitAnswer(BuildContext context, WidgetRef ref,
      GameSession session, GameCard card) async {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir une réponse')),
      );
      return;
    }

    try {
      print('📝 [DEBUG] _submitAnswer START');
      print('📝 [DEBUG] cardId: ${card.id}');
      print('📝 [DEBUG] sessionId: ${widget.sessionId}');

      final service = ref.read(gamesServiceProvider);

      // Récupérer les session_cards depuis Supabase (pas game_cards)
      final supabase = ref.read(supabaseClientProvider);
      final sessionCardsResponse = await supabase
          .from('game_session_cards')
          .select('id, card_id')
          .eq('session_id', widget.sessionId)
          .order('card_order', ascending: true);

      print('📝 [DEBUG] sessionCardsResponse: $sessionCardsResponse');

      // Trouver le session_card_id correspondant à cette carte
      final sessionCardData = (sessionCardsResponse as List).firstWhere(
        (sc) => sc['card_id'] == card.id,
        orElse: () => throw Exception('Session card not found'),
      );

      final sessionCardId = sessionCardData['id'] as String;
      print('📝 [DEBUG] sessionCardId found: $sessionCardId');

      await service.answerCard(
        sessionId: widget.sessionId,
        sessionCardId: sessionCardId,
        cardId: card.id,
        answerText: _answerController.text.trim(),
      );

      _answerController.clear();

      // INVALIDER pour que l'autre joueur voit la réponse
      ref.invalidate(sessionAnswersProvider(widget.sessionId));
      ref.invalidate(currentGameSessionProvider(widget.sessionId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Réponse envoyée !')),
      );
    } catch (e, stack) {
      print('❌ [DEBUG] _submitAnswer ERROR: $e');
      print('❌ [DEBUG] Stack: $stack');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _markAsReadAndNext(
      BuildContext context, WidgetRef ref, GameSession session, String answerId, String cardId) async {
    try {
      print('👀 [DEBUG] _markAsReadAndNext START');
      print('👀 [DEBUG] answerId: $answerId');
      print('👀 [DEBUG] cardId: $cardId');

      final service = ref.read(gamesServiceProvider);

      // D'ABORD marquer comme lu
      await service.markAnswerAsRead(answerId, 5);

      // PUIS compléter la carte (incrémente cards_completed)
      await service.completeSessionCard(widget.sessionId, cardId);

      // INVALIDER pour refresh
      ref.invalidate(currentGameSessionProvider(widget.sessionId));
      ref.invalidate(sessionAnswersProvider(widget.sessionId));
      ref.invalidate(activeSessionForGameProvider(session.gameId));

      if (!mounted) return;

      // Vérifier si la partie est finie
      final updatedSessionAsync = ref.read(currentGameSessionProvider(widget.sessionId));
      updatedSessionAsync.whenData((s) {
        if (s.status == SessionStatus.completed) {
          // Ne rien faire, l'écran se rebuild automatiquement avec _buildCompletedScreen
        }
      });
    } catch (e, stack) {
      print('❌ [DEBUG] _markAsReadAndNext ERROR: $e');
      print('❌ [DEBUG] Stack: $stack');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter la partie ?'),
        content: const Text(
            'Votre progression sera sauvegardée. Vous pourrez reprendre plus tard.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Rester'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }
}
