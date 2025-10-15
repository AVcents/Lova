// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoupleCheckinImpl _$$CoupleCheckinImplFromJson(Map<String, dynamic> json) =>
    _$CoupleCheckinImpl(
      id: json['id'] as String,
      relationId: json['relation_id'] as String,
      userId: json['user_id'] as String,
      checkinDate: DateTime.parse(json['checkin_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      scoreConnection: (json['score_connection'] as num).toInt(),
      scoreSatisfaction: (json['score_satisfaction'] as num).toInt(),
      scoreCommunication: (json['score_communication'] as num).toInt(),
      emotion: _emotionFromJson(json['emotion'] as String),
      gratitudeText: json['gratitude_text'] as String?,
      gratitudeShared: json['gratitude_shared'] as bool?,
      concernText: json['concern_text'] as String?,
      concernShared: json['concern_shared'] as bool?,
      needText: json['need_text'] as String?,
      needShared: json['need_shared'] as bool?,
      toneDetected: json['tone_detected'] as String?,
      aiTokensUsed: (json['ai_tokens_used'] as num?)?.toInt(),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CoupleCheckinImplToJson(_$CoupleCheckinImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relation_id': instance.relationId,
      'user_id': instance.userId,
      'checkin_date': instance.checkinDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'score_connection': instance.scoreConnection,
      'score_satisfaction': instance.scoreSatisfaction,
      'score_communication': instance.scoreCommunication,
      'emotion': _emotionToJson(instance.emotion),
      'gratitude_text': instance.gratitudeText,
      'gratitude_shared': instance.gratitudeShared,
      'concern_text': instance.concernText,
      'concern_shared': instance.concernShared,
      'need_text': instance.needText,
      'need_shared': instance.needShared,
      'tone_detected': instance.toneDetected,
      'ai_tokens_used': instance.aiTokensUsed,
      'completed_at': instance.completedAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
