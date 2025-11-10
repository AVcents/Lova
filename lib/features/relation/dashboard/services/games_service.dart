import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/relation/dashboard/models/game_card_deck.dart';
import 'package:lova/features/relation/dashboard/models/deck_progress.dart';
import 'package:lova/features/relation/dashboard/models/game_session.dart';
import 'package:lova/features/relation/dashboard/models/game_card.dart';
import 'package:lova/features/relation/dashboard/models/game_card_answer.dart';

class GamesService {
  final SupabaseClient _supabase;

  GamesService(this._supabase);

  // ═══════════════════════════════════════════════════
  // PAQUETS
  // ═══════════════════════════════════════════════════

  /// Récupère tous les paquets disponibles pour un jeu
  Future<List<GameCardDeck>> getAvailableDecks(String gameId) async {
    final response = await _supabase
        .from('game_card_decks')
        .select()
        .eq('game_id', gameId)
        .order('sort_order', ascending: true);

    return (response as List)
        .map((json) => GameCardDeck.fromJson(json))
        .toList();
  }

  /// Récupère les paquets possédés par un couple
  Future<List<String>> getOwnedDeckIds(String relationId) async {
    final response = await _supabase
        .from('relation_owned_decks')
        .select('deck_id')
        .eq('relation_id', relationId);

    return (response as List).map((row) => row['deck_id'] as String).toList();
  }

  /// Débloque un paquet gratuitement (premier paquet)
  Future<void> unlockFreeDeck(String relationId, String deckId) async {
    await _supabase.from('relation_owned_decks').insert({
      'relation_id': relationId,
      'deck_id': deckId,
      'purchase_price': 0.00,
      'payment_provider': 'free',
    });

    // Initialiser la progression
    final deck = await _getDeck(deckId);
    await _supabase.from('relation_deck_progress').insert({
      'relation_id': relationId,
      'deck_id': deckId,
      'cards_completed': 0,
      'total_cards': deck.cardCount,
      'is_completed': false,
      'is_locked': false,
      'can_replay': false,
    });
  }

  /// Récupère un paquet par son ID
  Future<GameCardDeck> _getDeck(String deckId) async {
    final response = await _supabase
        .from('game_card_decks')
        .select()
        .eq('id', deckId)
        .single();

    return GameCardDeck.fromJson(response);
  }

  /// Récupère la progression d'un paquet
  Future<DeckProgress?> getDeckProgress(
      String relationId, String deckId) async {
    try {
      final response = await _supabase
          .from('relation_deck_progress')
          .select()
          .eq('relation_id', relationId)
          .eq('deck_id', deckId)
          .maybeSingle();

      if (response == null) return null;
      return DeckProgress.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════
  // SESSIONS
  // ═══════════════════════════════════════════════════

  /// Crée une nouvelle session de jeu directement en inProgress
  Future<GameSession> createSession({
    required String relationId,
    required String gameId,
    required String deckId,
    required String inviteeId,
    required SessionType sessionType,
  }) async {
    final currentUserId = _supabase.auth.currentUser!.id;

    final cardsCount = switch (sessionType) {
      SessionType.quick => 3,
      SessionType.normal => 5,
      SessionType.long => 10,
    };

    // Créer la session directement en inProgress
    final sessionResponse = await _supabase
        .from('game_sessions')
        .insert({
          'relation_id': relationId,
          'game_id': gameId,
          'deck_id': deckId,
          'session_type': sessionType.name,
          'cards_count': cardsCount,
          'status': SessionStatus.inProgress.name,
          'created_by': currentUserId,
          'invited_user': inviteeId,
          'current_turn_user_id': currentUserId,
          'turn_number': 1,
          'cards_completed': 0,
          'started_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    final session = GameSession.fromJson(sessionResponse);

    // Distribuer les cartes immédiatement
    await _distributeCards(session.id);

    return session;
  }

  /// Distribue les cartes pour une session
  Future<void> _distributeCards(String sessionId) async {
    // Récupérer la session
    final sessionData = await _supabase
        .from('game_sessions')
        .select('relation_id, deck_id, cards_count')
        .eq('id', sessionId)
        .single();

    final relationId = sessionData['relation_id'] as String;
    final deckId = sessionData['deck_id'] as String;
    final cardsCount = sessionData['cards_count'] as int;

    // Récupérer les cartes NON jouées
    final availableCardsResponse = await _supabase.rpc(
      'get_available_cards',
      params: {
        'p_relation_id': relationId,
        'p_deck_id': deckId,
        'p_limit': cardsCount,
      },
    );

    final availableCards = (availableCardsResponse as List)
        .map((json) => GameCard.fromJson(json))
        .toList();

    if (availableCards.length < cardsCount) {
      throw Exception(
          'Pas assez de cartes disponibles (${availableCards.length}/$cardsCount)');
    }

    // Insérer les cartes dans game_session_cards
    for (var i = 0; i < cardsCount; i++) {
      await _supabase.from('game_session_cards').insert({
        'session_id': sessionId,
        'card_id': availableCards[i].id,
        'card_order': i + 1,
        'is_completed': false,
      });
    }

    // Définir le premier joueur (celui qui a créé)
    final session = await getSession(sessionId);
    await _supabase
        .from('game_sessions')
        .update({'current_turn_user_id': session.createdBy})
        .eq('id', sessionId);
  }

  /// Récupère une session
  Future<GameSession> getSession(String sessionId) async {
    final response = await _supabase
        .from('game_sessions')
        .select()
        .eq('id', sessionId)
        .single();

    return GameSession.fromJson(response);
  }

  /// Stream temps réel d'une session
  Stream<GameSession> watchSession(String sessionId) {
    return _supabase
        .from('game_sessions')
        .stream(primaryKey: ['id'])
        .eq('id', sessionId)
        .map((data) => GameSession.fromJson(data.first));
  }

  /// Récupère les cartes d'une session
  Future<List<GameCard>> getSessionCards(String sessionId) async {
    final response = await _supabase
        .from('game_session_cards')
        .select('card_id, game_cards(*)')
        .eq('session_id', sessionId)
        .order('card_order', ascending: true);

    return (response as List)
        .map((row) => GameCard.fromJson(row['game_cards']))
        .toList();
  }

  // ═══════════════════════════════════════════════════
  // TOUR PAR TOUR
  // ═══════════════════════════════════════════════════

  /// Choisit une carte (début du tour)
  Future<void> pickCard(String sessionId, String cardId) async {
    final currentUserId = _supabase.auth.currentUser!.id;

    await _supabase
        .from('game_session_cards')
        .update({
          'picked_by': currentUserId,
          'picked_at': DateTime.now().toIso8601String(),
        })
        .eq('session_id', sessionId)
        .eq('card_id', cardId);

    // Mettre à jour la session pour changer de tour
    final session = await getSession(sessionId);
    final nextPlayer = session.getOtherPlayer(currentUserId);

    await _supabase
        .from('game_sessions')
        .update({'current_turn_user_id': nextPlayer})
        .eq('id', sessionId);
  }

  /// Répond à une carte
  Future<GameCardAnswer> answerCard({
    required String sessionId,
    required String sessionCardId,
    required String cardId,
    required String answerText,
  }) async {
    final currentUserId = _supabase.auth.currentUser!.id;

    // Récupérer les infos de session
    final sessionData = await _supabase
        .from('game_sessions')
        .select('relation_id, deck_id')
        .eq('id', sessionId)
        .single();

    // Insérer la réponse
    final answerResponse = await _supabase
        .from('game_card_answers')
        .insert({
          'relation_id': sessionData['relation_id'],
          'deck_id': sessionData['deck_id'],
          'card_id': cardId,
          'session_id': sessionId,
          'session_card_id': sessionCardId,
          'answered_by': currentUserId,
          'answer_text': answerText,
        })
        .select()
        .single();

    return GameCardAnswer.fromJson(answerResponse);
  }

  /// Marque une réponse comme lue
  Future<void> markAnswerAsRead(String answerId, int readDurationSeconds) async {
    final currentUserId = _supabase.auth.currentUser!.id;

    await _supabase
        .from('game_card_answers')
        .update({
          'read_by': currentUserId,
          'read_at': DateTime.now().toIso8601String(),
          'read_duration_seconds': readDurationSeconds,
        })
        .eq('id', answerId);
  }

  /// Marque une carte de session comme complétée
  Future<void> completeSessionCard(String sessionId, String cardId) async {
    // Marquer la carte comme complétée
    await _supabase
        .from('game_session_cards')
        .update({
          'is_completed': true,
          'completed_at': DateTime.now().toIso8601String(),
        })
        .eq('session_id', sessionId)
        .eq('card_id', cardId);

    // Récupérer la session actuelle
    final sessionData = await _supabase
        .from('game_sessions')
        .select()
        .eq('id', sessionId)
        .single();

    final currentCompleted = sessionData['cards_completed'] as int;
    final totalCards = sessionData['cards_count'] as int;
    final newCompleted = currentCompleted + 1;

    // Vérifier si c'est la dernière carte
    final isLastCard = newCompleted >= totalCards;

    // Alterner current_turn_user_id
    final currentTurn = sessionData['current_turn_user_id'] as String;
    final createdBy = sessionData['created_by'] as String;
    final invitedUser = sessionData['invited_user'] as String;
    final nextTurn = currentTurn == createdBy ? invitedUser : createdBy;

    // Mettre à jour la session
    await _supabase.from('game_sessions').update({
      'cards_completed': newCompleted,
      'current_turn_user_id': isLastCard ? null : nextTurn, // Changer le tour
      'turn_number': (sessionData['turn_number'] as int) + 1,
      'status': isLastCard ? SessionStatus.completed.name : SessionStatus.inProgress.name,
      'completed_at': isLastCard ? DateTime.now().toIso8601String() : null,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', sessionId);

    // Marquer la carte comme jouée
    await _supabase.from('game_played_cards').upsert({
      'relation_id': sessionData['relation_id'],
      'deck_id': sessionData['deck_id'],
      'card_id': cardId,
      'played_at': DateTime.now().toIso8601String(),
    });

    // Si c'est la dernière carte, mettre à jour la progression du deck
    if (isLastCard) {
      await _updateDeckProgress(
        sessionData['relation_id'] as String,
        sessionData['deck_id'] as String,
      );
    }
  }

  /// Met à jour la progression d'un paquet
  Future<void> _updateDeckProgress(String relationId, String deckId) async {
    // Compter les cartes jouées
    final playedCardsResponse = await _supabase
        .from('game_played_cards')
        .select('id')
        .eq('relation_id', relationId)
        .eq('deck_id', deckId);

    final count = (playedCardsResponse as List).length;

    final deck = await _getDeck(deckId);
    final isCompleted = count >= deck.cardCount;

    await _supabase
        .from('relation_deck_progress')
        .update({
          'cards_completed': count,
          'last_played_at': DateTime.now().toIso8601String(),
          'is_completed': isCompleted,
          'is_locked': isCompleted,
          'completed_at':
              isCompleted ? DateTime.now().toIso8601String() : null,
        })
        .eq('relation_id', relationId)
        .eq('deck_id', deckId);
  }

  // ═══════════════════════════════════════════════════
  // HISTORIQUE
  // ═══════════════════════════════════════════════════

  /// Récupère l'historique des réponses d'un paquet
  Future<List<Map<String, dynamic>>> getDeckHistory(
      String relationId, String deckId) async {
    final response = await _supabase
        .from('game_card_answers')
        .select('*, game_cards(*)')
        .eq('relation_id', relationId)
        .eq('deck_id', deckId)
        .order('answered_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }
}
