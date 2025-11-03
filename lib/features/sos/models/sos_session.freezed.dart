// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sos_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SosSession _$SosSessionFromJson(Map<String, dynamic> json) {
  return _SosSession.fromJson(json);
}

/// @nodoc
mixin _$SosSession {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'relation_id')
  String get relationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'initiated_by')
  String get initiatedBy => throw _privateConstructorUsedError;
  SosStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'initial_emotion')
  String get initialEmotion => throw _privateConstructorUsedError;
  @JsonKey(name: 'initial_description')
  String get initialDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'intensity_level')
  int get intensityLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'conflict_topic')
  String? get conflictTopic => throw _privateConstructorUsedError;
  @JsonKey(name: 'resolution_summary')
  String? get resolutionSummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'resolution_rating')
  int? get resolutionRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_messages')
  int get totalMessages => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_responses')
  int get aiResponses => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_turns_reached')
  bool get maxTurnsReached => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_ai_tokens')
  int get totalAiTokens => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_phase')
  String get currentPhase => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_speaker')
  String? get currentSpeaker => throw _privateConstructorUsedError;
  @JsonKey(name: 'turn_count')
  int get turnCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'partner_joined')
  bool get partnerJoined => throw _privateConstructorUsedError;
  @JsonKey(name: 'partner_user_id')
  String? get partnerUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SosSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SosSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SosSessionCopyWith<SosSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SosSessionCopyWith<$Res> {
  factory $SosSessionCopyWith(
    SosSession value,
    $Res Function(SosSession) then,
  ) = _$SosSessionCopyWithImpl<$Res, SosSession>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'initiated_by') String initiatedBy,
    SosStatus status,
    @JsonKey(name: 'initial_emotion') String initialEmotion,
    @JsonKey(name: 'initial_description') String initialDescription,
    @JsonKey(name: 'intensity_level') int intensityLevel,
    @JsonKey(name: 'conflict_topic') String? conflictTopic,
    @JsonKey(name: 'resolution_summary') String? resolutionSummary,
    @JsonKey(name: 'resolution_rating') int? resolutionRating,
    @JsonKey(name: 'total_messages') int totalMessages,
    @JsonKey(name: 'ai_responses') int aiResponses,
    @JsonKey(name: 'max_turns_reached') bool maxTurnsReached,
    @JsonKey(name: 'total_ai_tokens') int totalAiTokens,
    @JsonKey(name: 'current_phase') String currentPhase,
    @JsonKey(name: 'current_speaker') String? currentSpeaker,
    @JsonKey(name: 'turn_count') int turnCount,
    @JsonKey(name: 'partner_joined') bool partnerJoined,
    @JsonKey(name: 'partner_user_id') String? partnerUserId,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$SosSessionCopyWithImpl<$Res, $Val extends SosSession>
    implements $SosSessionCopyWith<$Res> {
  _$SosSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SosSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? initiatedBy = null,
    Object? status = null,
    Object? initialEmotion = null,
    Object? initialDescription = null,
    Object? intensityLevel = null,
    Object? conflictTopic = freezed,
    Object? resolutionSummary = freezed,
    Object? resolutionRating = freezed,
    Object? totalMessages = null,
    Object? aiResponses = null,
    Object? maxTurnsReached = null,
    Object? totalAiTokens = null,
    Object? currentPhase = null,
    Object? currentSpeaker = freezed,
    Object? turnCount = null,
    Object? partnerJoined = null,
    Object? partnerUserId = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            initiatedBy: null == initiatedBy
                ? _value.initiatedBy
                : initiatedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SosStatus,
            initialEmotion: null == initialEmotion
                ? _value.initialEmotion
                : initialEmotion // ignore: cast_nullable_to_non_nullable
                      as String,
            initialDescription: null == initialDescription
                ? _value.initialDescription
                : initialDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            intensityLevel: null == intensityLevel
                ? _value.intensityLevel
                : intensityLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            conflictTopic: freezed == conflictTopic
                ? _value.conflictTopic
                : conflictTopic // ignore: cast_nullable_to_non_nullable
                      as String?,
            resolutionSummary: freezed == resolutionSummary
                ? _value.resolutionSummary
                : resolutionSummary // ignore: cast_nullable_to_non_nullable
                      as String?,
            resolutionRating: freezed == resolutionRating
                ? _value.resolutionRating
                : resolutionRating // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalMessages: null == totalMessages
                ? _value.totalMessages
                : totalMessages // ignore: cast_nullable_to_non_nullable
                      as int,
            aiResponses: null == aiResponses
                ? _value.aiResponses
                : aiResponses // ignore: cast_nullable_to_non_nullable
                      as int,
            maxTurnsReached: null == maxTurnsReached
                ? _value.maxTurnsReached
                : maxTurnsReached // ignore: cast_nullable_to_non_nullable
                      as bool,
            totalAiTokens: null == totalAiTokens
                ? _value.totalAiTokens
                : totalAiTokens // ignore: cast_nullable_to_non_nullable
                      as int,
            currentPhase: null == currentPhase
                ? _value.currentPhase
                : currentPhase // ignore: cast_nullable_to_non_nullable
                      as String,
            currentSpeaker: freezed == currentSpeaker
                ? _value.currentSpeaker
                : currentSpeaker // ignore: cast_nullable_to_non_nullable
                      as String?,
            turnCount: null == turnCount
                ? _value.turnCount
                : turnCount // ignore: cast_nullable_to_non_nullable
                      as int,
            partnerJoined: null == partnerJoined
                ? _value.partnerJoined
                : partnerJoined // ignore: cast_nullable_to_non_nullable
                      as bool,
            partnerUserId: freezed == partnerUserId
                ? _value.partnerUserId
                : partnerUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SosSessionImplCopyWith<$Res>
    implements $SosSessionCopyWith<$Res> {
  factory _$$SosSessionImplCopyWith(
    _$SosSessionImpl value,
    $Res Function(_$SosSessionImpl) then,
  ) = __$$SosSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'initiated_by') String initiatedBy,
    SosStatus status,
    @JsonKey(name: 'initial_emotion') String initialEmotion,
    @JsonKey(name: 'initial_description') String initialDescription,
    @JsonKey(name: 'intensity_level') int intensityLevel,
    @JsonKey(name: 'conflict_topic') String? conflictTopic,
    @JsonKey(name: 'resolution_summary') String? resolutionSummary,
    @JsonKey(name: 'resolution_rating') int? resolutionRating,
    @JsonKey(name: 'total_messages') int totalMessages,
    @JsonKey(name: 'ai_responses') int aiResponses,
    @JsonKey(name: 'max_turns_reached') bool maxTurnsReached,
    @JsonKey(name: 'total_ai_tokens') int totalAiTokens,
    @JsonKey(name: 'current_phase') String currentPhase,
    @JsonKey(name: 'current_speaker') String? currentSpeaker,
    @JsonKey(name: 'turn_count') int turnCount,
    @JsonKey(name: 'partner_joined') bool partnerJoined,
    @JsonKey(name: 'partner_user_id') String? partnerUserId,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$SosSessionImplCopyWithImpl<$Res>
    extends _$SosSessionCopyWithImpl<$Res, _$SosSessionImpl>
    implements _$$SosSessionImplCopyWith<$Res> {
  __$$SosSessionImplCopyWithImpl(
    _$SosSessionImpl _value,
    $Res Function(_$SosSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SosSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? initiatedBy = null,
    Object? status = null,
    Object? initialEmotion = null,
    Object? initialDescription = null,
    Object? intensityLevel = null,
    Object? conflictTopic = freezed,
    Object? resolutionSummary = freezed,
    Object? resolutionRating = freezed,
    Object? totalMessages = null,
    Object? aiResponses = null,
    Object? maxTurnsReached = null,
    Object? totalAiTokens = null,
    Object? currentPhase = null,
    Object? currentSpeaker = freezed,
    Object? turnCount = null,
    Object? partnerJoined = null,
    Object? partnerUserId = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SosSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        relationId: null == relationId
            ? _value.relationId
            : relationId // ignore: cast_nullable_to_non_nullable
                  as String,
        initiatedBy: null == initiatedBy
            ? _value.initiatedBy
            : initiatedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SosStatus,
        initialEmotion: null == initialEmotion
            ? _value.initialEmotion
            : initialEmotion // ignore: cast_nullable_to_non_nullable
                  as String,
        initialDescription: null == initialDescription
            ? _value.initialDescription
            : initialDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        intensityLevel: null == intensityLevel
            ? _value.intensityLevel
            : intensityLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        conflictTopic: freezed == conflictTopic
            ? _value.conflictTopic
            : conflictTopic // ignore: cast_nullable_to_non_nullable
                  as String?,
        resolutionSummary: freezed == resolutionSummary
            ? _value.resolutionSummary
            : resolutionSummary // ignore: cast_nullable_to_non_nullable
                  as String?,
        resolutionRating: freezed == resolutionRating
            ? _value.resolutionRating
            : resolutionRating // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalMessages: null == totalMessages
            ? _value.totalMessages
            : totalMessages // ignore: cast_nullable_to_non_nullable
                  as int,
        aiResponses: null == aiResponses
            ? _value.aiResponses
            : aiResponses // ignore: cast_nullable_to_non_nullable
                  as int,
        maxTurnsReached: null == maxTurnsReached
            ? _value.maxTurnsReached
            : maxTurnsReached // ignore: cast_nullable_to_non_nullable
                  as bool,
        totalAiTokens: null == totalAiTokens
            ? _value.totalAiTokens
            : totalAiTokens // ignore: cast_nullable_to_non_nullable
                  as int,
        currentPhase: null == currentPhase
            ? _value.currentPhase
            : currentPhase // ignore: cast_nullable_to_non_nullable
                  as String,
        currentSpeaker: freezed == currentSpeaker
            ? _value.currentSpeaker
            : currentSpeaker // ignore: cast_nullable_to_non_nullable
                  as String?,
        turnCount: null == turnCount
            ? _value.turnCount
            : turnCount // ignore: cast_nullable_to_non_nullable
                  as int,
        partnerJoined: null == partnerJoined
            ? _value.partnerJoined
            : partnerJoined // ignore: cast_nullable_to_non_nullable
                  as bool,
        partnerUserId: freezed == partnerUserId
            ? _value.partnerUserId
            : partnerUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SosSessionImpl implements _SosSession {
  const _$SosSessionImpl({
    required this.id,
    @JsonKey(name: 'relation_id') required this.relationId,
    @JsonKey(name: 'initiated_by') required this.initiatedBy,
    required this.status,
    @JsonKey(name: 'initial_emotion') required this.initialEmotion,
    @JsonKey(name: 'initial_description') required this.initialDescription,
    @JsonKey(name: 'intensity_level') required this.intensityLevel,
    @JsonKey(name: 'conflict_topic') this.conflictTopic,
    @JsonKey(name: 'resolution_summary') this.resolutionSummary,
    @JsonKey(name: 'resolution_rating') this.resolutionRating,
    @JsonKey(name: 'total_messages') required this.totalMessages,
    @JsonKey(name: 'ai_responses') required this.aiResponses,
    @JsonKey(name: 'max_turns_reached') required this.maxTurnsReached,
    @JsonKey(name: 'total_ai_tokens') required this.totalAiTokens,
    @JsonKey(name: 'current_phase') this.currentPhase = 'welcome',
    @JsonKey(name: 'current_speaker') this.currentSpeaker,
    @JsonKey(name: 'turn_count') this.turnCount = 0,
    @JsonKey(name: 'partner_joined') this.partnerJoined = false,
    @JsonKey(name: 'partner_user_id') this.partnerUserId,
    @JsonKey(name: 'started_at') required this.startedAt,
    @JsonKey(name: 'ended_at') this.endedAt,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$SosSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SosSessionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'relation_id')
  final String relationId;
  @override
  @JsonKey(name: 'initiated_by')
  final String initiatedBy;
  @override
  final SosStatus status;
  @override
  @JsonKey(name: 'initial_emotion')
  final String initialEmotion;
  @override
  @JsonKey(name: 'initial_description')
  final String initialDescription;
  @override
  @JsonKey(name: 'intensity_level')
  final int intensityLevel;
  @override
  @JsonKey(name: 'conflict_topic')
  final String? conflictTopic;
  @override
  @JsonKey(name: 'resolution_summary')
  final String? resolutionSummary;
  @override
  @JsonKey(name: 'resolution_rating')
  final int? resolutionRating;
  @override
  @JsonKey(name: 'total_messages')
  final int totalMessages;
  @override
  @JsonKey(name: 'ai_responses')
  final int aiResponses;
  @override
  @JsonKey(name: 'max_turns_reached')
  final bool maxTurnsReached;
  @override
  @JsonKey(name: 'total_ai_tokens')
  final int totalAiTokens;
  @override
  @JsonKey(name: 'current_phase')
  final String currentPhase;
  @override
  @JsonKey(name: 'current_speaker')
  final String? currentSpeaker;
  @override
  @JsonKey(name: 'turn_count')
  final int turnCount;
  @override
  @JsonKey(name: 'partner_joined')
  final bool partnerJoined;
  @override
  @JsonKey(name: 'partner_user_id')
  final String? partnerUserId;
  @override
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @override
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SosSession(id: $id, relationId: $relationId, initiatedBy: $initiatedBy, status: $status, initialEmotion: $initialEmotion, initialDescription: $initialDescription, intensityLevel: $intensityLevel, conflictTopic: $conflictTopic, resolutionSummary: $resolutionSummary, resolutionRating: $resolutionRating, totalMessages: $totalMessages, aiResponses: $aiResponses, maxTurnsReached: $maxTurnsReached, totalAiTokens: $totalAiTokens, currentPhase: $currentPhase, currentSpeaker: $currentSpeaker, turnCount: $turnCount, partnerJoined: $partnerJoined, partnerUserId: $partnerUserId, startedAt: $startedAt, endedAt: $endedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SosSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.relationId, relationId) ||
                other.relationId == relationId) &&
            (identical(other.initiatedBy, initiatedBy) ||
                other.initiatedBy == initiatedBy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.initialEmotion, initialEmotion) ||
                other.initialEmotion == initialEmotion) &&
            (identical(other.initialDescription, initialDescription) ||
                other.initialDescription == initialDescription) &&
            (identical(other.intensityLevel, intensityLevel) ||
                other.intensityLevel == intensityLevel) &&
            (identical(other.conflictTopic, conflictTopic) ||
                other.conflictTopic == conflictTopic) &&
            (identical(other.resolutionSummary, resolutionSummary) ||
                other.resolutionSummary == resolutionSummary) &&
            (identical(other.resolutionRating, resolutionRating) ||
                other.resolutionRating == resolutionRating) &&
            (identical(other.totalMessages, totalMessages) ||
                other.totalMessages == totalMessages) &&
            (identical(other.aiResponses, aiResponses) ||
                other.aiResponses == aiResponses) &&
            (identical(other.maxTurnsReached, maxTurnsReached) ||
                other.maxTurnsReached == maxTurnsReached) &&
            (identical(other.totalAiTokens, totalAiTokens) ||
                other.totalAiTokens == totalAiTokens) &&
            (identical(other.currentPhase, currentPhase) ||
                other.currentPhase == currentPhase) &&
            (identical(other.currentSpeaker, currentSpeaker) ||
                other.currentSpeaker == currentSpeaker) &&
            (identical(other.turnCount, turnCount) ||
                other.turnCount == turnCount) &&
            (identical(other.partnerJoined, partnerJoined) ||
                other.partnerJoined == partnerJoined) &&
            (identical(other.partnerUserId, partnerUserId) ||
                other.partnerUserId == partnerUserId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    relationId,
    initiatedBy,
    status,
    initialEmotion,
    initialDescription,
    intensityLevel,
    conflictTopic,
    resolutionSummary,
    resolutionRating,
    totalMessages,
    aiResponses,
    maxTurnsReached,
    totalAiTokens,
    currentPhase,
    currentSpeaker,
    turnCount,
    partnerJoined,
    partnerUserId,
    startedAt,
    endedAt,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of SosSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SosSessionImplCopyWith<_$SosSessionImpl> get copyWith =>
      __$$SosSessionImplCopyWithImpl<_$SosSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SosSessionImplToJson(this);
  }
}

abstract class _SosSession implements SosSession {
  const factory _SosSession({
    required final String id,
    @JsonKey(name: 'relation_id') required final String relationId,
    @JsonKey(name: 'initiated_by') required final String initiatedBy,
    required final SosStatus status,
    @JsonKey(name: 'initial_emotion') required final String initialEmotion,
    @JsonKey(name: 'initial_description')
    required final String initialDescription,
    @JsonKey(name: 'intensity_level') required final int intensityLevel,
    @JsonKey(name: 'conflict_topic') final String? conflictTopic,
    @JsonKey(name: 'resolution_summary') final String? resolutionSummary,
    @JsonKey(name: 'resolution_rating') final int? resolutionRating,
    @JsonKey(name: 'total_messages') required final int totalMessages,
    @JsonKey(name: 'ai_responses') required final int aiResponses,
    @JsonKey(name: 'max_turns_reached') required final bool maxTurnsReached,
    @JsonKey(name: 'total_ai_tokens') required final int totalAiTokens,
    @JsonKey(name: 'current_phase') final String currentPhase,
    @JsonKey(name: 'current_speaker') final String? currentSpeaker,
    @JsonKey(name: 'turn_count') final int turnCount,
    @JsonKey(name: 'partner_joined') final bool partnerJoined,
    @JsonKey(name: 'partner_user_id') final String? partnerUserId,
    @JsonKey(name: 'started_at') required final DateTime startedAt,
    @JsonKey(name: 'ended_at') final DateTime? endedAt,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$SosSessionImpl;

  factory _SosSession.fromJson(Map<String, dynamic> json) =
      _$SosSessionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'relation_id')
  String get relationId;
  @override
  @JsonKey(name: 'initiated_by')
  String get initiatedBy;
  @override
  SosStatus get status;
  @override
  @JsonKey(name: 'initial_emotion')
  String get initialEmotion;
  @override
  @JsonKey(name: 'initial_description')
  String get initialDescription;
  @override
  @JsonKey(name: 'intensity_level')
  int get intensityLevel;
  @override
  @JsonKey(name: 'conflict_topic')
  String? get conflictTopic;
  @override
  @JsonKey(name: 'resolution_summary')
  String? get resolutionSummary;
  @override
  @JsonKey(name: 'resolution_rating')
  int? get resolutionRating;
  @override
  @JsonKey(name: 'total_messages')
  int get totalMessages;
  @override
  @JsonKey(name: 'ai_responses')
  int get aiResponses;
  @override
  @JsonKey(name: 'max_turns_reached')
  bool get maxTurnsReached;
  @override
  @JsonKey(name: 'total_ai_tokens')
  int get totalAiTokens;
  @override
  @JsonKey(name: 'current_phase')
  String get currentPhase;
  @override
  @JsonKey(name: 'current_speaker')
  String? get currentSpeaker;
  @override
  @JsonKey(name: 'turn_count')
  int get turnCount;
  @override
  @JsonKey(name: 'partner_joined')
  bool get partnerJoined;
  @override
  @JsonKey(name: 'partner_user_id')
  String? get partnerUserId;
  @override
  @JsonKey(name: 'started_at')
  DateTime get startedAt;
  @override
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of SosSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SosSessionImplCopyWith<_$SosSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SosEvent _$SosEventFromJson(Map<String, dynamic> json) {
  return _SosEvent.fromJson(json);
}

/// @nodoc
mixin _$SosEvent {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_type')
  String get eventType => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_tokens_used')
  int? get aiTokensUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SosEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SosEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SosEventCopyWith<SosEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SosEventCopyWith<$Res> {
  factory $SosEventCopyWith(SosEvent value, $Res Function(SosEvent) then) =
      _$SosEventCopyWithImpl<$Res, SosEvent>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'session_id') String sessionId,
    @JsonKey(name: 'event_type') String eventType,
    @JsonKey(name: 'user_id') String? userId,
    String? content,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'ai_tokens_used') int? aiTokensUsed,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$SosEventCopyWithImpl<$Res, $Val extends SosEvent>
    implements $SosEventCopyWith<$Res> {
  _$SosEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SosEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? eventType = null,
    Object? userId = freezed,
    Object? content = freezed,
    Object? metadata = freezed,
    Object? aiTokensUsed = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            eventType: null == eventType
                ? _value.eventType
                : eventType // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            aiTokensUsed: freezed == aiTokensUsed
                ? _value.aiTokensUsed
                : aiTokensUsed // ignore: cast_nullable_to_non_nullable
                      as int?,
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
abstract class _$$SosEventImplCopyWith<$Res>
    implements $SosEventCopyWith<$Res> {
  factory _$$SosEventImplCopyWith(
    _$SosEventImpl value,
    $Res Function(_$SosEventImpl) then,
  ) = __$$SosEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'session_id') String sessionId,
    @JsonKey(name: 'event_type') String eventType,
    @JsonKey(name: 'user_id') String? userId,
    String? content,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'ai_tokens_used') int? aiTokensUsed,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$SosEventImplCopyWithImpl<$Res>
    extends _$SosEventCopyWithImpl<$Res, _$SosEventImpl>
    implements _$$SosEventImplCopyWith<$Res> {
  __$$SosEventImplCopyWithImpl(
    _$SosEventImpl _value,
    $Res Function(_$SosEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SosEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? eventType = null,
    Object? userId = freezed,
    Object? content = freezed,
    Object? metadata = freezed,
    Object? aiTokensUsed = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$SosEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        eventType: null == eventType
            ? _value.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        aiTokensUsed: freezed == aiTokensUsed
            ? _value.aiTokensUsed
            : aiTokensUsed // ignore: cast_nullable_to_non_nullable
                  as int?,
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
class _$SosEventImpl implements _SosEvent {
  const _$SosEventImpl({
    required this.id,
    @JsonKey(name: 'session_id') required this.sessionId,
    @JsonKey(name: 'event_type') required this.eventType,
    @JsonKey(name: 'user_id') this.userId,
    this.content,
    final Map<String, dynamic>? metadata,
    @JsonKey(name: 'ai_tokens_used') this.aiTokensUsed,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : _metadata = metadata;

  factory _$SosEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$SosEventImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  @JsonKey(name: 'event_type')
  final String eventType;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  final String? content;
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
  @JsonKey(name: 'ai_tokens_used')
  final int? aiTokensUsed;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'SosEvent(id: $id, sessionId: $sessionId, eventType: $eventType, userId: $userId, content: $content, metadata: $metadata, aiTokensUsed: $aiTokensUsed, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SosEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.aiTokensUsed, aiTokensUsed) ||
                other.aiTokensUsed == aiTokensUsed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sessionId,
    eventType,
    userId,
    content,
    const DeepCollectionEquality().hash(_metadata),
    aiTokensUsed,
    createdAt,
  );

  /// Create a copy of SosEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SosEventImplCopyWith<_$SosEventImpl> get copyWith =>
      __$$SosEventImplCopyWithImpl<_$SosEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SosEventImplToJson(this);
  }
}

abstract class _SosEvent implements SosEvent {
  const factory _SosEvent({
    required final String id,
    @JsonKey(name: 'session_id') required final String sessionId,
    @JsonKey(name: 'event_type') required final String eventType,
    @JsonKey(name: 'user_id') final String? userId,
    final String? content,
    final Map<String, dynamic>? metadata,
    @JsonKey(name: 'ai_tokens_used') final int? aiTokensUsed,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$SosEventImpl;

  factory _SosEvent.fromJson(Map<String, dynamic> json) =
      _$SosEventImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'session_id')
  String get sessionId;
  @override
  @JsonKey(name: 'event_type')
  String get eventType;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  String? get content;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'ai_tokens_used')
  int? get aiTokensUsed;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of SosEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SosEventImplCopyWith<_$SosEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
