import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

/// Type de jeu
enum GameType {
  cardGame,      // Jeu de cartes
  quiz,          // Quiz
  challenge,     // Défi
  roleplay,      // Jeu de rôle
}

/// Statut du jeu
enum GameStatus {
  available,     // Disponible gratuitement
  premium,       // Nécessite un abonnement
  comingSoon,    // Bientôt disponible
  locked,        // Verrouillé
}

/// Modèle de jeu dans la bibliothèque
@freezed
class Game with _$Game {
  const factory Game({
    required String id,
    required String name,
    required String description,
    required String emoji,
    required GameType type,
    required GameStatus status,
    required int cardCount,           // Nombre de cartes/questions
    required String duration,         // Ex: "15-30 min"
    required List<String> tags,       // Ex: ["Intimité", "Couple", "Communication"]
    String? coverImage,
    @Default(false) bool isFavorite,
    @Default(0) int timesPlayed,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}