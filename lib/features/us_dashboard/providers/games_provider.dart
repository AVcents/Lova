import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/us_dashboard/models/game.dart';
import 'package:lova/features/us_dashboard/models/intimacy_question.dart';
import 'package:lova/features/us_dashboard/screens/games/data/intimacy_questions.dart';

/// Provider pour la bibliothèque de jeux
final gamesLibraryProvider = StateNotifierProvider<GamesLibraryNotifier, AsyncValue<List<Game>>>((ref) {
  return GamesLibraryNotifier();
});

class GamesLibraryNotifier extends StateNotifier<AsyncValue<List<Game>>> {
  GamesLibraryNotifier() : super(const AsyncValue.loading()) {
    _loadGames();
  }

  Future<void> _loadGames() async {
    try {
      // Pour le MVP, on a juste le jeu LOOVA Intimité
      final games = [
        Game(
          id: 'loova_intimacy',
          name: 'LOOVA Intimité',
          description: '53 cartes pour explorer votre intimité et créer des moments de partage authentiques',
          emoji: '💕',
          type: GameType.cardGame,
          status: GameStatus.available,
          cardCount: 53,
          duration: '15-30 min',
          tags: ['Intimité', 'Communication', 'Couple', 'Connexion'],
          timesPlayed: 0,
        ),
        // Jeux à venir (locked)
        Game(
          id: 'deep_questions',
          name: 'Questions Profondes',
          description: 'Allez au-delà du superficiel avec des questions qui créent de vraies connexions',
          emoji: '🤔',
          type: GameType.cardGame,
          status: GameStatus.comingSoon,
          cardCount: 40,
          duration: '20-40 min',
          tags: ['Émotionnel', 'Découverte', 'Profond'],
        ),
        Game(
          id: 'nostalgia',
          name: 'Souvenirs à Deux',
          description: 'Revivez vos plus beaux moments et créez de nouveaux souvenirs',
          emoji: '📸',
          type: GameType.cardGame,
          status: GameStatus.comingSoon,
          cardCount: 35,
          duration: '15-25 min',
          tags: ['Nostalgie', 'Souvenirs', 'Partage'],
        ),
        Game(
          id: 'truth_or_dare',
          name: 'Action ou Vérité +18',
          description: 'La version couple du classique, avec des défis adaptés pour deux',
          emoji: '🎲',
          type: GameType.cardGame,
          status: GameStatus.premium,
          cardCount: 60,
          duration: '20-45 min',
          tags: ['Fun', 'Audace', 'Jeu'],
        ),
        Game(
          id: 'fantasy_builder',
          name: 'Créateur de Fantasmes',
          description: 'Explorez vos désirs et co-créez des scénarios ensemble',
          emoji: '✨',
          type: GameType.roleplay,
          status: GameStatus.premium,
          cardCount: 45,
          duration: '30-60 min',
          tags: ['Fantasme', 'Créativité', 'Intimité'],
        ),
      ];

      state = AsyncValue.data(games);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Marquer un jeu comme favori
  Future<void> toggleFavorite(String gameId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedGames = currentState.map((game) {
      if (game.id == gameId) {
        return game.copyWith(isFavorite: !game.isFavorite);
      }
      return game;
    }).toList();

    state = AsyncValue.data(updatedGames);
  }

  /// Incrémenter le compteur de parties jouées
  Future<void> incrementPlayCount(String gameId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedGames = currentState.map((game) {
      if (game.id == gameId) {
        return game.copyWith(timesPlayed: game.timesPlayed + 1);
      }
      return game;
    }).toList();

    state = AsyncValue.data(updatedGames);
  }
}

/// Provider pour l'état du jeu en cours
final currentGameSessionProvider = StateNotifierProvider<GameSessionNotifier, GameSession>((ref) {
  return GameSessionNotifier();
});

class GameSession {
  final String gameId;
  final List<IntimacyQuestion> questions;
  final int currentIndex;
  final List<String> answeredQuestions;

  GameSession({
    required this.gameId,
    required this.questions,
    this.currentIndex = 0,
    this.answeredQuestions = const [],
  });

  GameSession copyWith({
    String? gameId,
    List<IntimacyQuestion>? questions,
    int? currentIndex,
    List<String>? answeredQuestions,
  }) {
    return GameSession(
      gameId: gameId ?? this.gameId,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
    );
  }

  IntimacyQuestion get currentQuestion => questions[currentIndex];
  bool get hasNext => currentIndex < questions.length - 1;
  int get progress => currentIndex + 1;
  int get total => questions.length;
}

class GameSessionNotifier extends StateNotifier<GameSession> {
  GameSessionNotifier()
      : super(GameSession(
    gameId: '',
    questions: [],
  ));

  /// Démarrer une nouvelle session
  void startGame(String gameId, {bool includeSpicy = true}) {
    final questions = includeSpicy
        ? IntimacyQuestionsData.getShuffledQuestions()
        : IntimacyQuestionsData.getMildQuestions()..shuffle();

    state = GameSession(
      gameId: gameId,
      questions: questions,
      currentIndex: 0,
      answeredQuestions: [],
    );
  }

  /// Passer à la question suivante
  void nextQuestion() {
    if (state.hasNext) {
      final currentQuestionId = state.currentQuestion.id;
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        answeredQuestions: [...state.answeredQuestions, currentQuestionId],
      );
    }
  }

  /// Question précédente
  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(
        currentIndex: state.currentIndex - 1,
      );
    }
  }

  /// Passer une question (swipe)
  void skipQuestion() {
    nextQuestion();
  }

  /// Terminer la session
  void endGame() {
    state = GameSession(
      gameId: '',
      questions: [],
    );
  }
}