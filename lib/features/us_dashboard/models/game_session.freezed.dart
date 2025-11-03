// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameSession _$GameSessionFromJson(Map<String, dynamic> json) {
  return _GameSession.fromJson(json);
}

/// @nodoc
mixin _$GameSession {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'relation_id')
  String get relationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'game_id')
  String get gameId => throw _privateConstructorUsedError;
  @JsonKey(name: 'deck_id')
  String get deckId => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_type')
  SessionType get sessionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'cards_count')
  int get cardsCount => throw _privateConstructorUsedError;
  SessionStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'invited_user')
  String get invitedUser => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_turn_user_id')
  String? get currentTurnUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'turn_number')
  int get turnNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'cards_completed')
  int get cardsCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_data')
  Map<String, dynamic>? get sessionData => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GameSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSessionCopyWith<GameSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSessionCopyWith<$Res> {
  factory $GameSessionCopyWith(
    GameSession value,
    $Res Function(GameSession) then,
  ) = _$GameSessionCopyWithImpl<$Res, GameSession>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'game_id') String gameId,
    @JsonKey(name: 'deck_id') String deckId,
    @JsonKey(name: 'session_type') SessionType sessionType,
    @JsonKey(name: 'cards_count') int cardsCount,
    SessionStatus status,
    @JsonKey(name: 'created_by') String createdBy,
    @JsonKey(name: 'invited_user') String invitedUser,
    @JsonKey(name: 'current_turn_user_id') String? currentTurnUserId,
    @JsonKey(name: 'turn_number') int turnNumber,
    @JsonKey(name: 'cards_completed') int cardsCompleted,
    @JsonKey(name: 'session_data') Map<String, dynamic>? sessionData,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$GameSessionCopyWithImpl<$Res, $Val extends GameSession>
    implements $GameSessionCopyWith<$Res> {
  _$GameSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? gameId = null,
    Object? deckId = null,
    Object? sessionType = null,
    Object? cardsCount = null,
    Object? status = null,
    Object? createdBy = null,
    Object? invitedUser = null,
    Object? currentTurnUserId = freezed,
    Object? turnNumber = null,
    Object? cardsCompleted = null,
    Object? sessionData = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            gameId: null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                      as String,
            deckId: null == deckId
                ? _value.deckId
                : deckId // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionType: null == sessionType
                ? _value.sessionType
                : sessionType // ignore: cast_nullable_to_non_nullable
                      as SessionType,
            cardsCount: null == cardsCount
                ? _value.cardsCount
                : cardsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SessionStatus,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            invitedUser: null == invitedUser
                ? _value.invitedUser
                : invitedUser // ignore: cast_nullable_to_non_nullable
                      as String,
            currentTurnUserId: freezed == currentTurnUserId
                ? _value.currentTurnUserId
                : currentTurnUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            turnNumber: null == turnNumber
                ? _value.turnNumber
                : turnNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            cardsCompleted: null == cardsCompleted
                ? _value.cardsCompleted
                : cardsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionData: freezed == sessionData
                ? _value.sessionData
                : sessionData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameSessionImplCopyWith<$Res>
    implements $GameSessionCopyWith<$Res> {
  factory _$$GameSessionImplCopyWith(
    _$GameSessionImpl value,
    $Res Function(_$GameSessionImpl) then,
  ) = __$$GameSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'game_id') String gameId,
    @JsonKey(name: 'deck_id') String deckId,
    @JsonKey(name: 'session_type') SessionType sessionType,
    @JsonKey(name: 'cards_count') int cardsCount,
    SessionStatus status,
    @JsonKey(name: 'created_by') String createdBy,
    @JsonKey(name: 'invited_user') String invitedUser,
    @JsonKey(name: 'current_turn_user_id') String? currentTurnUserId,
    @JsonKey(name: 'turn_number') int turnNumber,
    @JsonKey(name: 'cards_completed') int cardsCompleted,
    @JsonKey(name: 'session_data') Map<String, dynamic>? sessionData,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$GameSessionImplCopyWithImpl<$Res>
    extends _$GameSessionCopyWithImpl<$Res, _$GameSessionImpl>
    implements _$$GameSessionImplCopyWith<$Res> {
  __$$GameSessionImplCopyWithImpl(
    _$GameSessionImpl _value,
    $Res Function(_$GameSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? gameId = null,
    Object? deckId = null,
    Object? sessionType = null,
    Object? cardsCount = null,
    Object? status = null,
    Object? createdBy = null,
    Object? invitedUser = null,
    Object? currentTurnUserId = freezed,
    Object? turnNumber = null,
    Object? cardsCompleted = null,
    Object? sessionData = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$GameSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        relationId: null == relationId
            ? _value.relationId
            : relationId // ignore: cast_nullable_to_non_nullable
                  as String,
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        deckId: null == deckId
            ? _value.deckId
            : deckId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionType: null == sessionType
            ? _value.sessionType
            : sessionType // ignore: cast_nullable_to_non_nullable
                  as SessionType,
        cardsCount: null == cardsCount
            ? _value.cardsCount
            : cardsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SessionStatus,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        invitedUser: null == invitedUser
            ? _value.invitedUser
            : invitedUser // ignore: cast_nullable_to_non_nullable
                  as String,
        currentTurnUserId: freezed == currentTurnUserId
            ? _value.currentTurnUserId
            : currentTurnUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        turnNumber: null == turnNumber
            ? _value.turnNumber
            : turnNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        cardsCompleted: null == cardsCompleted
            ? _value.cardsCompleted
            : cardsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionData: freezed == sessionData
            ? _value._sessionData
            : sessionData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameSessionImpl extends _GameSession {
  const _$GameSessionImpl({
    required this.id,
    @JsonKey(name: 'relation_id') required this.relationId,
    @JsonKey(name: 'game_id') required this.gameId,
    @JsonKey(name: 'deck_id') required this.deckId,
    @JsonKey(name: 'session_type') required this.sessionType,
    @JsonKey(name: 'cards_count') required this.cardsCount,
    required this.status,
    @JsonKey(name: 'created_by') required this.createdBy,
    @JsonKey(name: 'invited_user') required this.invitedUser,
    @JsonKey(name: 'current_turn_user_id') this.currentTurnUserId,
    @JsonKey(name: 'turn_number') this.turnNumber = 1,
    @JsonKey(name: 'cards_completed') this.cardsCompleted = 0,
    @JsonKey(name: 'session_data') final Map<String, dynamic>? sessionData,
    @JsonKey(name: 'started_at') this.startedAt,
    @JsonKey(name: 'completed_at') this.completedAt,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _sessionData = sessionData,
       super._();

  factory _$GameSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameSessionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'relation_id')
  final String relationId;
  @override
  @JsonKey(name: 'game_id')
  final String gameId;
  @override
  @JsonKey(name: 'deck_id')
  final String deckId;
  @override
  @JsonKey(name: 'session_type')
  final SessionType sessionType;
  @override
  @JsonKey(name: 'cards_count')
  final int cardsCount;
  @override
  final SessionStatus status;
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;
  @override
  @JsonKey(name: 'invited_user')
  final String invitedUser;
  @override
  @JsonKey(name: 'current_turn_user_id')
  final String? currentTurnUserId;
  @override
  @JsonKey(name: 'turn_number')
  final int turnNumber;
  @override
  @JsonKey(name: 'cards_completed')
  final int cardsCompleted;
  final Map<String, dynamic>? _sessionData;
  @override
  @JsonKey(name: 'session_data')
  Map<String, dynamic>? get sessionData {
    final value = _sessionData;
    if (value == null) return null;
    if (_sessionData is EqualUnmodifiableMapView) return _sessionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'started_at')
  final DateTime? startedAt;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'GameSession(id: $id, relationId: $relationId, gameId: $gameId, deckId: $deckId, sessionType: $sessionType, cardsCount: $cardsCount, status: $status, createdBy: $createdBy, invitedUser: $invitedUser, currentTurnUserId: $currentTurnUserId, turnNumber: $turnNumber, cardsCompleted: $cardsCompleted, sessionData: $sessionData, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.relationId, relationId) ||
                other.relationId == relationId) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.cardsCount, cardsCount) ||
                other.cardsCount == cardsCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.invitedUser, invitedUser) ||
                other.invitedUser == invitedUser) &&
            (identical(other.currentTurnUserId, currentTurnUserId) ||
                other.currentTurnUserId == currentTurnUserId) &&
            (identical(other.turnNumber, turnNumber) ||
                other.turnNumber == turnNumber) &&
            (identical(other.cardsCompleted, cardsCompleted) ||
                other.cardsCompleted == cardsCompleted) &&
            const DeepCollectionEquality().equals(
              other._sessionData,
              _sessionData,
            ) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    relationId,
    gameId,
    deckId,
    sessionType,
    cardsCount,
    status,
    createdBy,
    invitedUser,
    currentTurnUserId,
    turnNumber,
    cardsCompleted,
    const DeepCollectionEquality().hash(_sessionData),
    startedAt,
    completedAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of GameSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSessionImplCopyWith<_$GameSessionImpl> get copyWith =>
      __$$GameSessionImplCopyWithImpl<_$GameSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameSessionImplToJson(this);
  }
}

abstract class _GameSession extends GameSession {
  const factory _GameSession({
    required final String id,
    @JsonKey(name: 'relation_id') required final String relationId,
    @JsonKey(name: 'game_id') required final String gameId,
    @JsonKey(name: 'deck_id') required final String deckId,
    @JsonKey(name: 'session_type') required final SessionType sessionType,
    @JsonKey(name: 'cards_count') required final int cardsCount,
    required final SessionStatus status,
    @JsonKey(name: 'created_by') required final String createdBy,
    @JsonKey(name: 'invited_user') required final String invitedUser,
    @JsonKey(name: 'current_turn_user_id') final String? currentTurnUserId,
    @JsonKey(name: 'turn_number') final int turnNumber,
    @JsonKey(name: 'cards_completed') final int cardsCompleted,
    @JsonKey(name: 'session_data') final Map<String, dynamic>? sessionData,
    @JsonKey(name: 'started_at') final DateTime? startedAt,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$GameSessionImpl;
  const _GameSession._() : super._();

  factory _GameSession.fromJson(Map<String, dynamic> json) =
      _$GameSessionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'relation_id')
  String get relationId;
  @override
  @JsonKey(name: 'game_id')
  String get gameId;
  @override
  @JsonKey(name: 'deck_id')
  String get deckId;
  @override
  @JsonKey(name: 'session_type')
  SessionType get sessionType;
  @override
  @JsonKey(name: 'cards_count')
  int get cardsCount;
  @override
  SessionStatus get status;
  @override
  @JsonKey(name: 'created_by')
  String get createdBy;
  @override
  @JsonKey(name: 'invited_user')
  String get invitedUser;
  @override
  @JsonKey(name: 'current_turn_user_id')
  String? get currentTurnUserId;
  @override
  @JsonKey(name: 'turn_number')
  int get turnNumber;
  @override
  @JsonKey(name: 'cards_completed')
  int get cardsCompleted;
  @override
  @JsonKey(name: 'session_data')
  Map<String, dynamic>? get sessionData;
  @override
  @JsonKey(name: 'started_at')
  DateTime? get startedAt;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of GameSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSessionImplCopyWith<_$GameSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
