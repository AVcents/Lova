// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoupleMessageImpl _$$CoupleMessageImplFromJson(Map<String, dynamic> json) =>
    _$CoupleMessageImpl(
      id: json['id'] as String,
      relationId: json['relation_id'] as String,
      senderId: json['sender_id'] as String?,
      content: json['content'] as String,
      messageType: json['message_type'] as String? ?? 'normal',
      sosSessionId: json['sos_session_id'] as String?,
      isEncrypted: json['is_encrypted'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$CoupleMessageImplToJson(_$CoupleMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relation_id': instance.relationId,
      'sender_id': instance.senderId,
      'content': instance.content,
      'message_type': instance.messageType,
      'sos_session_id': instance.sosSessionId,
      'is_encrypted': instance.isEncrypted,
      'created_at': instance.createdAt.toIso8601String(),
    };
