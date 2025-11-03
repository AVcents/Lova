import 'package:freezed_annotation/freezed_annotation.dart';

part 'sos_session.freezed.dart';
part 'sos_session.g.dart';

@freezed
class SosSession with _$SosSession {
  const factory SosSession({
    required String id,
    @JsonKey(name: 'relation_id') required String relationId,
    @JsonKey(name: 'initiated_by') required String initiatedBy,
    required SosStatus status,
    @JsonKey(name: 'initial_emotion') required String initialEmotion,
    @JsonKey(name: 'initial_description') required String initialDescription,
    @JsonKey(name: 'intensity_level') required int intensityLevel,
    @JsonKey(name: 'conflict_topic') String? conflictTopic,
    @JsonKey(name: 'resolution_summary') String? resolutionSummary,
    @JsonKey(name: 'resolution_rating') int? resolutionRating,
    @JsonKey(name: 'total_messages') required int totalMessages,
    @JsonKey(name: 'ai_responses') required int aiResponses,
    @JsonKey(name: 'max_turns_reached') required bool maxTurnsReached,
    @JsonKey(name: 'total_ai_tokens') required int totalAiTokens,
    @JsonKey(name: 'current_phase') @Default('welcome') String currentPhase,
    @JsonKey(name: 'current_speaker') String? currentSpeaker,
    @JsonKey(name: 'turn_count') @Default(0) int turnCount,
    @JsonKey(name: 'partner_joined') @Default(false) bool partnerJoined,
    @JsonKey(name: 'partner_user_id') String? partnerUserId,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SosSession;

  factory SosSession.fromJson(Map<String, dynamic> json) => _$SosSessionFromJson(json);
}

@freezed
class SosEvent with _$SosEvent {
  const factory SosEvent({
    required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'event_type') required String eventType,
    @JsonKey(name: 'user_id') String? userId,
    String? content,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'ai_tokens_used') int? aiTokensUsed,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _SosEvent;

  factory SosEvent.fromJson(Map<String, dynamic> json) => _$SosEventFromJson(json);
}

enum SosStatus {
  @JsonValue('active') active,
  @JsonValue('resolved') resolved,
  @JsonValue('abandoned') abandoned,
  @JsonValue('escalated') escalated,
}

extension SosStatusX on SosStatus {
  String get label => switch (this) {
    SosStatus.active => 'En cours',
    SosStatus.resolved => 'Résolue',
    SosStatus.abandoned => 'Abandonnée',
    SosStatus.escalated => 'Orientée vers pro',
  };
}
