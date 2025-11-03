import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @JsonKey(name: 'relation_id') String? relationId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'notification_type') required String notificationType,
    required String title,
    required String body,
    @JsonKey(name: 'action_url') String? actionUrl,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'clicked_at') DateTime? clickedAt,
    @JsonKey(name: 'fcm_message_id') String? fcmMessageId,
    @JsonKey(name: 'fcm_error') String? fcmError,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'scheduled_for') DateTime? scheduledFor,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
