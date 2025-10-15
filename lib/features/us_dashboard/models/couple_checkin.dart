import 'package:freezed_annotation/freezed_annotation.dart';
import 'emotion_type.dart';

part 'couple_checkin.freezed.dart';
part 'couple_checkin.g.dart';

@freezed
class CoupleCheckin with _$CoupleCheckin {
  const factory CoupleCheckin({
    required String id,
    @JsonKey(name: 'relation_id') required String relationId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'checkin_date') required DateTime checkinDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,

    // Scores
    @JsonKey(name: 'score_connection') required int scoreConnection,
    @JsonKey(name: 'score_satisfaction') required int scoreSatisfaction,
    @JsonKey(name: 'score_communication') required int scoreCommunication,

    // Émotion
    @JsonKey(name: 'emotion', fromJson: _emotionFromJson, toJson: _emotionToJson)
    required EmotionType emotion,

    // Textes + partage
    @JsonKey(name: 'gratitude_text') String? gratitudeText,
    @JsonKey(name: 'gratitude_shared') bool? gratitudeShared,
    @JsonKey(name: 'concern_text') String? concernText,
    @JsonKey(name: 'concern_shared') bool? concernShared,
    @JsonKey(name: 'need_text') String? needText,
    @JsonKey(name: 'need_shared') bool? needShared,

    // IA
    @JsonKey(name: 'tone_detected') String? toneDetected,
    @JsonKey(name: 'ai_tokens_used') int? aiTokensUsed,

    // Timestamps
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CoupleCheckin;

  factory CoupleCheckin.fromJson(Map<String, dynamic> json) =>
      _$CoupleCheckinFromJson(json);
}

EmotionType _emotionFromJson(String value) => EmotionType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
  orElse: () => EmotionType.neutral,
);

String _emotionToJson(EmotionType emotion) => emotion.name;