import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_card.freezed.dart';
part 'game_card.g.dart';

/// Carte du jeu (depuis la BDD)
@freezed
class GameCard with _$GameCard {
  const factory GameCard({
    required String id,
    @JsonKey(name: 'deck_id') required String deckId,
    @JsonKey(name: 'card_number') required int cardNumber,
    required String question,
    required String category,
    required String format,
    @JsonKey(name: 'is_spicy') @Default(false) bool isSpicy,
    String? subtitle,
    String? tip,
    Map<String, dynamic>? choices,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _GameCard;

  factory GameCard.fromJson(Map<String, dynamic> json) =>
    _$GameCardFromJson(json);
}
