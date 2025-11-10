// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_card_deck.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameCardDeck _$GameCardDeckFromJson(Map<String, dynamic> json) {
  return _GameCardDeck.fromJson(json);
}

/// @nodoc
mixin _$GameCardDeck {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'game_id')
  String get gameId => throw _privateConstructorUsedError;
  @JsonKey(name: 'deck_name')
  String get deckName => throw _privateConstructorUsedError;
  @JsonKey(name: 'deck_description')
  String get deckDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'deck_emoji')
  String get deckEmoji => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_count')
  int get cardCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_euros')
  double get priceEuros => throw _privateConstructorUsedError;
  @JsonKey(name: 'unlock_price_euros')
  double get unlockPriceEuros => throw _privateConstructorUsedError;
  @JsonKey(name: 'difficulty_level')
  DeckDifficulty get difficultyLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_free')
  bool get isFree => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  DeckStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'preview_questions')
  List<String>? get previewQuestions => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GameCardDeck to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameCardDeck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameCardDeckCopyWith<GameCardDeck> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCardDeckCopyWith<$Res> {
  factory $GameCardDeckCopyWith(
    GameCardDeck value,
    $Res Function(GameCardDeck) then,
  ) = _$GameCardDeckCopyWithImpl<$Res, GameCardDeck>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'game_id') String gameId,
    @JsonKey(name: 'deck_name') String deckName,
    @JsonKey(name: 'deck_description') String deckDescription,
    @JsonKey(name: 'deck_emoji') String deckEmoji,
    @JsonKey(name: 'card_count') int cardCount,
    @JsonKey(name: 'price_euros') double priceEuros,
    @JsonKey(name: 'unlock_price_euros') double unlockPriceEuros,
    @JsonKey(name: 'difficulty_level') DeckDifficulty difficultyLevel,
    @JsonKey(name: 'is_free') bool isFree,
    @JsonKey(name: 'sort_order') int sortOrder,
    DeckStatus status,
    @JsonKey(name: 'preview_questions') List<String>? previewQuestions,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$GameCardDeckCopyWithImpl<$Res, $Val extends GameCardDeck>
    implements $GameCardDeckCopyWith<$Res> {
  _$GameCardDeckCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameCardDeck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? deckName = null,
    Object? deckDescription = null,
    Object? deckEmoji = null,
    Object? cardCount = null,
    Object? priceEuros = null,
    Object? unlockPriceEuros = null,
    Object? difficultyLevel = null,
    Object? isFree = null,
    Object? sortOrder = null,
    Object? status = null,
    Object? previewQuestions = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            gameId: null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                      as String,
            deckName: null == deckName
                ? _value.deckName
                : deckName // ignore: cast_nullable_to_non_nullable
                      as String,
            deckDescription: null == deckDescription
                ? _value.deckDescription
                : deckDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            deckEmoji: null == deckEmoji
                ? _value.deckEmoji
                : deckEmoji // ignore: cast_nullable_to_non_nullable
                      as String,
            cardCount: null == cardCount
                ? _value.cardCount
                : cardCount // ignore: cast_nullable_to_non_nullable
                      as int,
            priceEuros: null == priceEuros
                ? _value.priceEuros
                : priceEuros // ignore: cast_nullable_to_non_nullable
                      as double,
            unlockPriceEuros: null == unlockPriceEuros
                ? _value.unlockPriceEuros
                : unlockPriceEuros // ignore: cast_nullable_to_non_nullable
                      as double,
            difficultyLevel: null == difficultyLevel
                ? _value.difficultyLevel
                : difficultyLevel // ignore: cast_nullable_to_non_nullable
                      as DeckDifficulty,
            isFree: null == isFree
                ? _value.isFree
                : isFree // ignore: cast_nullable_to_non_nullable
                      as bool,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DeckStatus,
            previewQuestions: freezed == previewQuestions
                ? _value.previewQuestions
                : previewQuestions // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
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
abstract class _$$GameCardDeckImplCopyWith<$Res>
    implements $GameCardDeckCopyWith<$Res> {
  factory _$$GameCardDeckImplCopyWith(
    _$GameCardDeckImpl value,
    $Res Function(_$GameCardDeckImpl) then,
  ) = __$$GameCardDeckImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'game_id') String gameId,
    @JsonKey(name: 'deck_name') String deckName,
    @JsonKey(name: 'deck_description') String deckDescription,
    @JsonKey(name: 'deck_emoji') String deckEmoji,
    @JsonKey(name: 'card_count') int cardCount,
    @JsonKey(name: 'price_euros') double priceEuros,
    @JsonKey(name: 'unlock_price_euros') double unlockPriceEuros,
    @JsonKey(name: 'difficulty_level') DeckDifficulty difficultyLevel,
    @JsonKey(name: 'is_free') bool isFree,
    @JsonKey(name: 'sort_order') int sortOrder,
    DeckStatus status,
    @JsonKey(name: 'preview_questions') List<String>? previewQuestions,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$GameCardDeckImplCopyWithImpl<$Res>
    extends _$GameCardDeckCopyWithImpl<$Res, _$GameCardDeckImpl>
    implements _$$GameCardDeckImplCopyWith<$Res> {
  __$$GameCardDeckImplCopyWithImpl(
    _$GameCardDeckImpl _value,
    $Res Function(_$GameCardDeckImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameCardDeck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? deckName = null,
    Object? deckDescription = null,
    Object? deckEmoji = null,
    Object? cardCount = null,
    Object? priceEuros = null,
    Object? unlockPriceEuros = null,
    Object? difficultyLevel = null,
    Object? isFree = null,
    Object? sortOrder = null,
    Object? status = null,
    Object? previewQuestions = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$GameCardDeckImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        deckName: null == deckName
            ? _value.deckName
            : deckName // ignore: cast_nullable_to_non_nullable
                  as String,
        deckDescription: null == deckDescription
            ? _value.deckDescription
            : deckDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        deckEmoji: null == deckEmoji
            ? _value.deckEmoji
            : deckEmoji // ignore: cast_nullable_to_non_nullable
                  as String,
        cardCount: null == cardCount
            ? _value.cardCount
            : cardCount // ignore: cast_nullable_to_non_nullable
                  as int,
        priceEuros: null == priceEuros
            ? _value.priceEuros
            : priceEuros // ignore: cast_nullable_to_non_nullable
                  as double,
        unlockPriceEuros: null == unlockPriceEuros
            ? _value.unlockPriceEuros
            : unlockPriceEuros // ignore: cast_nullable_to_non_nullable
                  as double,
        difficultyLevel: null == difficultyLevel
            ? _value.difficultyLevel
            : difficultyLevel // ignore: cast_nullable_to_non_nullable
                  as DeckDifficulty,
        isFree: null == isFree
            ? _value.isFree
            : isFree // ignore: cast_nullable_to_non_nullable
                  as bool,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DeckStatus,
        previewQuestions: freezed == previewQuestions
            ? _value._previewQuestions
            : previewQuestions // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
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
class _$GameCardDeckImpl implements _GameCardDeck {
  const _$GameCardDeckImpl({
    required this.id,
    @JsonKey(name: 'game_id') required this.gameId,
    @JsonKey(name: 'deck_name') required this.deckName,
    @JsonKey(name: 'deck_description') required this.deckDescription,
    @JsonKey(name: 'deck_emoji') required this.deckEmoji,
    @JsonKey(name: 'card_count') required this.cardCount,
    @JsonKey(name: 'price_euros') required this.priceEuros,
    @JsonKey(name: 'unlock_price_euros') required this.unlockPriceEuros,
    @JsonKey(name: 'difficulty_level') required this.difficultyLevel,
    @JsonKey(name: 'is_free') required this.isFree,
    @JsonKey(name: 'sort_order') required this.sortOrder,
    required this.status,
    @JsonKey(name: 'preview_questions') final List<String>? previewQuestions,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : _previewQuestions = previewQuestions;

  factory _$GameCardDeckImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameCardDeckImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'game_id')
  final String gameId;
  @override
  @JsonKey(name: 'deck_name')
  final String deckName;
  @override
  @JsonKey(name: 'deck_description')
  final String deckDescription;
  @override
  @JsonKey(name: 'deck_emoji')
  final String deckEmoji;
  @override
  @JsonKey(name: 'card_count')
  final int cardCount;
  @override
  @JsonKey(name: 'price_euros')
  final double priceEuros;
  @override
  @JsonKey(name: 'unlock_price_euros')
  final double unlockPriceEuros;
  @override
  @JsonKey(name: 'difficulty_level')
  final DeckDifficulty difficultyLevel;
  @override
  @JsonKey(name: 'is_free')
  final bool isFree;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  final DeckStatus status;
  final List<String>? _previewQuestions;
  @override
  @JsonKey(name: 'preview_questions')
  List<String>? get previewQuestions {
    final value = _previewQuestions;
    if (value == null) return null;
    if (_previewQuestions is EqualUnmodifiableListView)
      return _previewQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'GameCardDeck(id: $id, gameId: $gameId, deckName: $deckName, deckDescription: $deckDescription, deckEmoji: $deckEmoji, cardCount: $cardCount, priceEuros: $priceEuros, unlockPriceEuros: $unlockPriceEuros, difficultyLevel: $difficultyLevel, isFree: $isFree, sortOrder: $sortOrder, status: $status, previewQuestions: $previewQuestions, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameCardDeckImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.deckName, deckName) ||
                other.deckName == deckName) &&
            (identical(other.deckDescription, deckDescription) ||
                other.deckDescription == deckDescription) &&
            (identical(other.deckEmoji, deckEmoji) ||
                other.deckEmoji == deckEmoji) &&
            (identical(other.cardCount, cardCount) ||
                other.cardCount == cardCount) &&
            (identical(other.priceEuros, priceEuros) ||
                other.priceEuros == priceEuros) &&
            (identical(other.unlockPriceEuros, unlockPriceEuros) ||
                other.unlockPriceEuros == unlockPriceEuros) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._previewQuestions,
              _previewQuestions,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    gameId,
    deckName,
    deckDescription,
    deckEmoji,
    cardCount,
    priceEuros,
    unlockPriceEuros,
    difficultyLevel,
    isFree,
    sortOrder,
    status,
    const DeepCollectionEquality().hash(_previewQuestions),
    createdAt,
  );

  /// Create a copy of GameCardDeck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameCardDeckImplCopyWith<_$GameCardDeckImpl> get copyWith =>
      __$$GameCardDeckImplCopyWithImpl<_$GameCardDeckImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameCardDeckImplToJson(this);
  }
}

abstract class _GameCardDeck implements GameCardDeck {
  const factory _GameCardDeck({
    required final String id,
    @JsonKey(name: 'game_id') required final String gameId,
    @JsonKey(name: 'deck_name') required final String deckName,
    @JsonKey(name: 'deck_description') required final String deckDescription,
    @JsonKey(name: 'deck_emoji') required final String deckEmoji,
    @JsonKey(name: 'card_count') required final int cardCount,
    @JsonKey(name: 'price_euros') required final double priceEuros,
    @JsonKey(name: 'unlock_price_euros') required final double unlockPriceEuros,
    @JsonKey(name: 'difficulty_level')
    required final DeckDifficulty difficultyLevel,
    @JsonKey(name: 'is_free') required final bool isFree,
    @JsonKey(name: 'sort_order') required final int sortOrder,
    required final DeckStatus status,
    @JsonKey(name: 'preview_questions') final List<String>? previewQuestions,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$GameCardDeckImpl;

  factory _GameCardDeck.fromJson(Map<String, dynamic> json) =
      _$GameCardDeckImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'game_id')
  String get gameId;
  @override
  @JsonKey(name: 'deck_name')
  String get deckName;
  @override
  @JsonKey(name: 'deck_description')
  String get deckDescription;
  @override
  @JsonKey(name: 'deck_emoji')
  String get deckEmoji;
  @override
  @JsonKey(name: 'card_count')
  int get cardCount;
  @override
  @JsonKey(name: 'price_euros')
  double get priceEuros;
  @override
  @JsonKey(name: 'unlock_price_euros')
  double get unlockPriceEuros;
  @override
  @JsonKey(name: 'difficulty_level')
  DeckDifficulty get difficultyLevel;
  @override
  @JsonKey(name: 'is_free')
  bool get isFree;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  DeckStatus get status;
  @override
  @JsonKey(name: 'preview_questions')
  List<String>? get previewQuestions;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of GameCardDeck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameCardDeckImplCopyWith<_$GameCardDeckImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
