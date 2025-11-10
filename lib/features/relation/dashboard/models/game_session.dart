import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_session.freezed.dart';
part 'game_session.g.dart';

enum SessionType {
  quick,   // 3 cartes
  normal,  // 5 cartes
  long,    // 10 cartes
}

enum SessionStatus {
  inProgress,
  completed,
}

@freezed
class GameSession with _$GameSession {
  const factory GameSession({
    required String id,
    @JsonKey(name: 'relation_id') required String relationId,
    @JsonKey(name: 'game_id') required String gameId,
    @JsonKey(name: 'deck_id') required String deckId,
    @JsonKey(name: 'session_type') required SessionType sessionType,
    @JsonKey(name: 'cards_count') required int cardsCount,
    required SessionStatus status,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'invited_user') required String invitedUser,
    @JsonKey(name: 'current_turn_user_id') String? currentTurnUserId,
    @JsonKey(name: 'turn_number') @Default(1) int turnNumber,
    @JsonKey(name: 'cards_completed') @Default(0) int cardsCompleted,
    @JsonKey(name: 'session_data') Map<String, dynamic>? sessionData,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _GameSession;

  const GameSession._();

  factory GameSession.fromJson(Map<String, dynamic> json) =>
      _$GameSessionFromJson(json);

  bool get isActive => status == SessionStatus.inProgress;
  bool get isFinished => status == SessionStatus.completed;
  bool isPlayerTurn(String userId) => currentTurnUserId == userId;
  String getOtherPlayer(String currentUserId) =>
      currentUserId == createdBy ? invitedUser : createdBy;
}
