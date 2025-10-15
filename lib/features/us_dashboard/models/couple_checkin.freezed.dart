// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'couple_checkin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoupleCheckin _$CoupleCheckinFromJson(Map<String, dynamic> json) {
  return _CoupleCheckin.fromJson(json);
}

/// @nodoc
mixin _$CoupleCheckin {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'relation_id')
  String get relationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkin_date')
  DateTime get checkinDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError; // Scores
  @JsonKey(name: 'score_connection')
  int get scoreConnection => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_satisfaction')
  int get scoreSatisfaction => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_communication')
  int get scoreCommunication => throw _privateConstructorUsedError; // Émotion
  @JsonKey(name: 'emotion', fromJson: _emotionFromJson, toJson: _emotionToJson)
  EmotionType get emotion => throw _privateConstructorUsedError; // Textes + partage
  @JsonKey(name: 'gratitude_text')
  String? get gratitudeText => throw _privateConstructorUsedError;
  @JsonKey(name: 'gratitude_shared')
  bool? get gratitudeShared => throw _privateConstructorUsedError;
  @JsonKey(name: 'concern_text')
  String? get concernText => throw _privateConstructorUsedError;
  @JsonKey(name: 'concern_shared')
  bool? get concernShared => throw _privateConstructorUsedError;
  @JsonKey(name: 'need_text')
  String? get needText => throw _privateConstructorUsedError;
  @JsonKey(name: 'need_shared')
  bool? get needShared => throw _privateConstructorUsedError; // IA
  @JsonKey(name: 'tone_detected')
  String? get toneDetected => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_tokens_used')
  int? get aiTokensUsed => throw _privateConstructorUsedError; // Timestamps
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CoupleCheckin to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoupleCheckin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoupleCheckinCopyWith<CoupleCheckin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoupleCheckinCopyWith<$Res> {
  factory $CoupleCheckinCopyWith(
    CoupleCheckin value,
    $Res Function(CoupleCheckin) then,
  ) = _$CoupleCheckinCopyWithImpl<$Res, CoupleCheckin>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'checkin_date') DateTime checkinDate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'score_connection') int scoreConnection,
    @JsonKey(name: 'score_satisfaction') int scoreSatisfaction,
    @JsonKey(name: 'score_communication') int scoreCommunication,
    @JsonKey(
      name: 'emotion',
      fromJson: _emotionFromJson,
      toJson: _emotionToJson,
    )
    EmotionType emotion,
    @JsonKey(name: 'gratitude_text') String? gratitudeText,
    @JsonKey(name: 'gratitude_shared') bool? gratitudeShared,
    @JsonKey(name: 'concern_text') String? concernText,
    @JsonKey(name: 'concern_shared') bool? concernShared,
    @JsonKey(name: 'need_text') String? needText,
    @JsonKey(name: 'need_shared') bool? needShared,
    @JsonKey(name: 'tone_detected') String? toneDetected,
    @JsonKey(name: 'ai_tokens_used') int? aiTokensUsed,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$CoupleCheckinCopyWithImpl<$Res, $Val extends CoupleCheckin>
    implements $CoupleCheckinCopyWith<$Res> {
  _$CoupleCheckinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoupleCheckin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? userId = null,
    Object? checkinDate = null,
    Object? createdAt = null,
    Object? scoreConnection = null,
    Object? scoreSatisfaction = null,
    Object? scoreCommunication = null,
    Object? emotion = null,
    Object? gratitudeText = freezed,
    Object? gratitudeShared = freezed,
    Object? concernText = freezed,
    Object? concernShared = freezed,
    Object? needText = freezed,
    Object? needShared = freezed,
    Object? toneDetected = freezed,
    Object? aiTokensUsed = freezed,
    Object? completedAt = freezed,
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
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            checkinDate: null == checkinDate
                ? _value.checkinDate
                : checkinDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            scoreConnection: null == scoreConnection
                ? _value.scoreConnection
                : scoreConnection // ignore: cast_nullable_to_non_nullable
                      as int,
            scoreSatisfaction: null == scoreSatisfaction
                ? _value.scoreSatisfaction
                : scoreSatisfaction // ignore: cast_nullable_to_non_nullable
                      as int,
            scoreCommunication: null == scoreCommunication
                ? _value.scoreCommunication
                : scoreCommunication // ignore: cast_nullable_to_non_nullable
                      as int,
            emotion: null == emotion
                ? _value.emotion
                : emotion // ignore: cast_nullable_to_non_nullable
                      as EmotionType,
            gratitudeText: freezed == gratitudeText
                ? _value.gratitudeText
                : gratitudeText // ignore: cast_nullable_to_non_nullable
                      as String?,
            gratitudeShared: freezed == gratitudeShared
                ? _value.gratitudeShared
                : gratitudeShared // ignore: cast_nullable_to_non_nullable
                      as bool?,
            concernText: freezed == concernText
                ? _value.concernText
                : concernText // ignore: cast_nullable_to_non_nullable
                      as String?,
            concernShared: freezed == concernShared
                ? _value.concernShared
                : concernShared // ignore: cast_nullable_to_non_nullable
                      as bool?,
            needText: freezed == needText
                ? _value.needText
                : needText // ignore: cast_nullable_to_non_nullable
                      as String?,
            needShared: freezed == needShared
                ? _value.needShared
                : needShared // ignore: cast_nullable_to_non_nullable
                      as bool?,
            toneDetected: freezed == toneDetected
                ? _value.toneDetected
                : toneDetected // ignore: cast_nullable_to_non_nullable
                      as String?,
            aiTokensUsed: freezed == aiTokensUsed
                ? _value.aiTokensUsed
                : aiTokensUsed // ignore: cast_nullable_to_non_nullable
                      as int?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CoupleCheckinImplCopyWith<$Res>
    implements $CoupleCheckinCopyWith<$Res> {
  factory _$$CoupleCheckinImplCopyWith(
    _$CoupleCheckinImpl value,
    $Res Function(_$CoupleCheckinImpl) then,
  ) = __$$CoupleCheckinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'checkin_date') DateTime checkinDate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'score_connection') int scoreConnection,
    @JsonKey(name: 'score_satisfaction') int scoreSatisfaction,
    @JsonKey(name: 'score_communication') int scoreCommunication,
    @JsonKey(
      name: 'emotion',
      fromJson: _emotionFromJson,
      toJson: _emotionToJson,
    )
    EmotionType emotion,
    @JsonKey(name: 'gratitude_text') String? gratitudeText,
    @JsonKey(name: 'gratitude_shared') bool? gratitudeShared,
    @JsonKey(name: 'concern_text') String? concernText,
    @JsonKey(name: 'concern_shared') bool? concernShared,
    @JsonKey(name: 'need_text') String? needText,
    @JsonKey(name: 'need_shared') bool? needShared,
    @JsonKey(name: 'tone_detected') String? toneDetected,
    @JsonKey(name: 'ai_tokens_used') int? aiTokensUsed,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CoupleCheckinImplCopyWithImpl<$Res>
    extends _$CoupleCheckinCopyWithImpl<$Res, _$CoupleCheckinImpl>
    implements _$$CoupleCheckinImplCopyWith<$Res> {
  __$$CoupleCheckinImplCopyWithImpl(
    _$CoupleCheckinImpl _value,
    $Res Function(_$CoupleCheckinImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoupleCheckin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationId = null,
    Object? userId = null,
    Object? checkinDate = null,
    Object? createdAt = null,
    Object? scoreConnection = null,
    Object? scoreSatisfaction = null,
    Object? scoreCommunication = null,
    Object? emotion = null,
    Object? gratitudeText = freezed,
    Object? gratitudeShared = freezed,
    Object? concernText = freezed,
    Object? concernShared = freezed,
    Object? needText = freezed,
    Object? needShared = freezed,
    Object? toneDetected = freezed,
    Object? aiTokensUsed = freezed,
    Object? completedAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CoupleCheckinImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        relationId: null == relationId
            ? _value.relationId
            : relationId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        checkinDate: null == checkinDate
            ? _value.checkinDate
            : checkinDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        scoreConnection: null == scoreConnection
            ? _value.scoreConnection
            : scoreConnection // ignore: cast_nullable_to_non_nullable
                  as int,
        scoreSatisfaction: null == scoreSatisfaction
            ? _value.scoreSatisfaction
            : scoreSatisfaction // ignore: cast_nullable_to_non_nullable
                  as int,
        scoreCommunication: null == scoreCommunication
            ? _value.scoreCommunication
            : scoreCommunication // ignore: cast_nullable_to_non_nullable
                  as int,
        emotion: null == emotion
            ? _value.emotion
            : emotion // ignore: cast_nullable_to_non_nullable
                  as EmotionType,
        gratitudeText: freezed == gratitudeText
            ? _value.gratitudeText
            : gratitudeText // ignore: cast_nullable_to_non_nullable
                  as String?,
        gratitudeShared: freezed == gratitudeShared
            ? _value.gratitudeShared
            : gratitudeShared // ignore: cast_nullable_to_non_nullable
                  as bool?,
        concernText: freezed == concernText
            ? _value.concernText
            : concernText // ignore: cast_nullable_to_non_nullable
                  as String?,
        concernShared: freezed == concernShared
            ? _value.concernShared
            : concernShared // ignore: cast_nullable_to_non_nullable
                  as bool?,
        needText: freezed == needText
            ? _value.needText
            : needText // ignore: cast_nullable_to_non_nullable
                  as String?,
        needShared: freezed == needShared
            ? _value.needShared
            : needShared // ignore: cast_nullable_to_non_nullable
                  as bool?,
        toneDetected: freezed == toneDetected
            ? _value.toneDetected
            : toneDetected // ignore: cast_nullable_to_non_nullable
                  as String?,
        aiTokensUsed: freezed == aiTokensUsed
            ? _value.aiTokensUsed
            : aiTokensUsed // ignore: cast_nullable_to_non_nullable
                  as int?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
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
class _$CoupleCheckinImpl implements _CoupleCheckin {
  const _$CoupleCheckinImpl({
    required this.id,
    @JsonKey(name: 'relation_id') required this.relationId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'checkin_date') required this.checkinDate,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'score_connection') required this.scoreConnection,
    @JsonKey(name: 'score_satisfaction') required this.scoreSatisfaction,
    @JsonKey(name: 'score_communication') required this.scoreCommunication,
    @JsonKey(
      name: 'emotion',
      fromJson: _emotionFromJson,
      toJson: _emotionToJson,
    )
    required this.emotion,
    @JsonKey(name: 'gratitude_text') this.gratitudeText,
    @JsonKey(name: 'gratitude_shared') this.gratitudeShared,
    @JsonKey(name: 'concern_text') this.concernText,
    @JsonKey(name: 'concern_shared') this.concernShared,
    @JsonKey(name: 'need_text') this.needText,
    @JsonKey(name: 'need_shared') this.needShared,
    @JsonKey(name: 'tone_detected') this.toneDetected,
    @JsonKey(name: 'ai_tokens_used') this.aiTokensUsed,
    @JsonKey(name: 'completed_at') this.completedAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$CoupleCheckinImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoupleCheckinImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'relation_id')
  final String relationId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'checkin_date')
  final DateTime checkinDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  // Scores
  @override
  @JsonKey(name: 'score_connection')
  final int scoreConnection;
  @override
  @JsonKey(name: 'score_satisfaction')
  final int scoreSatisfaction;
  @override
  @JsonKey(name: 'score_communication')
  final int scoreCommunication;
  // Émotion
  @override
  @JsonKey(name: 'emotion', fromJson: _emotionFromJson, toJson: _emotionToJson)
  final EmotionType emotion;
  // Textes + partage
  @override
  @JsonKey(name: 'gratitude_text')
  final String? gratitudeText;
  @override
  @JsonKey(name: 'gratitude_shared')
  final bool? gratitudeShared;
  @override
  @JsonKey(name: 'concern_text')
  final String? concernText;
  @override
  @JsonKey(name: 'concern_shared')
  final bool? concernShared;
  @override
  @JsonKey(name: 'need_text')
  final String? needText;
  @override
  @JsonKey(name: 'need_shared')
  final bool? needShared;
  // IA
  @override
  @JsonKey(name: 'tone_detected')
  final String? toneDetected;
  @override
  @JsonKey(name: 'ai_tokens_used')
  final int? aiTokensUsed;
  // Timestamps
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CoupleCheckin(id: $id, relationId: $relationId, userId: $userId, checkinDate: $checkinDate, createdAt: $createdAt, scoreConnection: $scoreConnection, scoreSatisfaction: $scoreSatisfaction, scoreCommunication: $scoreCommunication, emotion: $emotion, gratitudeText: $gratitudeText, gratitudeShared: $gratitudeShared, concernText: $concernText, concernShared: $concernShared, needText: $needText, needShared: $needShared, toneDetected: $toneDetected, aiTokensUsed: $aiTokensUsed, completedAt: $completedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoupleCheckinImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.relationId, relationId) ||
                other.relationId == relationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.checkinDate, checkinDate) ||
                other.checkinDate == checkinDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.scoreConnection, scoreConnection) ||
                other.scoreConnection == scoreConnection) &&
            (identical(other.scoreSatisfaction, scoreSatisfaction) ||
                other.scoreSatisfaction == scoreSatisfaction) &&
            (identical(other.scoreCommunication, scoreCommunication) ||
                other.scoreCommunication == scoreCommunication) &&
            (identical(other.emotion, emotion) || other.emotion == emotion) &&
            (identical(other.gratitudeText, gratitudeText) ||
                other.gratitudeText == gratitudeText) &&
            (identical(other.gratitudeShared, gratitudeShared) ||
                other.gratitudeShared == gratitudeShared) &&
            (identical(other.concernText, concernText) ||
                other.concernText == concernText) &&
            (identical(other.concernShared, concernShared) ||
                other.concernShared == concernShared) &&
            (identical(other.needText, needText) ||
                other.needText == needText) &&
            (identical(other.needShared, needShared) ||
                other.needShared == needShared) &&
            (identical(other.toneDetected, toneDetected) ||
                other.toneDetected == toneDetected) &&
            (identical(other.aiTokensUsed, aiTokensUsed) ||
                other.aiTokensUsed == aiTokensUsed) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    relationId,
    userId,
    checkinDate,
    createdAt,
    scoreConnection,
    scoreSatisfaction,
    scoreCommunication,
    emotion,
    gratitudeText,
    gratitudeShared,
    concernText,
    concernShared,
    needText,
    needShared,
    toneDetected,
    aiTokensUsed,
    completedAt,
    updatedAt,
  ]);

  /// Create a copy of CoupleCheckin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoupleCheckinImplCopyWith<_$CoupleCheckinImpl> get copyWith =>
      __$$CoupleCheckinImplCopyWithImpl<_$CoupleCheckinImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoupleCheckinImplToJson(this);
  }
}

abstract class _CoupleCheckin implements CoupleCheckin {
  const factory _CoupleCheckin({
    required final String id,
    @JsonKey(name: 'relation_id') required final String relationId,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'checkin_date') required final DateTime checkinDate,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'score_connection') required final int scoreConnection,
    @JsonKey(name: 'score_satisfaction') required final int scoreSatisfaction,
    @JsonKey(name: 'score_communication') required final int scoreCommunication,
    @JsonKey(
      name: 'emotion',
      fromJson: _emotionFromJson,
      toJson: _emotionToJson,
    )
    required final EmotionType emotion,
    @JsonKey(name: 'gratitude_text') final String? gratitudeText,
    @JsonKey(name: 'gratitude_shared') final bool? gratitudeShared,
    @JsonKey(name: 'concern_text') final String? concernText,
    @JsonKey(name: 'concern_shared') final bool? concernShared,
    @JsonKey(name: 'need_text') final String? needText,
    @JsonKey(name: 'need_shared') final bool? needShared,
    @JsonKey(name: 'tone_detected') final String? toneDetected,
    @JsonKey(name: 'ai_tokens_used') final int? aiTokensUsed,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$CoupleCheckinImpl;

  factory _CoupleCheckin.fromJson(Map<String, dynamic> json) =
      _$CoupleCheckinImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'relation_id')
  String get relationId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'checkin_date')
  DateTime get checkinDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt; // Scores
  @override
  @JsonKey(name: 'score_connection')
  int get scoreConnection;
  @override
  @JsonKey(name: 'score_satisfaction')
  int get scoreSatisfaction;
  @override
  @JsonKey(name: 'score_communication')
  int get scoreCommunication; // Émotion
  @override
  @JsonKey(name: 'emotion', fromJson: _emotionFromJson, toJson: _emotionToJson)
  EmotionType get emotion; // Textes + partage
  @override
  @JsonKey(name: 'gratitude_text')
  String? get gratitudeText;
  @override
  @JsonKey(name: 'gratitude_shared')
  bool? get gratitudeShared;
  @override
  @JsonKey(name: 'concern_text')
  String? get concernText;
  @override
  @JsonKey(name: 'concern_shared')
  bool? get concernShared;
  @override
  @JsonKey(name: 'need_text')
  String? get needText;
  @override
  @JsonKey(name: 'need_shared')
  bool? get needShared; // IA
  @override
  @JsonKey(name: 'tone_detected')
  String? get toneDetected;
  @override
  @JsonKey(name: 'ai_tokens_used')
  int? get aiTokensUsed; // Timestamps
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of CoupleCheckin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoupleCheckinImplCopyWith<_$CoupleCheckinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
