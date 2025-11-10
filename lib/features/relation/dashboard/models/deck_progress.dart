import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_progress.freezed.dart';
part 'deck_progress.g.dart';

/// Progression d'un couple sur un paquet
@freezed
class DeckProgress with _$DeckProgress {
  const factory DeckProgress({
    @JsonKey(name: 'relation_id') required String relationId,
    @JsonKey(name: 'deck_id') required String deckId,
    @JsonKey(name: 'cards_completed') required int cardsCompleted,
    @JsonKey(name: 'total_cards') required int totalCards,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'is_locked') @Default(false) bool isLocked,
    @JsonKey(name: 'can_replay') @Default(false) bool canReplay,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'last_played_at') DateTime? lastPlayedAt,
  }) = _DeckProgress;

  // IMPORTANT : const factory AVANT l'extension
  const DeckProgress._();

  factory DeckProgress.fromJson(Map<String, dynamic> json) =>
    _$DeckProgressFromJson(json);

  // Extension methods
  double get completionPercentage =>
    totalCards > 0 ? (cardsCompleted / totalCards * 100) : 0;

  int get remainingCards => totalCards - cardsCompleted;
}
