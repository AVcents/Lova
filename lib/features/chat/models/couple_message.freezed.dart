// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'couple_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoupleMessage _$CoupleMessageFromJson(Map<String, dynamic> json) {
  return _CoupleMessage.fromJson(json);
}

/// @nodoc
mixin _$CoupleMessage {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'relation_id')
  String get relationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_id')
  String? get senderId => throw _privateConstructorUsedError; // NULL si AI
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_type')
  String get messageType => throw _privateConstructorUsedError;
  @JsonKey(name: 'sos_session_id')
  String? get sosSessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_encrypted')
  bool get isEncrypted => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CoupleMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoupleMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoupleMessageCopyWith<CoupleMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoupleMessageCopyWith<$Res> {
  factory $CoupleMessageCopyWith(
    CoupleMessage value,
    $Res Function(CoupleMessage) then,
  ) = _$CoupleMessageCopyWithImpl<$Res, CoupleMessage>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'sender_id') String? senderId,
    String content,
    @JsonKey(name: 'message_type') String messageType,
    @JsonKey(name: 'sos_session_id') String? sosSessionId,
    @JsonKey(name: 'is_encrypted') bool isEncrypted,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$CoupleMessageCopyWithImpl<$Res, $Val extends CoupleMessage>
    implements $CoupleMessageCopyWith<$Res> {
  _$CoupleMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoupleMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? senderId = freezed,
    Object? content = null,
    Object? messageType = null,
    Object? sosSessionId = freezed,
    Object? isEncrypted = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            relationId: null == relationId
                ? _value.relationId
                : relationId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: freezed == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            messageType: null == messageType
                ? _value.messageType
                : messageType // ignore: cast_nullable_to_non_nullable
                      as String,
            sosSessionId: freezed == sosSessionId
                ? _value.sosSessionId
                : sosSessionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isEncrypted: null == isEncrypted
                ? _value.isEncrypted
                : isEncrypted // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoupleMessageImplCopyWith<$Res>
    implements $CoupleMessageCopyWith<$Res> {
  factory _$$CoupleMessageImplCopyWith(
    _$CoupleMessageImpl value,
    $Res Function(_$CoupleMessageImpl) then,
  ) = __$$CoupleMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'sender_id') String? senderId,
    String content,
    @JsonKey(name: 'message_type') String messageType,
    @JsonKey(name: 'sos_session_id') String? sosSessionId,
    @JsonKey(name: 'is_encrypted') bool isEncrypted,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$CoupleMessageImplCopyWithImpl<$Res>
    extends _$CoupleMessageCopyWithImpl<$Res, _$CoupleMessageImpl>
    implements _$$CoupleMessageImplCopyWith<$Res> {
  __$$CoupleMessageImplCopyWithImpl(
    _$CoupleMessageImpl _value,
    $Res Function(_$CoupleMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoupleMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? senderId = freezed,
    Object? content = null,
    Object? messageType = null,
    Object? sosSessionId = freezed,
    Object? isEncrypted = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$CoupleMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        relationId: null == relationId
            ? _value.relationId
            : relationId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: freezed == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        messageType: null == messageType
            ? _value.messageType
            : messageType // ignore: cast_nullable_to_non_nullable
                  as String,
        sosSessionId: freezed == sosSessionId
            ? _value.sosSessionId
            : sosSessionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isEncrypted: null == isEncrypted
            ? _value.isEncrypted
            : isEncrypted // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoupleMessageImpl implements _CoupleMessage {
  const _$CoupleMessageImpl({
    required this.id,
    @JsonKey(name: 'relation_id') required this.relationId,
    @JsonKey(name: 'sender_id') this.senderId,
    required this.content,
    @JsonKey(name: 'message_type') this.messageType = 'normal',
    @JsonKey(name: 'sos_session_id') this.sosSessionId,
    @JsonKey(name: 'is_encrypted') this.isEncrypted = true,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$CoupleMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoupleMessageImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'relation_id')
  final String relationId;
  @override
  @JsonKey(name: 'sender_id')
  final String? senderId;
  // NULL si AI
  @override
  final String content;
  @override
  @JsonKey(name: 'message_type')
  final String messageType;
  @override
  @JsonKey(name: 'sos_session_id')
  final String? sosSessionId;
  @override
  @JsonKey(name: 'is_encrypted')
  final bool isEncrypted;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'CoupleMessage(id: $id, relationId: $relationId, senderId: $senderId, content: $content, messageType: $messageType, sosSessionId: $sosSessionId, isEncrypted: $isEncrypted, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoupleMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.relationId, relationId) ||
                other.relationId == relationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.sosSessionId, sosSessionId) ||
                other.sosSessionId == sosSessionId) &&
            (identical(other.isEncrypted, isEncrypted) ||
                other.isEncrypted == isEncrypted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    relationId,
    senderId,
    content,
    messageType,
    sosSessionId,
    isEncrypted,
    createdAt,
  );

  /// Create a copy of CoupleMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoupleMessageImplCopyWith<_$CoupleMessageImpl> get copyWith =>
      __$$CoupleMessageImplCopyWithImpl<_$CoupleMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoupleMessageImplToJson(this);
  }
}

abstract class _CoupleMessage implements CoupleMessage {
  const factory _CoupleMessage({
    required final String id,
    @JsonKey(name: 'relation_id') required final String relationId,
    @JsonKey(name: 'sender_id') final String? senderId,
    required final String content,
    @JsonKey(name: 'message_type') final String messageType,
    @JsonKey(name: 'sos_session_id') final String? sosSessionId,
    @JsonKey(name: 'is_encrypted') final bool isEncrypted,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$CoupleMessageImpl;

  factory _CoupleMessage.fromJson(Map<String, dynamic> json) =
      _$CoupleMessageImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'relation_id')
  String get relationId;
  @override
  @JsonKey(name: 'sender_id')
  String? get senderId; // NULL si AI
  @override
  String get content;
  @override
  @JsonKey(name: 'message_type')
  String get messageType;
  @override
  @JsonKey(name: 'sos_session_id')
  String? get sosSessionId;
  @override
  @JsonKey(name: 'is_encrypted')
  bool get isEncrypted;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of CoupleMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoupleMessageImplCopyWith<_$CoupleMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
