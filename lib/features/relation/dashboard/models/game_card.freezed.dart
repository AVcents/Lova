// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameCard _$GameCardFromJson(Map<String, dynamic> json) {
  return _GameCard.fromJson(json);
}

/// @nodoc
mixin _$GameCard {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'deck_id')
  String get deckId => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_number')
  int get cardNumber => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_spicy')
  bool get isSpicy => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String? get tip => throw _privateConstructorUsedError;
  Map<String, dynamic>? get choices => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GameCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameCardCopyWith<GameCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCardCopyWith<$Res> {
  factory $GameCardCopyWith(GameCard value, $Res Function(GameCard) then) =
      _$GameCardCopyWithImpl<$Res, GameCard>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'deck_id') String deckId,
    @JsonKey(name: 'card_number') int cardNumber,
    String question,
    String category,
    String format,
    @JsonKey(name: 'is_spicy') bool isSpicy,
    String? subtitle,
    String? tip,
    Map<String, dynamic>? choices,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$GameCardCopyWithImpl<$Res, $Val extends GameCard>
    implements $GameCardCopyWith<$Res> {
  _$GameCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deckId = null,
    Object? cardNumber = null,
    Object? question = null,
    Object? category = null,
    Object? format = null,
    Object? isSpicy = null,
    Object? subtitle = freezed,
    Object? tip = freezed,
    Object? choices = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            deckId: null == deckId
                ? _value.deckId
                : deckId // ignore: cast_nullable_to_non_nullable
                      as String,
            cardNumber: null == cardNumber
                ? _value.cardNumber
                : cardNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            question: null == question
                ? _value.question
                : question // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as String,
            isSpicy: null == isSpicy
                ? _value.isSpicy
                : isSpicy // ignore: cast_nullable_to_non_nullable
                      as bool,
            subtitle: freezed == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            tip: freezed == tip
                ? _value.tip
                : tip // ignore: cast_nullable_to_non_nullable
                      as String?,
            choices: freezed == choices
                ? _value.choices
                : choices // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
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
abstract class _$$GameCardImplCopyWith<$Res>
    implements $GameCardCopyWith<$Res> {
  factory _$$GameCardImplCopyWith(
    _$GameCardImpl value,
    $Res Function(_$GameCardImpl) then,
  ) = __$$GameCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'deck_id') String deckId,
    @JsonKey(name: 'card_number') int cardNumber,
    String question,
    String category,
    String format,
    @JsonKey(name: 'is_spicy') bool isSpicy,
    String? subtitle,
    String? tip,
    Map<String, dynamic>? choices,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$GameCardImplCopyWithImpl<$Res>
    extends _$GameCardCopyWithImpl<$Res, _$GameCardImpl>
    implements _$$GameCardImplCopyWith<$Res> {
  __$$GameCardImplCopyWithImpl(
    _$GameCardImpl _value,
    $Res Function(_$GameCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deckId = null,
    Object? cardNumber = null,
    Object? question = null,
    Object? category = null,
    Object? format = null,
    Object? isSpicy = null,
    Object? subtitle = freezed,
    Object? tip = freezed,
    Object? choices = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$GameCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        deckId: null == deckId
            ? _value.deckId
            : deckId // ignore: cast_nullable_to_non_nullable
                  as String,
        cardNumber: null == cardNumber
            ? _value.cardNumber
            : cardNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        question: null == question
            ? _value.question
            : question // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as String,
        isSpicy: null == isSpicy
            ? _value.isSpicy
            : isSpicy // ignore: cast_nullable_to_non_nullable
                  as bool,
        subtitle: freezed == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        tip: freezed == tip
            ? _value.tip
            : tip // ignore: cast_nullable_to_non_nullable
                  as String?,
        choices: freezed == choices
            ? _value._choices
            : choices // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
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
class _$GameCardImpl implements _GameCard {
  const _$GameCardImpl({
    required this.id,
    @JsonKey(name: 'deck_id') required this.deckId,
    @JsonKey(name: 'card_number') required this.cardNumber,
    required this.question,
    required this.category,
    required this.format,
    @JsonKey(name: 'is_spicy') this.isSpicy = false,
    this.subtitle,
    this.tip,
    final Map<String, dynamic>? choices,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : _choices = choices;

  factory _$GameCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameCardImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'deck_id')
  final String deckId;
  @override
  @JsonKey(name: 'card_number')
  final int cardNumber;
  @override
  final String question;
  @override
  final String category;
  @override
  final String format;
  @override
  @JsonKey(name: 'is_spicy')
  final bool isSpicy;
  @override
  final String? subtitle;
  @override
  final String? tip;
  final Map<String, dynamic>? _choices;
  @override
  Map<String, dynamic>? get choices {
    final value = _choices;
    if (value == null) return null;
    if (_choices is EqualUnmodifiableMapView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'GameCard(id: $id, deckId: $deckId, cardNumber: $cardNumber, question: $question, category: $category, format: $format, isSpicy: $isSpicy, subtitle: $subtitle, tip: $tip, choices: $choices, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.cardNumber, cardNumber) ||
                other.cardNumber == cardNumber) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.isSpicy, isSpicy) || other.isSpicy == isSpicy) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.tip, tip) || other.tip == tip) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    deckId,
    cardNumber,
    question,
    category,
    format,
    isSpicy,
    subtitle,
    tip,
    const DeepCollectionEquality().hash(_choices),
    createdAt,
  );

  /// Create a copy of GameCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameCardImplCopyWith<_$GameCardImpl> get copyWith =>
      __$$GameCardImplCopyWithImpl<_$GameCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameCardImplToJson(this);
  }
}

abstract class _GameCard implements GameCard {
  const factory _GameCard({
    required final String id,
    @JsonKey(name: 'deck_id') required final String deckId,
    @JsonKey(name: 'card_number') required final int cardNumber,
    required final String question,
    required final String category,
    required final String format,
    @JsonKey(name: 'is_spicy') final bool isSpicy,
    final String? subtitle,
    final String? tip,
    final Map<String, dynamic>? choices,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$GameCardImpl;

  factory _GameCard.fromJson(Map<String, dynamic> json) =
      _$GameCardImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'deck_id')
  String get deckId;
  @override
  @JsonKey(name: 'card_number')
  int get cardNumber;
  @override
  String get question;
  @override
  String get category;
  @override
  String get format;
  @override
  @JsonKey(name: 'is_spicy')
  bool get isSpicy;
  @override
  String? get subtitle;
  @override
  String? get tip;
  @override
  Map<String, dynamic>? get choices;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of GameCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameCardImplCopyWith<_$GameCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
