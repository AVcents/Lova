// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_card_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameCardAnswerImpl _$$GameCardAnswerImplFromJson(Map<String, dynamic> json) =>
    _$GameCardAnswerImpl(
      id: json['id'] as String,
      relationId: json['relation_id'] as String,
      deckId: json['deck_id'] as String,
      cardId: json['card_id'] as String,
      sessionId: json['session_id'] as String,
      sessionCardId: json['session_card_id'] as String,
      answeredBy: json['answered_by'] as String,
      answerText: json['answer_text'] as String,
      readBy: json['read_by'] as String?,
      readDurationSeconds: (json['read_duration_seconds'] as num?)?.toInt(),
      answeredAt: json['answered_at'] == null
          ? null
          : DateTime.parse(json['answered_at'] as String),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$GameCardAnswerImplToJson(
  _$GameCardAnswerImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'relation_id': instance.relationId,
  'deck_id': instance.deckId,
  'card_id': instance.cardId,
  'session_id': instance.sessionId,
  'session_card_id': instance.sessionCardId,
  'answered_by': instance.answeredBy,
  'answer_text': instance.answerText,
  'read_by': instance.readBy,
  'read_duration_seconds': instance.readDurationSeconds,
  'answered_at': instance.answeredAt?.toIso8601String(),
  'read_at': instance.readAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
};
