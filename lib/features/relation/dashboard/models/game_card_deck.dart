import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_card_deck.freezed.dart';
part 'game_card_deck.g.dart';

/// Niveau de difficulté d'un paquet
enum DeckDifficulty {
  beginner,
  intermediate,
  advanced,
  spicy,
}

/// Statut d'un paquet
enum DeckStatus {
  available,
  comingSoon,
}

/// Paquet de cartes
@freezed
class GameCardDeck with _$GameCardDeck {
  const factory GameCardDeck({
    required String id,
    @JsonKey(name: 'game_id') required String gameId,
    @JsonKey(name: 'deck_name') required String deckName,
    @JsonKey(name: 'deck_description') required String deckDescription,
    @JsonKey(name: 'deck_emoji') required String deckEmoji,
    @JsonKey(name: 'card_count') required int cardCount,
    @JsonKey(name: 'price_euros') required double priceEuros,
    @JsonKey(name: 'unlock_price_euros') required double unlockPriceEuros,
    @JsonKey(name: 'difficulty_level') required DeckDifficulty difficultyLevel,
    @JsonKey(name: 'is_free') required bool isFree,
    @JsonKey(name: 'sort_order') required int sortOrder,
    required DeckStatus status,
    @JsonKey(name: 'preview_questions') List<String>? previewQuestions,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _GameCardDeck;

  factory GameCardDeck.fromJson(Map<String, dynamic> json) =>
    _$GameCardDeckFromJson(json);
}
