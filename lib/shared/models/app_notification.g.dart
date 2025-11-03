// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$AppNotificationImpl(
  id: json['id'] as String,
  relationId: json['relation_id'] as String?,
  userId: json['user_id'] as String,
  notificationType: json['notification_type'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  actionUrl: json['action_url'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  sentAt: json['sent_at'] == null
      ? null
      : DateTime.parse(json['sent_at'] as String),
  readAt: json['read_at'] == null
      ? null
      : DateTime.parse(json['read_at'] as String),
  clickedAt: json['clicked_at'] == null
      ? null
      : DateTime.parse(json['clicked_at'] as String),
  fcmMessageId: json['fcm_message_id'] as String?,
  fcmError: json['fcm_error'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  scheduledFor: json['scheduled_for'] == null
      ? null
      : DateTime.parse(json['scheduled_for'] as String),
);

Map<String, dynamic> _$$AppNotificationImplToJson(
  _$AppNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'relation_id': instance.relationId,
  'user_id': instance.userId,
  'notification_type': instance.notificationType,
  'title': instance.title,
  'body': instance.body,
  'action_url': instance.actionUrl,
  'metadata': instance.metadata,
  'sent_at': instance.sentAt?.toIso8601String(),
  'read_at': instance.readAt?.toIso8601String(),
  'clicked_at': instance.clickedAt?.toIso8601String(),
  'fcm_message_id': instance.fcmMessageId,
  'fcm_error': instance.fcmError,
  'created_at': instance.createdAt.toIso8601String(),
  'scheduled_for': instance.scheduledFor?.toIso8601String(),
};
