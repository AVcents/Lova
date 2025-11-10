// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameSessionImpl _$$GameSessionImplFromJson(Map<String, dynamic> json) =>
    _$GameSessionImpl(
      id: json['id'] as String,
      relationId: json['relation_id'] as String,
      gameId: json['game_id'] as String,
      deckId: json['deck_id'] as String,
      sessionType: $enumDecode(_$SessionTypeEnumMap, json['session_type']),
      cardsCount: (json['cards_count'] as num).toInt(),
      status: $enumDecode(_$SessionStatusEnumMap, json['status']),
      createdBy: json['created_by'] as String,
      invitedUser: json['invited_user'] as String,
      currentTurnUserId: json['current_turn_user_id'] as String?,
      turnNumber: (json['turn_number'] as num?)?.toInt() ?? 1,
      cardsCompleted: (json['cards_completed'] as num?)?.toInt() ?? 0,
      sessionData: json['session_data'] as Map<String, dynamic>?,
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$GameSessionImplToJson(_$GameSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relation_id': instance.relationId,
      'game_id': instance.gameId,
      'deck_id': instance.deckId,
      'session_type': _$SessionTypeEnumMap[instance.sessionType]!,
      'cards_count': instance.cardsCount,
      'status': _$SessionStatusEnumMap[instance.status]!,
      'created_by': instance.createdBy,
      'invited_user': instance.invitedUser,
      'current_turn_user_id': instance.currentTurnUserId,
      'turn_number': instance.turnNumber,
      'cards_completed': instance.cardsCompleted,
      'session_data': instance.sessionData,
      'started_at': instance.startedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$SessionTypeEnumMap = {
  SessionType.quick: 'quick',
  SessionType.normal: 'normal',
  SessionType.long: 'long',
};

const _$SessionStatusEnumMap = {
  SessionStatus.inProgress: 'inProgress',
  SessionStatus.completed: 'completed',
};
