// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deck_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeckProgress _$DeckProgressFromJson(Map<String, dynamic> json) {
  return _DeckProgress.fromJson(json);
}

/// @nodoc
mixin _$DeckProgress {
  @JsonKey(name: 'relation_id')
  String get relationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'deck_id')
  String get deckId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cards_completed')
  int get cardsCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cards')
  int get totalCards => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_locked')
  bool get isLocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_replay')
  bool get canReplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_played_at')
  DateTime? get lastPlayedAt => throw _privateConstructorUsedError;

  /// Serializes this DeckProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeckProgressCopyWith<DeckProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeckProgressCopyWith<$Res> {
  factory $DeckProgressCopyWith(
    DeckProgress value,
    $Res Function(DeckProgress) then,
  ) = _$DeckProgressCopyWithImpl<$Res, DeckProgress>;
  @useResult
  $Res call({
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'deck_id') String deckId,
    @JsonKey(name: 'cards_completed') int cardsCompleted,
    @JsonKey(name: 'total_cards') int totalCards,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'is_locked') bool isLocked,
    @JsonKey(name: 'can_replay') bool canReplay,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'last_played_at') DateTime? lastPlayedAt,
  });
}

/// @nodoc
class _$DeckProgressCopyWithImpl<$Res, $Val extends DeckProgress>
    implements $DeckProgressCopyWith<$Res> {
  _$DeckProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relationId = null,
    Object? deckId = null,
    Object? cardsCompleted = null,
    Object? totalCards = null,
    Object? isCompleted = null,
    Object? isLocked = null,
    Object? canReplay = null,
    Object? completedAt = freezed,
    Object? lastPlayedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            relationId: null == relationId
                ? _value.relationId
                : relationId // ignore: cast_nullable_to_non_nullable
                      as String,
            deckId: null == deckId
                ? _value.deckId
                : deckId // ignore: cast_nullable_to_non_nullable
                      as String,
            cardsCompleted: null == cardsCompleted
                ? _value.cardsCompleted
                : cardsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCards: null == totalCards
                ? _value.totalCards
                : totalCards // ignore: cast_nullable_to_non_nullable
                      as int,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLocked: null == isLocked
                ? _value.isLocked
                : isLocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            canReplay: null == canReplay
                ? _value.canReplay
                : canReplay // ignore: cast_nullable_to_non_nullable
                      as bool,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastPlayedAt: freezed == lastPlayedAt
                ? _value.lastPlayedAt
                : lastPlayedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeckProgressImplCopyWith<$Res>
    implements $DeckProgressCopyWith<$Res> {
  factory _$$DeckProgressImplCopyWith(
    _$DeckProgressImpl value,
    $Res Function(_$DeckProgressImpl) then,
  ) = __$$DeckProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'relation_id') String relationId,
    @JsonKey(name: 'deck_id') String deckId,
    @JsonKey(name: 'cards_completed') int cardsCompleted,
    @JsonKey(name: 'total_cards') int totalCards,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'is_locked') bool isLocked,
    @JsonKey(name: 'can_replay') bool canReplay,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'last_played_at') DateTime? lastPlayedAt,
  });
}

/// @nodoc
class __$$DeckProgressImplCopyWithImpl<$Res>
    extends _$DeckProgressCopyWithImpl<$Res, _$DeckProgressImpl>
    implements _$$DeckProgressImplCopyWith<$Res> {
  __$$DeckProgressImplCopyWithImpl(
    _$DeckProgressImpl _value,
    $Res Function(_$DeckProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relationId = null,
    Object? deckId = null,
    Object? cardsCompleted = null,
    Object? totalCards = null,
    Object? isCompleted = null,
    Object? isLocked = null,
    Object? canReplay = null,
    Object? completedAt = freezed,
    Object? lastPlayedAt = freezed,
  }) {
    return _then(
      _$DeckProgressImpl(
        relationId: null == relationId
            ? _value.relationId
            : relationId // ignore: cast_nullable_to_non_nullable
                  as String,
        deckId: null == deckId
            ? _value.deckId
            : deckId // ignore: cast_nullable_to_non_nullable
                  as String,
        cardsCompleted: null == cardsCompleted
            ? _value.cardsCompleted
            : cardsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCards: null == totalCards
            ? _value.totalCards
            : totalCards // ignore: cast_nullable_to_non_nullable
                  as int,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLocked: null == isLocked
            ? _value.isLocked
            : isLocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        canReplay: null == canReplay
            ? _value.canReplay
            : canReplay // ignore: cast_nullable_to_non_nullable
                  as bool,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastPlayedAt: freezed == lastPlayedAt
            ? _value.lastPlayedAt
            : lastPlayedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeckProgressImpl extends _DeckProgress {
  const _$DeckProgressImpl({
    @JsonKey(name: 'relation_id') required this.relationId,
    @JsonKey(name: 'deck_id') required this.deckId,
    @JsonKey(name: 'cards_completed') required this.cardsCompleted,
    @JsonKey(name: 'total_cards') required this.totalCards,
    @JsonKey(name: 'is_completed') this.isCompleted = false,
    @JsonKey(name: 'is_locked') this.isLocked = false,
    @JsonKey(name: 'can_replay') this.canReplay = false,
    @JsonKey(name: 'completed_at') this.completedAt,
    @JsonKey(name: 'last_played_at') this.lastPlayedAt,
  }) : super._();

  factory _$DeckProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeckProgressImplFromJson(json);

  @override
  @JsonKey(name: 'relation_id')
  final String relationId;
  @override
  @JsonKey(name: 'deck_id')
  final String deckId;
  @override
  @JsonKey(name: 'cards_completed')
  final int cardsCompleted;
  @override
  @JsonKey(name: 'total_cards')
  final int totalCards;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'is_locked')
  final bool isLocked;
  @override
  @JsonKey(name: 'can_replay')
  final bool canReplay;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'last_played_at')
  final DateTime? lastPlayedAt;

  @override
  String toString() {
    return 'DeckProgress(relationId: $relationId, deckId: $deckId, cardsCompleted: $cardsCompleted, totalCards: $totalCards, isCompleted: $isCompleted, isLocked: $isLocked, canReplay: $canReplay, completedAt: $completedAt, lastPlayedAt: $lastPlayedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeckProgressImpl &&
            (identical(other.relationId, relationId) ||
                other.relationId == relationId) &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.cardsCompleted, cardsCompleted) ||
                other.cardsCompleted == cardsCompleted) &&
            (identical(other.totalCards, totalCards) ||
                other.totalCards == totalCards) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.canReplay, canReplay) ||
                other.canReplay == canReplay) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.lastPlayedAt, lastPlayedAt) ||
                other.lastPlayedAt == lastPlayedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    relationId,
    deckId,
    cardsCompleted,
    totalCards,
    isCompleted,
    isLocked,
    canReplay,
    completedAt,
    lastPlayedAt,
  );

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeckProgressImplCopyWith<_$DeckProgressImpl> get copyWith =>
      __$$DeckProgressImplCopyWithImpl<_$DeckProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeckProgressImplToJson(this);
  }
}

abstract class _DeckProgress extends DeckProgress {
  const factory _DeckProgress({
    @JsonKey(name: 'relation_id') required final String relationId,
    @JsonKey(name: 'deck_id') required final String deckId,
    @JsonKey(name: 'cards_completed') required final int cardsCompleted,
    @JsonKey(name: 'total_cards') required final int totalCards,
    @JsonKey(name: 'is_completed') final bool isCompleted,
    @JsonKey(name: 'is_locked') final bool isLocked,
    @JsonKey(name: 'can_replay') final bool canReplay,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    @JsonKey(name: 'last_played_at') final DateTime? lastPlayedAt,
  }) = _$DeckProgressImpl;
  const _DeckProgress._() : super._();

  factory _DeckProgress.fromJson(Map<String, dynamic> json) =
      _$DeckProgressImpl.fromJson;

  @override
  @JsonKey(name: 'relation_id')
  String get relationId;
  @override
  @JsonKey(name: 'deck_id')
  String get deckId;
  @override
  @JsonKey(name: 'cards_completed')
  int get cardsCompleted;
  @override
  @JsonKey(name: 'total_cards')
  int get totalCards;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  @JsonKey(name: 'is_locked')
  bool get isLocked;
  @override
  @JsonKey(name: 'can_replay')
  bool get canReplay;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'last_played_at')
  DateTime? get lastPlayedAt;

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeckProgressImplCopyWith<_$DeckProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
