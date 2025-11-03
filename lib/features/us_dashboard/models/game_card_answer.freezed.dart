// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_card_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameCardAnswer _$GameCardAnswerFromJson(Map<String, dynamic> json) {
  return _GameCardAnswer.fromJson(json);
}

/// @nodoc
mixin _$GameCardAnswer {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'relation_id')
  String get relationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'deck_id')
  String get deckId => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_id')
  String get cardId => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_card_id')
  String get sessionCardId => throw _privateConstructorUsedError;
  @JsonKey(name: 'answered_by')
  String get answeredBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'answer_text')
  String get answerText => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_by')
  String? get readBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_duration_seconds')
  int? get readDurationSeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'answered_at')
  DateTime? get answeredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_at')
  DateTime? get readAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GameCardAnswer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameCardAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameCardAnswerCopyWith<GameCardAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCardAnswerCopyWith<$Res> {
  factory $GameCardAnswerCopyWith(
    GameCardAnswer value,
    $Res Function(GameCardAnswer) then,
  ) = _$GameCardAnswerCopyWithImpl<$Res, GameCardAnswer>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'deck_id') String deckId,
    @JsonKey(name: 'card_id') String cardId,
    @JsonKey(name: 'session_id') String sessionId,
    @JsonKey(name: 'session_card_id') String sessionCardId,
    @JsonKey(name: 'answered_by') String answeredBy,
    @JsonKey(name: 'answer_text') String answerText,
    @JsonKey(name: 'read_by') String? readBy,
    @JsonKey(name: 'read_duration_seconds') int? readDurationSeconds,
    @JsonKey(name: 'answered_at') DateTime? answeredAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$GameCardAnswerCopyWithImpl<$Res, $Val extends GameCardAnswer>
    implements $GameCardAnswerCopyWith<$Res> {
  _$GameCardAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameCardAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? deckId = null,
    Object? cardId = null,
    Object? sessionId = null,
    Object? sessionCardId = null,
    Object? answeredBy = null,
    Object? answerText = null,
    Object? readBy = freezed,
    Object? readDurationSeconds = freezed,
    Object? answeredAt = freezed,
    Object? readAt = freezed,
    Object? createdAt = freezed,
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
            deckId: null == deckId
                ? _value.deckId
                : deckId // ignore: cast_nullable_to_non_nullable
                      as String,
            cardId: null == cardId
                ? _value.cardId
                : cardId // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionCardId: null == sessionCardId
                ? _value.sessionCardId
                : sessionCardId // ignore: cast_nullable_to_non_nullable
                      as String,
            answeredBy: null == answeredBy
                ? _value.answeredBy
                : answeredBy // ignore: cast_nullable_to_non_nullable
                      as String,
            answerText: null == answerText
                ? _value.answerText
                : answerText // ignore: cast_nullable_to_non_nullable
                      as String,
            readBy: freezed == readBy
                ? _value.readBy
                : readBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            readDurationSeconds: freezed == readDurationSeconds
                ? _value.readDurationSeconds
                : readDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            answeredAt: freezed == answeredAt
                ? _value.answeredAt
                : answeredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            readAt: freezed == readAt
                ? _value.readAt
                : readAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameCardAnswerImplCopyWith<$Res>
    implements $GameCardAnswerCopyWith<$Res> {
  factory _$$GameCardAnswerImplCopyWith(
    _$GameCardAnswerImpl value,
    $Res Function(_$GameCardAnswerImpl) then,
  ) = __$$GameCardAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'deck_id') String deckId,
    @JsonKey(name: 'card_id') String cardId,
    @JsonKey(name: 'session_id') String sessionId,
    @JsonKey(name: 'session_card_id') String sessionCardId,
    @JsonKey(name: 'answered_by') String answeredBy,
    @JsonKey(name: 'answer_text') String answerText,
    @JsonKey(name: 'read_by') String? readBy,
    @JsonKey(name: 'read_duration_seconds') int? readDurationSeconds,
    @JsonKey(name: 'answered_at') DateTime? answeredAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$GameCardAnswerImplCopyWithImpl<$Res>
    extends _$GameCardAnswerCopyWithImpl<$Res, _$GameCardAnswerImpl>
    implements _$$GameCardAnswerImplCopyWith<$Res> {
  __$$GameCardAnswerImplCopyWithImpl(
    _$GameCardAnswerImpl _value,
    $Res Function(_$GameCardAnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameCardAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? deckId = null,
    Object? cardId = null,
    Object? sessionId = null,
    Object? sessionCardId = null,
    Object? answeredBy = null,
    Object? answerText = null,
    Object? readBy = freezed,
    Object? readDurationSeconds = freezed,
    Object? answeredAt = freezed,
    Object? readAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$GameCardAnswerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        relationId: null == relationId
            ? _value.relationId
            : relationId // ignore: cast_nullable_to_non_nullable
                  as String,
        deckId: null == deckId
            ? _value.deckId
            : deckId // ignore: cast_nullable_to_non_nullable
                  as String,
        cardId: null == cardId
            ? _value.cardId
            : cardId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionCardId: null == sessionCardId
            ? _value.sessionCardId
            : sessionCardId // ignore: cast_nullable_to_non_nullable
                  as String,
        answeredBy: null == answeredBy
            ? _value.answeredBy
            : answeredBy // ignore: cast_nullable_to_non_nullable
                  as String,
        answerText: null == answerText
            ? _value.answerText
            : answerText // ignore: cast_nullable_to_non_nullable
                  as String,
        readBy: freezed == readBy
            ? _value.readBy
            : readBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        readDurationSeconds: freezed == readDurationSeconds
            ? _value.readDurationSeconds
            : readDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        answeredAt: freezed == answeredAt
            ? _value.answeredAt
            : answeredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        readAt: freezed == readAt
            ? _value.readAt
            : readAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameCardAnswerImpl implements _GameCardAnswer {
  const _$GameCardAnswerImpl({
    required this.id,
    @JsonKey(name: 'relation_id') required this.relationId,
    @JsonKey(name: 'deck_id') required this.deckId,
    @JsonKey(name: 'card_id') required this.cardId,
    @JsonKey(name: 'session_id') required this.sessionId,
    @JsonKey(name: 'session_card_id') required this.sessionCardId,
    @JsonKey(name: 'answered_by') required this.answeredBy,
    @JsonKey(name: 'answer_text') required this.answerText,
    @JsonKey(name: 'read_by') this.readBy,
    @JsonKey(name: 'read_duration_seconds') this.readDurationSeconds,
    @JsonKey(name: 'answered_at') this.answeredAt,
    @JsonKey(name: 'read_at') this.readAt,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$GameCardAnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameCardAnswerImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'relation_id')
  final String relationId;
  @override
  @JsonKey(name: 'deck_id')
  final String deckId;
  @override
  @JsonKey(name: 'card_id')
  final String cardId;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  @JsonKey(name: 'session_card_id')
  final String sessionCardId;
  @override
  @JsonKey(name: 'answered_by')
  final String answeredBy;
  @override
  @JsonKey(name: 'answer_text')
  final String answerText;
  @override
  @JsonKey(name: 'read_by')
  final String? readBy;
  @override
  @JsonKey(name: 'read_duration_seconds')
  final int? readDurationSeconds;
  @override
  @JsonKey(name: 'answered_at')
  final DateTime? answeredAt;
  @override
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'GameCardAnswer(id: $id, relationId: $relationId, deckId: $deckId, cardId: $cardId, sessionId: $sessionId, sessionCardId: $sessionCardId, answeredBy: $answeredBy, answerText: $answerText, readBy: $readBy, readDurationSeconds: $readDurationSeconds, answeredAt: $answeredAt, readAt: $readAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameCardAnswerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.relationId, relationId) ||
                other.relationId == relationId) &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionCardId, sessionCardId) ||
                other.sessionCardId == sessionCardId) &&
            (identical(other.answeredBy, answeredBy) ||
                other.answeredBy == answeredBy) &&
            (identical(other.answerText, answerText) ||
                other.answerText == answerText) &&
            (identical(other.readBy, readBy) || other.readBy == readBy) &&
            (identical(other.readDurationSeconds, readDurationSeconds) ||
                other.readDurationSeconds == readDurationSeconds) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    relationId,
    deckId,
    cardId,
    sessionId,
    sessionCardId,
    answeredBy,
    answerText,
    readBy,
    readDurationSeconds,
    answeredAt,
    readAt,
    createdAt,
  );

  /// Create a copy of GameCardAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameCardAnswerImplCopyWith<_$GameCardAnswerImpl> get copyWith =>
      __$$GameCardAnswerImplCopyWithImpl<_$GameCardAnswerImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GameCardAnswerImplToJson(this);
  }
}

abstract class _GameCardAnswer implements GameCardAnswer {
  const factory _GameCardAnswer({
    required final String id,
    @JsonKey(name: 'relation_id') required final String relationId,
    @JsonKey(name: 'deck_id') required final String deckId,
    @JsonKey(name: 'card_id') required final String cardId,
    @JsonKey(name: 'session_id') required final String sessionId,
    @JsonKey(name: 'session_card_id') required final String sessionCardId,
    @JsonKey(name: 'answered_by') required final String answeredBy,
    @JsonKey(name: 'answer_text') required final String answerText,
    @JsonKey(name: 'read_by') final String? readBy,
    @JsonKey(name: 'read_duration_seconds') final int? readDurationSeconds,
    @JsonKey(name: 'answered_at') final DateTime? answeredAt,
    @JsonKey(name: 'read_at') final DateTime? readAt,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$GameCardAnswerImpl;

  factory _GameCardAnswer.fromJson(Map<String, dynamic> json) =
      _$GameCardAnswerImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'relation_id')
  String get relationId;
  @override
  @JsonKey(name: 'deck_id')
  String get deckId;
  @override
  @JsonKey(name: 'card_id')
  String get cardId;
  @override
  @JsonKey(name: 'session_id')
  String get sessionId;
  @override
  @JsonKey(name: 'session_card_id')
  String get sessionCardId;
  @override
  @JsonKey(name: 'answered_by')
  String get answeredBy;
  @override
  @JsonKey(name: 'answer_text')
  String get answerText;
  @override
  @JsonKey(name: 'read_by')
  String? get readBy;
  @override
  @JsonKey(name: 'read_duration_seconds')
  int? get readDurationSeconds;
  @override
  @JsonKey(name: 'answered_at')
  DateTime? get answeredAt;
  @override
  @JsonKey(name: 'read_at')
  DateTime? get readAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of GameCardAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameCardAnswerImplCopyWith<_$GameCardAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
