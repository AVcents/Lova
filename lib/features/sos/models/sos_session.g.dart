// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SosSessionImpl _$$SosSessionImplFromJson(Map<String, dynamic> json) =>
    _$SosSessionImpl(
      id: json['id'] as String,
      relationId: json['relation_id'] as String,
      initiatedBy: json['initiated_by'] as String,
      status: $enumDecode(_$SosStatusEnumMap, json['status']),
      initialEmotion: json['initial_emotion'] as String,
      initialDescription: json['initial_description'] as String,
      intensityLevel: (json['intensity_level'] as num).toInt(),
      conflictTopic: json['conflict_topic'] as String?,
      resolutionSummary: json['resolution_summary'] as String?,
      resolutionRating: (json['resolution_rating'] as num?)?.toInt(),
      totalMessages: (json['total_messages'] as num).toInt(),
      aiResponses: (json['ai_responses'] as num).toInt(),
      maxTurnsReached: json['max_turns_reached'] as bool,
      totalAiTokens: (json['total_ai_tokens'] as num).toInt(),
      currentPhase: json['current_phase'] as String? ?? 'welcome',
      currentSpeaker: json['current_speaker'] as String?,
      turnCount: (json['turn_count'] as num?)?.toInt() ?? 0,
      partnerJoined: json['partner_joined'] as bool? ?? false,
      partnerUserId: json['partner_user_id'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SosSessionImplToJson(_$SosSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relation_id': instance.relationId,
      'initiated_by': instance.initiatedBy,
      'status': _$SosStatusEnumMap[instance.status]!,
      'initial_emotion': instance.initialEmotion,
      'initial_description': instance.initialDescription,
      'intensity_level': instance.intensityLevel,
      'conflict_topic': instance.conflictTopic,
      'resolution_summary': instance.resolutionSummary,
      'resolution_rating': instance.resolutionRating,
      'total_messages': instance.totalMessages,
      'ai_responses': instance.aiResponses,
      'max_turns_reached': instance.maxTurnsReached,
      'total_ai_tokens': instance.totalAiTokens,
      'current_phase': instance.currentPhase,
      'current_speaker': instance.currentSpeaker,
      'turn_count': instance.turnCount,
      'partner_joined': instance.partnerJoined,
      'partner_user_id': instance.partnerUserId,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$SosStatusEnumMap = {
  SosStatus.active: 'active',
  SosStatus.resolved: 'resolved',
  SosStatus.abandoned: 'abandoned',
  SosStatus.escalated: 'escalated',
};

_$SosEventImpl _$$SosEventImplFromJson(Map<String, dynamic> json) =>
    _$SosEventImpl(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      eventType: json['event_type'] as String,
      userId: json['user_id'] as String?,
      content: json['content'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      aiTokensUsed: (json['ai_tokens_used'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$SosEventImplToJson(_$SosEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'event_type': instance.eventType,
      'user_id': instance.userId,
      'content': instance.content,
      'metadata': instance.metadata,
      'ai_tokens_used': instance.aiTokensUsed,
      'created_at': instance.createdAt.toIso8601String(),
    };
