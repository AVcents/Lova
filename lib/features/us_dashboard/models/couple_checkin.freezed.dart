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
  String get coupleId => throw _privateConstructorUsedError;
  String get userId =>
      throw _privateConstructorUsedError; // Celui qui a fait le check-in
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Questions/Réponses
  int get connectionScore =>
      throw _privateConstructorUsedError; // 1-10 : "Comment te sens-tu connecté(e) à ton partenaire ?"
  int get satisfactionScore =>
      throw _privateConstructorUsedError; // 1-10 : "Es-tu satisfait(e) de la relation ?"
  int get communicationScore =>
      throw _privateConstructorUsedError; // 1-10 : "La communication est-elle fluide ?"
  String get emotionToday =>
      throw _privateConstructorUsedError; // Emoji : 😊, 😐, 😔, 😡, 😍
  String? get whatWentWell =>
      throw _privateConstructorUsedError; // "Qu'est-ce qui s'est bien passé cette semaine ?"
  String? get whatNeedsAttention =>
      throw _privateConstructorUsedError; // "Qu'est-ce qui nécessite de l'attention ?"
  String? get gratitudeNote =>
      throw _privateConstructorUsedError; // "Une chose pour laquelle tu es reconnaissant(e) ?"
  // Métadonnées
  bool get isCompleted => throw _privateConstructorUsedError; // ✅ CORRIGÉ
  String? get partnerCheckinId => throw _privateConstructorUsedError;

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
    String coupleId,
    String userId,
    DateTime createdAt,
    int connectionScore,
    int satisfactionScore,
    int communicationScore,
    String emotionToday,
    String? whatWentWell,
    String? whatNeedsAttention,
    String? gratitudeNote,
    bool isCompleted,
    String? partnerCheckinId,
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
    Object? coupleId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? connectionScore = null,
    Object? satisfactionScore = null,
    Object? communicationScore = null,
    Object? emotionToday = null,
    Object? whatWentWell = freezed,
    Object? whatNeedsAttention = freezed,
    Object? gratitudeNote = freezed,
    Object? isCompleted = null,
    Object? partnerCheckinId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            coupleId: null == coupleId
                ? _value.coupleId
                : coupleId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            connectionScore: null == connectionScore
                ? _value.connectionScore
                : connectionScore // ignore: cast_nullable_to_non_nullable
                      as int,
            satisfactionScore: null == satisfactionScore
                ? _value.satisfactionScore
                : satisfactionScore // ignore: cast_nullable_to_non_nullable
                      as int,
            communicationScore: null == communicationScore
                ? _value.communicationScore
                : communicationScore // ignore: cast_nullable_to_non_nullable
                      as int,
            emotionToday: null == emotionToday
                ? _value.emotionToday
                : emotionToday // ignore: cast_nullable_to_non_nullable
                      as String,
            whatWentWell: freezed == whatWentWell
                ? _value.whatWentWell
                : whatWentWell // ignore: cast_nullable_to_non_nullable
                      as String?,
            whatNeedsAttention: freezed == whatNeedsAttention
                ? _value.whatNeedsAttention
                : whatNeedsAttention // ignore: cast_nullable_to_non_nullable
                      as String?,
            gratitudeNote: freezed == gratitudeNote
                ? _value.gratitudeNote
                : gratitudeNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            partnerCheckinId: freezed == partnerCheckinId
                ? _value.partnerCheckinId
                : partnerCheckinId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String coupleId,
    String userId,
    DateTime createdAt,
    int connectionScore,
    int satisfactionScore,
    int communicationScore,
    String emotionToday,
    String? whatWentWell,
    String? whatNeedsAttention,
    String? gratitudeNote,
    bool isCompleted,
    String? partnerCheckinId,
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
    Object? coupleId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? connectionScore = null,
    Object? satisfactionScore = null,
    Object? communicationScore = null,
    Object? emotionToday = null,
    Object? whatWentWell = freezed,
    Object? whatNeedsAttention = freezed,
    Object? gratitudeNote = freezed,
    Object? isCompleted = null,
    Object? partnerCheckinId = freezed,
  }) {
    return _then(
      _$CoupleCheckinImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        coupleId: null == coupleId
            ? _value.coupleId
            : coupleId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        connectionScore: null == connectionScore
            ? _value.connectionScore
            : connectionScore // ignore: cast_nullable_to_non_nullable
                  as int,
        satisfactionScore: null == satisfactionScore
            ? _value.satisfactionScore
            : satisfactionScore // ignore: cast_nullable_to_non_nullable
                  as int,
        communicationScore: null == communicationScore
            ? _value.communicationScore
            : communicationScore // ignore: cast_nullable_to_non_nullable
                  as int,
        emotionToday: null == emotionToday
            ? _value.emotionToday
            : emotionToday // ignore: cast_nullable_to_non_nullable
                  as String,
        whatWentWell: freezed == whatWentWell
            ? _value.whatWentWell
            : whatWentWell // ignore: cast_nullable_to_non_nullable
                  as String?,
        whatNeedsAttention: freezed == whatNeedsAttention
            ? _value.whatNeedsAttention
            : whatNeedsAttention // ignore: cast_nullable_to_non_nullable
                  as String?,
        gratitudeNote: freezed == gratitudeNote
            ? _value.gratitudeNote
            : gratitudeNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        partnerCheckinId: freezed == partnerCheckinId
            ? _value.partnerCheckinId
            : partnerCheckinId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoupleCheckinImpl implements _CoupleCheckin {
  const _$CoupleCheckinImpl({
    required this.id,
    required this.coupleId,
    required this.userId,
    required this.createdAt,
    required this.connectionScore,
    required this.satisfactionScore,
    required this.communicationScore,
    required this.emotionToday,
    this.whatWentWell,
    this.whatNeedsAttention,
    this.gratitudeNote,
    this.isCompleted = false,
    this.partnerCheckinId,
  });

  factory _$CoupleCheckinImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoupleCheckinImplFromJson(json);

  @override
  final String id;
  @override
  final String coupleId;
  @override
  final String userId;
  // Celui qui a fait le check-in
  @override
  final DateTime createdAt;
  // Questions/Réponses
  @override
  final int connectionScore;
  // 1-10 : "Comment te sens-tu connecté(e) à ton partenaire ?"
  @override
  final int satisfactionScore;
  // 1-10 : "Es-tu satisfait(e) de la relation ?"
  @override
  final int communicationScore;
  // 1-10 : "La communication est-elle fluide ?"
  @override
  final String emotionToday;
  // Emoji : 😊, 😐, 😔, 😡, 😍
  @override
  final String? whatWentWell;
  // "Qu'est-ce qui s'est bien passé cette semaine ?"
  @override
  final String? whatNeedsAttention;
  // "Qu'est-ce qui nécessite de l'attention ?"
  @override
  final String? gratitudeNote;
  // "Une chose pour laquelle tu es reconnaissant(e) ?"
  // Métadonnées
  @override
  @JsonKey()
  final bool isCompleted;
  // ✅ CORRIGÉ
  @override
  final String? partnerCheckinId;

  @override
  String toString() {
    return 'CoupleCheckin(id: $id, coupleId: $coupleId, userId: $userId, createdAt: $createdAt, connectionScore: $connectionScore, satisfactionScore: $satisfactionScore, communicationScore: $communicationScore, emotionToday: $emotionToday, whatWentWell: $whatWentWell, whatNeedsAttention: $whatNeedsAttention, gratitudeNote: $gratitudeNote, isCompleted: $isCompleted, partnerCheckinId: $partnerCheckinId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoupleCheckinImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.coupleId, coupleId) ||
                other.coupleId == coupleId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.connectionScore, connectionScore) ||
                other.connectionScore == connectionScore) &&
            (identical(other.satisfactionScore, satisfactionScore) ||
                other.satisfactionScore == satisfactionScore) &&
            (identical(other.communicationScore, communicationScore) ||
                other.communicationScore == communicationScore) &&
            (identical(other.emotionToday, emotionToday) ||
                other.emotionToday == emotionToday) &&
            (identical(other.whatWentWell, whatWentWell) ||
                other.whatWentWell == whatWentWell) &&
            (identical(other.whatNeedsAttention, whatNeedsAttention) ||
                other.whatNeedsAttention == whatNeedsAttention) &&
            (identical(other.gratitudeNote, gratitudeNote) ||
                other.gratitudeNote == gratitudeNote) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.partnerCheckinId, partnerCheckinId) ||
                other.partnerCheckinId == partnerCheckinId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    coupleId,
    userId,
    createdAt,
    connectionScore,
    satisfactionScore,
    communicationScore,
    emotionToday,
    whatWentWell,
    whatNeedsAttention,
    gratitudeNote,
    isCompleted,
    partnerCheckinId,
  );

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
    required final String coupleId,
    required final String userId,
    required final DateTime createdAt,
    required final int connectionScore,
    required final int satisfactionScore,
    required final int communicationScore,
    required final String emotionToday,
    final String? whatWentWell,
    final String? whatNeedsAttention,
    final String? gratitudeNote,
    final bool isCompleted,
    final String? partnerCheckinId,
  }) = _$CoupleCheckinImpl;

  factory _CoupleCheckin.fromJson(Map<String, dynamic> json) =
      _$CoupleCheckinImpl.fromJson;

  @override
  String get id;
  @override
  String get coupleId;
  @override
  String get userId; // Celui qui a fait le check-in
  @override
  DateTime get createdAt; // Questions/Réponses
  @override
  int get connectionScore; // 1-10 : "Comment te sens-tu connecté(e) à ton partenaire ?"
  @override
  int get satisfactionScore; // 1-10 : "Es-tu satisfait(e) de la relation ?"
  @override
  int get communicationScore; // 1-10 : "La communication est-elle fluide ?"
  @override
  String get emotionToday; // Emoji : 😊, 😐, 😔, 😡, 😍
  @override
  String? get whatWentWell; // "Qu'est-ce qui s'est bien passé cette semaine ?"
  @override
  String? get whatNeedsAttention; // "Qu'est-ce qui nécessite de l'attention ?"
  @override
  String? get gratitudeNote; // "Une chose pour laquelle tu es reconnaissant(e) ?"
  // Métadonnées
  @override
  bool get isCompleted; // ✅ CORRIGÉ
  @override
  String? get partnerCheckinId;

  /// Create a copy of CoupleCheckin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoupleCheckinImplCopyWith<_$CoupleCheckinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CoupleCheckinStats {
  double get averageConnectionScore => throw _privateConstructorUsedError;
  double get averageSatisfactionScore => throw _privateConstructorUsedError;
  double get averageCommunicationScore => throw _privateConstructorUsedError;
  List<CoupleCheckin> get recentCheckins => throw _privateConstructorUsedError;
  int get totalCheckins => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;

  /// Create a copy of CoupleCheckinStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoupleCheckinStatsCopyWith<CoupleCheckinStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoupleCheckinStatsCopyWith<$Res> {
  factory $CoupleCheckinStatsCopyWith(
    CoupleCheckinStats value,
    $Res Function(CoupleCheckinStats) then,
  ) = _$CoupleCheckinStatsCopyWithImpl<$Res, CoupleCheckinStats>;
  @useResult
  $Res call({
    double averageConnectionScore,
    double averageSatisfactionScore,
    double averageCommunicationScore,
    List<CoupleCheckin> recentCheckins,
    int totalCheckins,
    int currentStreak,
  });
}

/// @nodoc
class _$CoupleCheckinStatsCopyWithImpl<$Res, $Val extends CoupleCheckinStats>
    implements $CoupleCheckinStatsCopyWith<$Res> {
  _$CoupleCheckinStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoupleCheckinStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageConnectionScore = null,
    Object? averageSatisfactionScore = null,
    Object? averageCommunicationScore = null,
    Object? recentCheckins = null,
    Object? totalCheckins = null,
    Object? currentStreak = null,
  }) {
    return _then(
      _value.copyWith(
            averageConnectionScore: null == averageConnectionScore
                ? _value.averageConnectionScore
                : averageConnectionScore // ignore: cast_nullable_to_non_nullable
                      as double,
            averageSatisfactionScore: null == averageSatisfactionScore
                ? _value.averageSatisfactionScore
                : averageSatisfactionScore // ignore: cast_nullable_to_non_nullable
                      as double,
            averageCommunicationScore: null == averageCommunicationScore
                ? _value.averageCommunicationScore
                : averageCommunicationScore // ignore: cast_nullable_to_non_nullable
                      as double,
            recentCheckins: null == recentCheckins
                ? _value.recentCheckins
                : recentCheckins // ignore: cast_nullable_to_non_nullable
                      as List<CoupleCheckin>,
            totalCheckins: null == totalCheckins
                ? _value.totalCheckins
                : totalCheckins // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoupleCheckinStatsImplCopyWith<$Res>
    implements $CoupleCheckinStatsCopyWith<$Res> {
  factory _$$CoupleCheckinStatsImplCopyWith(
    _$CoupleCheckinStatsImpl value,
    $Res Function(_$CoupleCheckinStatsImpl) then,
  ) = __$$CoupleCheckinStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double averageConnectionScore,
    double averageSatisfactionScore,
    double averageCommunicationScore,
    List<CoupleCheckin> recentCheckins,
    int totalCheckins,
    int currentStreak,
  });
}

/// @nodoc
class __$$CoupleCheckinStatsImplCopyWithImpl<$Res>
    extends _$CoupleCheckinStatsCopyWithImpl<$Res, _$CoupleCheckinStatsImpl>
    implements _$$CoupleCheckinStatsImplCopyWith<$Res> {
  __$$CoupleCheckinStatsImplCopyWithImpl(
    _$CoupleCheckinStatsImpl _value,
    $Res Function(_$CoupleCheckinStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoupleCheckinStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageConnectionScore = null,
    Object? averageSatisfactionScore = null,
    Object? averageCommunicationScore = null,
    Object? recentCheckins = null,
    Object? totalCheckins = null,
    Object? currentStreak = null,
  }) {
    return _then(
      _$CoupleCheckinStatsImpl(
        averageConnectionScore: null == averageConnectionScore
            ? _value.averageConnectionScore
            : averageConnectionScore // ignore: cast_nullable_to_non_nullable
                  as double,
        averageSatisfactionScore: null == averageSatisfactionScore
            ? _value.averageSatisfactionScore
            : averageSatisfactionScore // ignore: cast_nullable_to_non_nullable
                  as double,
        averageCommunicationScore: null == averageCommunicationScore
            ? _value.averageCommunicationScore
            : averageCommunicationScore // ignore: cast_nullable_to_non_nullable
                  as double,
        recentCheckins: null == recentCheckins
            ? _value._recentCheckins
            : recentCheckins // ignore: cast_nullable_to_non_nullable
                  as List<CoupleCheckin>,
        totalCheckins: null == totalCheckins
            ? _value.totalCheckins
            : totalCheckins // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CoupleCheckinStatsImpl implements _CoupleCheckinStats {
  const _$CoupleCheckinStatsImpl({
    required this.averageConnectionScore,
    required this.averageSatisfactionScore,
    required this.averageCommunicationScore,
    required final List<CoupleCheckin> recentCheckins,
    required this.totalCheckins,
    required this.currentStreak,
  }) : _recentCheckins = recentCheckins;

  @override
  final double averageConnectionScore;
  @override
  final double averageSatisfactionScore;
  @override
  final double averageCommunicationScore;
  final List<CoupleCheckin> _recentCheckins;
  @override
  List<CoupleCheckin> get recentCheckins {
    if (_recentCheckins is EqualUnmodifiableListView) return _recentCheckins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentCheckins);
  }

  @override
  final int totalCheckins;
  @override
  final int currentStreak;

  @override
  String toString() {
    return 'CoupleCheckinStats(averageConnectionScore: $averageConnectionScore, averageSatisfactionScore: $averageSatisfactionScore, averageCommunicationScore: $averageCommunicationScore, recentCheckins: $recentCheckins, totalCheckins: $totalCheckins, currentStreak: $currentStreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoupleCheckinStatsImpl &&
            (identical(other.averageConnectionScore, averageConnectionScore) ||
                other.averageConnectionScore == averageConnectionScore) &&
            (identical(
                  other.averageSatisfactionScore,
                  averageSatisfactionScore,
                ) ||
                other.averageSatisfactionScore == averageSatisfactionScore) &&
            (identical(
                  other.averageCommunicationScore,
                  averageCommunicationScore,
                ) ||
                other.averageCommunicationScore == averageCommunicationScore) &&
            const DeepCollectionEquality().equals(
              other._recentCheckins,
              _recentCheckins,
            ) &&
            (identical(other.totalCheckins, totalCheckins) ||
                other.totalCheckins == totalCheckins) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    averageConnectionScore,
    averageSatisfactionScore,
    averageCommunicationScore,
    const DeepCollectionEquality().hash(_recentCheckins),
    totalCheckins,
    currentStreak,
  );

  /// Create a copy of CoupleCheckinStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoupleCheckinStatsImplCopyWith<_$CoupleCheckinStatsImpl> get copyWith =>
      __$$CoupleCheckinStatsImplCopyWithImpl<_$CoupleCheckinStatsImpl>(
        this,
        _$identity,
      );
}

abstract class _CoupleCheckinStats implements CoupleCheckinStats {
  const factory _CoupleCheckinStats({
    required final double averageConnectionScore,
    required final double averageSatisfactionScore,
    required final double averageCommunicationScore,
    required final List<CoupleCheckin> recentCheckins,
    required final int totalCheckins,
    required final int currentStreak,
  }) = _$CoupleCheckinStatsImpl;

  @override
  double get averageConnectionScore;
  @override
  double get averageSatisfactionScore;
  @override
  double get averageCommunicationScore;
  @override
  List<CoupleCheckin> get recentCheckins;
  @override
  int get totalCheckins;
  @override
  int get currentStreak;

  /// Create a copy of CoupleCheckinStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoupleCheckinStatsImplCopyWith<_$CoupleCheckinStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
