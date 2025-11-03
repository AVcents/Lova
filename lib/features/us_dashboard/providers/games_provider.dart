import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/us_dashboard/models/game.dart';
import 'package:lova/features/us_dashboard/models/game_card_deck.dart';
import 'package:lova/features/us_dashboard/models/deck_progress.dart';
import 'package:lova/features/us_dashboard/models/game_session.dart';
import 'package:lova/features/us_dashboard/models/game_card.dart';
import 'package:lova/features/us_dashboard/models/game_card_answer.dart';
import 'package:lova/features/us_dashboard/services/games_service.dart';

// ═══════════════════════════════════════════════════
// PROVIDERS DE BASE
// ═══════════════════════════════════════════════════

/// Provider Supabase Client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider du service
final gamesServiceProvider = Provider<GamesService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GamesService(supabase);
});

/// Provider de l'ID de relation du user connecté
final currentRelationIdProvider = FutureProvider<String?>((ref) async {
  print('🔍 [DEBUG] currentRelationIdProvider - START');

  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;

  print('🔍 [DEBUG] userId: $userId');

  if (userId == null) {
    print('❌ [DEBUG] userId is NULL');
    return null;
  }

  try {
    final response = await supabase
        .from('users')
        .select('relation_id')
        .eq('id', userId)
        .maybeSingle();

    print('🔍 [DEBUG] users table response: $response');

    final relationId = response?['relation_id'] as String?;
    print('🔍 [DEBUG] relationId extracted: $relationId');

    return relationId;
  } catch (e, stack) {
    print('❌ [DEBUG] ERROR in currentRelationIdProvider: $e');
    print('❌ [DEBUG] Stack: $stack');
    rethrow;
  }
});

/// Provider de l'ID du partenaire
final partnerIdProvider = FutureProvider<String?>((ref) async {
  print('👥 [DEBUG] partnerIdProvider - START');

  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;
  print('👥 [DEBUG] current userId: $userId');

  final relationId = await ref.watch(currentRelationIdProvider.future);
  print('👥 [DEBUG] relationId: $relationId');

  if (relationId == null) {
    print('❌ [DEBUG] relationId is NULL');
    return null;
  }

  final response = await supabase
      .from('relation_members')
      .select('user_id')
      .eq('relation_id', relationId)
      .neq('user_id', userId!)
      .maybeSingle();

  print('👥 [DEBUG] partner query response: $response');

  final partnerId = response?['user_id'] as String?;
  print('👥 [DEBUG] partnerId found: $partnerId');

  return partnerId;
});

// ═══════════════════════════════════════════════════
// PROVIDERS BIBLIOTHÈQUE DE JEUX (Game = le jeu global)
// ═══════════════════════════════════════════════════

/// Liste des jeux disponibles (garde l'ancien système avec Game)
final gamesLibraryProvider = StateNotifierProvider<GamesLibraryNotifier, AsyncValue<List<Game>>>((ref) {
  return GamesLibraryNotifier();
});

class GamesLibraryNotifier extends StateNotifier<AsyncValue<List<Game>>> {
  GamesLibraryNotifier() : super(const AsyncValue.loading()) {
    _loadGames();
  }

  Future<void> _loadGames() async {
    state = const AsyncValue.loading();
    try {
      // Pour l'instant, on garde les jeux mockés comme catalogue
      // Car Game représente les types de jeux (Questions, Arcade, etc)
      final games = [
        const Game(
          id: 'loova_intimacy',
          name: 'Questions d\'Intimité',
          description: 'Explorez votre relation à travers des questions profondes',
          emoji: '💕',
          type: GameType.cardGame,
          status: GameStatus.available,
          cardCount: 53, // Total toutes packs confondus
          duration: '15-30 min',
          tags: ['Intimité', 'Communication', 'Connexion'],
        ),
        const Game(
          id: 'arcade_challenge',
          name: 'Défis Arcade',
          description: 'Amusez-vous avec des mini-jeux compétitifs',
          emoji: '🎮',
          type: GameType.challenge,
          status: GameStatus.comingSoon,
          cardCount: 0,
          duration: '10-20 min',
          tags: ['Fun', 'Compétition'],
        ),
        const Game(
          id: 'action_challenges',
          name: 'Défis Action',
          description: 'Action ou vérité revisité pour couples',
          emoji: '🔥',
          type: GameType.challenge,
          status: GameStatus.premium,
          cardCount: 0,
          duration: '20-40 min',
          tags: ['Audace', 'Piquant', 'Surprises'],
        ),
      ];
      state = AsyncValue.data(games);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void toggleFavorite(String gameId) {
    state.whenData((games) {
      final updatedGames = games.map((game) {
        if (game.id == gameId) {
          return game.copyWith(isFavorite: !game.isFavorite);
        }
        return game;
      }).toList();
      state = AsyncValue.data(updatedGames);
    });
  }

  void incrementPlayCount(String gameId) {
    state.whenData((games) {
      final updatedGames = games.map((game) {
        if (game.id == gameId) {
          return game.copyWith(timesPlayed: game.timesPlayed + 1);
        }
        return game;
      }).toList();
      state = AsyncValue.data(updatedGames);
    });
  }
}

// ═══════════════════════════════════════════════════
// PROVIDERS PAQUETS DE CARTES
// ═══════════════════════════════════════════════════

/// Liste des paquets disponibles pour un jeu
final availableDecksProvider = FutureProvider.family<List<GameCardDeck>, String>((ref, gameId) async {
  print('📦 [DEBUG] availableDecksProvider called with gameId: $gameId');

  final service = ref.watch(gamesServiceProvider);

  try {
    final decks = await service.getAvailableDecks(gameId);
    print('📦 [DEBUG] getAvailableDecks returned ${decks.length} decks');
    return decks;
  } catch (e, stack) {
    print('❌ [ERREUR COMPLÈTE] $e');
    print('❌ [STACK] $stack');
    rethrow;
  }
});

/// Paquets possédés par le couple
final ownedDecksProvider = FutureProvider<List<String>>((ref) async {
  print('📦 [DEBUG] ownedDecksProvider - START');

  try {
    final relationId = await ref.watch(currentRelationIdProvider.future);
    print('📦 [DEBUG] ownedDecksProvider - relationId: $relationId');

    if (relationId == null) {
      print('⚠️ [DEBUG] relationId is NULL, returning empty list');
      return [];
    }

    final service = ref.watch(gamesServiceProvider);
    final ownedIds = await service.getOwnedDeckIds(relationId);
    print('📦 [DEBUG] ownedDecksProvider - found ${ownedIds.length} owned decks');
    return ownedIds;
  } catch (e, stack) {
    print('❌ [DEBUG] ERROR in ownedDecksProvider: $e');
    print('❌ [DEBUG] Stack: $stack');
    rethrow;
  }
});

/// Progression d'un paquet spécifique
final deckProgressProvider = FutureProvider.family<DeckProgress?, String>((ref, deckId) async {
  final relationId = await ref.watch(currentRelationIdProvider.future);
  if (relationId == null) return null;

  final service = ref.watch(gamesServiceProvider);
  return service.getDeckProgress(relationId, deckId);
});

/// Débloquer un paquet gratuit
final unlockDeckProvider = FutureProvider.family<void, String>((ref, deckId) async {
  final relationId = await ref.watch(currentRelationIdProvider.future);
  if (relationId == null) throw Exception('Pas de relation trouvée');

  final service = ref.watch(gamesServiceProvider);
  await service.unlockFreeDeck(relationId, deckId);

  // Invalider les providers pour refresh
  ref.invalidate(ownedDecksProvider);
  ref.invalidate(deckProgressProvider(deckId));
});

// ═══════════════════════════════════════════════════
// PROVIDERS SESSIONS (TEMPS RÉEL)
// ═══════════════════════════════════════════════════

/// Session en cours (temps réel via Supabase Realtime)
final currentGameSessionProvider = StreamProvider.family<GameSession, String>((ref, sessionId) {
  final service = ref.watch(gamesServiceProvider);
  return service.watchSession(sessionId);
});

/// Sessions actives où l'user est participant
final activeSessionsProvider = StreamProvider<List<GameSession>>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return Stream.value([]);

  return supabase
      .from('game_sessions')
      .stream(primaryKey: ['id'])
      .map((data) => data
          .where((json) {
            final status = json['status'] as String?;
            final createdBy = json['created_by'] as String?;
            final invitedUser = json['invited_user'] as String?;
            return (status == 'pendingInvitation' || status == 'inProgress') &&
                   (createdBy == userId || invitedUser == userId);
          })
          .map((json) => GameSession.fromJson(json))
          .toList());
});

/// Créer une nouvelle session
final createSessionProvider = FutureProvider.autoDispose.family<GameSession, CreateSessionParams>(
  (ref, params) async {
    final relationId = await ref.watch(currentRelationIdProvider.future);
    if (relationId == null) throw Exception('Pas de relation trouvée');

    final partnerId = await ref.watch(partnerIdProvider.future);
    if (partnerId == null) throw Exception('Pas de partenaire trouvé');

    final service = ref.watch(gamesServiceProvider);
    return service.createSession(
      relationId: relationId,
      gameId: params.gameId,
      deckId: params.deckId,
      inviteeId: partnerId,
      sessionType: params.sessionType,
    );
  },
);

/// Cartes d'une session
final sessionCardsProvider = FutureProvider.family<List<GameCard>, String>((ref, sessionId) async {
  final service = ref.watch(gamesServiceProvider);
  return service.getSessionCards(sessionId);
});

/// Est-ce mon tour ?
final isMyTurnProvider = Provider.family<bool, GameSession>((ref, session) {
  final userId = ref.watch(supabaseClientProvider).auth.currentUser?.id;
  return session.currentTurnUserId == userId;
});

/// Session active pour un jeu spécifique (relation + game) - Temps réel
final activeSessionForGameProvider = StreamProvider.family<GameSession?, String>((ref, gameId) {
  final supabase = ref.watch(supabaseClientProvider);
  final relationIdAsync = ref.watch(currentRelationIdProvider);

  return relationIdAsync.when(
    data: (relationId) {
      if (relationId == null) return Stream.value(null);

      return supabase
          .from('game_sessions')
          .stream(primaryKey: ['id'])
          .map((data) {
            // Filtrer manuellement car .eq() n'est pas disponible sur stream
            final filtered = data.where((json) {
              return json['relation_id'] == relationId &&
                     json['game_id'] == gameId &&
                     json['status'] == 'inProgress';
            }).toList();

            if (filtered.isEmpty) return null;
            return GameSession.fromJson(filtered.first);
          });
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// Badge count : nombre de sessions actives pour ce couple - Temps réel
final activeGamesCountProvider = StreamProvider<int>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final relationIdAsync = ref.watch(currentRelationIdProvider);

  return relationIdAsync.when(
    data: (relationId) {
      if (relationId == null) return Stream.value(0);

      return supabase
          .from('game_sessions')
          .stream(primaryKey: ['id'])
          .map((data) {
            // Filtrer manuellement
            final filtered = data.where((json) {
              return json['relation_id'] == relationId &&
                     json['status'] == 'inProgress';
            }).toList();

            return filtered.length;
          });
    },
    loading: () => Stream.value(0),
    error: (_, __) => Stream.value(0),
  );
});

/// Réponses pour une session (temps réel)
final sessionAnswersProvider = StreamProvider.family<List<GameCardAnswer>, String>((ref, sessionId) {
  final supabase = ref.watch(supabaseClientProvider);

  return supabase
      .from('game_card_answers')
      .stream(primaryKey: ['id'])
      .eq('session_id', sessionId)
      .order('answered_at')
      .map((data) => data.map((json) => GameCardAnswer.fromJson(json)).toList());
});

// ═══════════════════════════════════════════════════
// HELPERS & MODELS
// ═══════════════════════════════════════════════════

/// Paramètres pour créer une session
class CreateSessionParams {
  final String gameId;
  final String deckId;
  final SessionType sessionType;

  CreateSessionParams({
    required this.gameId,
    required this.deckId,
    required this.sessionType,
  });
}
