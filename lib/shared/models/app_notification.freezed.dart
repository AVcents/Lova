// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) {
  return _AppNotification.fromJson(json);
}

/// @nodoc
mixin _$AppNotification {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'relation_id')
  String? get relationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_type')
  String get notificationType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_url')
  String? get actionUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_at')
  DateTime? get sentAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_at')
  DateTime? get readAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'clicked_at')
  DateTime? get clickedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'fcm_message_id')
  String? get fcmMessageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fcm_error')
  String? get fcmError => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_for')
  DateTime? get scheduledFor => throw _privateConstructorUsedError;

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppNotificationCopyWith<AppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNotificationCopyWith<$Res> {
  factory $AppNotificationCopyWith(
    AppNotification value,
    $Res Function(AppNotification) then,
  ) = _$AppNotificationCopyWithImpl<$Res, AppNotification>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String? relationId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'notification_type') String notificationType,
    String title,
    String body,
    @JsonKey(name: 'action_url') String? actionUrl,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'clicked_at') DateTime? clickedAt,
    @JsonKey(name: 'fcm_message_id') String? fcmMessageId,
    @JsonKey(name: 'fcm_error') String? fcmError,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'scheduled_for') DateTime? scheduledFor,
  });
}

/// @nodoc
class _$AppNotificationCopyWithImpl<$Res, $Val extends AppNotification>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = freezed,
    Object? userId = null,
    Object? notificationType = null,
    Object? title = null,
    Object? body = null,
    Object? actionUrl = freezed,
    Object? metadata = freezed,
    Object? sentAt = freezed,
    Object? readAt = freezed,
    Object? clickedAt = freezed,
    Object? fcmMessageId = freezed,
    Object? fcmError = freezed,
    Object? createdAt = null,
    Object? scheduledFor = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            relationId: freezed == relationId
                ? _value.relationId
                : relationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            notificationType: null == notificationType
                ? _value.notificationType
                : notificationType // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            actionUrl: freezed == actionUrl
                ? _value.actionUrl
                : actionUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            sentAt: freezed == sentAt
                ? _value.sentAt
                : sentAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            readAt: freezed == readAt
                ? _value.readAt
                : readAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            clickedAt: freezed == clickedAt
                ? _value.clickedAt
                : clickedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            fcmMessageId: freezed == fcmMessageId
                ? _value.fcmMessageId
                : fcmMessageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            fcmError: freezed == fcmError
                ? _value.fcmError
                : fcmError // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            scheduledFor: freezed == scheduledFor
                ? _value.scheduledFor
                : scheduledFor // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppNotificationImplCopyWith<$Res>
    implements $AppNotificationCopyWith<$Res> {
  factory _$$AppNotificationImplCopyWith(
    _$AppNotificationImpl value,
    $Res Function(_$AppNotificationImpl) then,
  ) = __$$AppNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String? relationId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'notification_type') String notificationType,
    String title,
    String body,
    @JsonKey(name: 'action_url') String? actionUrl,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'clicked_at') DateTime? clickedAt,
    @JsonKey(name: 'fcm_message_id') String? fcmMessageId,
    @JsonKey(name: 'fcm_error') String? fcmError,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'scheduled_for') DateTime? scheduledFor,
  });
}

/// @nodoc
class __$$AppNotificationImplCopyWithImpl<$Res>
    extends _$AppNotificationCopyWithImpl<$Res, _$AppNotificationImpl>
    implements _$$AppNotificationImplCopyWith<$Res> {
  __$$AppNotificationImplCopyWithImpl(
    _$AppNotificationImpl _value,
    $Res Function(_$AppNotificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = freezed,
    Object? userId = null,
    Object? notificationType = null,
    Object? title = null,
    Object? body = null,
    Object? actionUrl = freezed,
    Object? metadata = freezed,
    Object? sentAt = freezed,
    Object? readAt = freezed,
    Object? clickedAt = freezed,
    Object? fcmMessageId = freezed,
    Object? fcmError = freezed,
    Object? createdAt = null,
    Object? scheduledFor = freezed,
  }) {
    return _then(
      _$AppNotificationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        relationId: freezed == relationId
            ? _value.relationId
            : relationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        notificationType: null == notificationType
            ? _value.notificationType
            : notificationType // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        actionUrl: freezed == actionUrl
            ? _value.actionUrl
            : actionUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        sentAt: freezed == sentAt
            ? _value.sentAt
            : sentAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        readAt: freezed == readAt
            ? _value.readAt
            : readAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        clickedAt: freezed == clickedAt
            ? _value.clickedAt
            : clickedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        fcmMessageId: freezed == fcmMessageId
            ? _value.fcmMessageId
            : fcmMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        fcmError: freezed == fcmError
            ? _value.fcmError
            : fcmError // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        scheduledFor: freezed == scheduledFor
            ? _value.scheduledFor
            : scheduledFor // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppNotificationImpl implements _AppNotification {
  const _$AppNotificationImpl({
    required this.id,
    @JsonKey(name: 'relation_id') this.relationId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'notification_type') required this.notificationType,
    required this.title,
    required this.body,
    @JsonKey(name: 'action_url') this.actionUrl,
    final Map<String, dynamic>? metadata,
    @JsonKey(name: 'sent_at') this.sentAt,
    @JsonKey(name: 'read_at') this.readAt,
    @JsonKey(name: 'clicked_at') this.clickedAt,
    @JsonKey(name: 'fcm_message_id') this.fcmMessageId,
    @JsonKey(name: 'fcm_error') this.fcmError,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'scheduled_for') this.scheduledFor,
  }) : _metadata = metadata;

  factory _$AppNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppNotificationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'relation_id')
  final String? relationId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'notification_type')
  final String notificationType;
  @override
  final String title;
  @override
  final String body;
  @override
  @JsonKey(name: 'action_url')
  final String? actionUrl;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'sent_at')
  final DateTime? sentAt;
  @override
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @override
  @JsonKey(name: 'clicked_at')
  final DateTime? clickedAt;
  @override
  @JsonKey(name: 'fcm_message_id')
  final String? fcmMessageId;
  @override
  @JsonKey(name: 'fcm_error')
  final String? fcmError;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'scheduled_for')
  final DateTime? scheduledFor;

  @override
  String toString() {
    return 'AppNotification(id: $id, relationId: $relationId, userId: $userId, notificationType: $notificationType, title: $title, body: $body, actionUrl: $actionUrl, metadata: $metadata, sentAt: $sentAt, readAt: $readAt, clickedAt: $clickedAt, fcmMessageId: $fcmMessageId, fcmError: $fcmError, createdAt: $createdAt, scheduledFor: $scheduledFor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.relationId, relationId) ||
                other.relationId == relationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.clickedAt, clickedAt) ||
                other.clickedAt == clickedAt) &&
            (identical(other.fcmMessageId, fcmMessageId) ||
                other.fcmMessageId == fcmMessageId) &&
            (identical(other.fcmError, fcmError) ||
                other.fcmError == fcmError) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    relationId,
    userId,
    notificationType,
    title,
    body,
    actionUrl,
    const DeepCollectionEquality().hash(_metadata),
    sentAt,
    readAt,
    clickedAt,
    fcmMessageId,
    fcmError,
    createdAt,
    scheduledFor,
  );

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      __$$AppNotificationImplCopyWithImpl<_$AppNotificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppNotificationImplToJson(this);
  }
}

abstract class _AppNotification implements AppNotification {
  const factory _AppNotification({
    required final String id,
    @JsonKey(name: 'relation_id') final String? relationId,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'notification_type') required final String notificationType,
    required final String title,
    required final String body,
    @JsonKey(name: 'action_url') final String? actionUrl,
    final Map<String, dynamic>? metadata,
    @JsonKey(name: 'sent_at') final DateTime? sentAt,
    @JsonKey(name: 'read_at') final DateTime? readAt,
    @JsonKey(name: 'clicked_at') final DateTime? clickedAt,
    @JsonKey(name: 'fcm_message_id') final String? fcmMessageId,
    @JsonKey(name: 'fcm_error') final String? fcmError,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'scheduled_for') final DateTime? scheduledFor,
  }) = _$AppNotificationImpl;

  factory _AppNotification.fromJson(Map<String, dynamic> json) =
      _$AppNotificationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'relation_id')
  String? get relationId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'notification_type')
  String get notificationType;
  @override
  String get title;
  @override
  String get body;
  @override
  @JsonKey(name: 'action_url')
  String? get actionUrl;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'sent_at')
  DateTime? get sentAt;
  @override
  @JsonKey(name: 'read_at')
  DateTime? get readAt;
  @override
  @JsonKey(name: 'clicked_at')
  DateTime? get clickedAt;
  @override
  @JsonKey(name: 'fcm_message_id')
  String? get fcmMessageId;
  @override
  @JsonKey(name: 'fcm_error')
  String? get fcmError;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'scheduled_for')
  DateTime? get scheduledFor;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
