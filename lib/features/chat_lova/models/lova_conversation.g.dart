// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lova_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LovaConversationImpl _$$LovaConversationImplFromJson(
  Map<String, dynamic> json,
) => _$LovaConversationImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  messages: const LovaMessageListConverter().fromJson(json['messages'] as List),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$LovaConversationImplToJson(
  _$LovaConversationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'messages': const LovaMessageListConverter().toJson(instance.messages),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
