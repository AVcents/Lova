import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_card_answer.freezed.dart';
part 'game_card_answer.g.dart';

/// Réponse à une carte
@freezed
class GameCardAnswer with _$GameCardAnswer {
  const factory GameCardAnswer({
    required String id,
    @JsonKey(name: 'relation_id') required String relationId,
    @JsonKey(name: 'deck_id') required String deckId,
    @JsonKey(name: 'card_id') required String cardId,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'session_card_id') required String sessionCardId,
    @JsonKey(name: 'answered_by') required String answeredBy,
    @JsonKey(name: 'answer_text') required String answerText,
    @JsonKey(name: 'read_by') String? readBy,
    @JsonKey(name: 'read_duration_seconds') int? readDurationSeconds,
    @JsonKey(name: 'answered_at') DateTime? answeredAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _GameCardAnswer;

  factory GameCardAnswer.fromJson(Map<String, dynamic> json) =>
    _$GameCardAnswerFromJson(json);
}

extension GameCardAnswerX on GameCardAnswer {
  bool get hasBeenRead => readBy != null && readAt != null;
}
