// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intimacy_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IntimacyQuestion _$IntimacyQuestionFromJson(Map<String, dynamic> json) {
  return _IntimacyQuestion.fromJson(json);
}

/// @nodoc
mixin _$IntimacyQuestion {
  String get id => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  QuestionFormat get format => throw _privateConstructorUsedError;
  QuestionCategory get category => throw _privateConstructorUsedError;
  String? get subtitle =>
      throw _privateConstructorUsedError; // Sous-texte explicatif
  List<String>? get choices =>
      throw _privateConstructorUsedError; // Pour les choix multiples
  String? get tip =>
      throw _privateConstructorUsedError; // Conseil pour répondre
  bool get isSpicy => throw _privateConstructorUsedError;

  /// Serializes this IntimacyQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IntimacyQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IntimacyQuestionCopyWith<IntimacyQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntimacyQuestionCopyWith<$Res> {
  factory $IntimacyQuestionCopyWith(
    IntimacyQuestion value,
    $Res Function(IntimacyQuestion) then,
  ) = _$IntimacyQuestionCopyWithImpl<$Res, IntimacyQuestion>;
  @useResult
  $Res call({
    String id,
    String question,
    QuestionFormat format,
    QuestionCategory category,
    String? subtitle,
    List<String>? choices,
    String? tip,
    bool isSpicy,
  });
}

/// @nodoc
class _$IntimacyQuestionCopyWithImpl<$Res, $Val extends IntimacyQuestion>
    implements $IntimacyQuestionCopyWith<$Res> {
  _$IntimacyQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IntimacyQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? format = null,
    Object? category = null,
    Object? subtitle = freezed,
    Object? choices = freezed,
    Object? tip = freezed,
    Object? isSpicy = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            question: null == question
                ? _value.question
                : question // ignore: cast_nullable_to_non_nullable
                      as String,
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as QuestionFormat,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as QuestionCategory,
            subtitle: freezed == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            choices: freezed == choices
                ? _value.choices
                : choices // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            tip: freezed == tip
                ? _value.tip
                : tip // ignore: cast_nullable_to_non_nullable
                      as String?,
            isSpicy: null == isSpicy
                ? _value.isSpicy
                : isSpicy // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IntimacyQuestionImplCopyWith<$Res>
    implements $IntimacyQuestionCopyWith<$Res> {
  factory _$$IntimacyQuestionImplCopyWith(
    _$IntimacyQuestionImpl value,
    $Res Function(_$IntimacyQuestionImpl) then,
  ) = __$$IntimacyQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String question,
    QuestionFormat format,
    QuestionCategory category,
    String? subtitle,
    List<String>? choices,
    String? tip,
    bool isSpicy,
  });
}

/// @nodoc
class __$$IntimacyQuestionImplCopyWithImpl<$Res>
    extends _$IntimacyQuestionCopyWithImpl<$Res, _$IntimacyQuestionImpl>
    implements _$$IntimacyQuestionImplCopyWith<$Res> {
  __$$IntimacyQuestionImplCopyWithImpl(
    _$IntimacyQuestionImpl _value,
    $Res Function(_$IntimacyQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IntimacyQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? format = null,
    Object? category = null,
    Object? subtitle = freezed,
    Object? choices = freezed,
    Object? tip = freezed,
    Object? isSpicy = null,
  }) {
    return _then(
      _$IntimacyQuestionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        question: null == question
            ? _value.question
            : question // ignore: cast_nullable_to_non_nullable
                  as String,
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as QuestionFormat,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as QuestionCategory,
        subtitle: freezed == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        choices: freezed == choices
            ? _value._choices
            : choices // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        tip: freezed == tip
            ? _value.tip
            : tip // ignore: cast_nullable_to_non_nullable
                  as String?,
        isSpicy: null == isSpicy
            ? _value.isSpicy
            : isSpicy // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IntimacyQuestionImpl implements _IntimacyQuestion {
  const _$IntimacyQuestionImpl({
    required this.id,
    required this.question,
    required this.format,
    required this.category,
    this.subtitle,
    final List<String>? choices,
    this.tip,
    this.isSpicy = false,
  }) : _choices = choices;

  factory _$IntimacyQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntimacyQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String question;
  @override
  final QuestionFormat format;
  @override
  final QuestionCategory category;
  @override
  final String? subtitle;
  // Sous-texte explicatif
  final List<String>? _choices;
  // Sous-texte explicatif
  @override
  List<String>? get choices {
    final value = _choices;
    if (value == null) return null;
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // Pour les choix multiples
  @override
  final String? tip;
  // Conseil pour répondre
  @override
  @JsonKey()
  final bool isSpicy;

  @override
  String toString() {
    return 'IntimacyQuestion(id: $id, question: $question, format: $format, category: $category, subtitle: $subtitle, choices: $choices, tip: $tip, isSpicy: $isSpicy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntimacyQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.tip, tip) || other.tip == tip) &&
            (identical(other.isSpicy, isSpicy) || other.isSpicy == isSpicy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    question,
    format,
    category,
    subtitle,
    const DeepCollectionEquality().hash(_choices),
    tip,
    isSpicy,
  );

  /// Create a copy of IntimacyQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IntimacyQuestionImplCopyWith<_$IntimacyQuestionImpl> get copyWith =>
      __$$IntimacyQuestionImplCopyWithImpl<_$IntimacyQuestionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IntimacyQuestionImplToJson(this);
  }
}

abstract class _IntimacyQuestion implements IntimacyQuestion {
  const factory _IntimacyQuestion({
    required final String id,
    required final String question,
    required final QuestionFormat format,
    required final QuestionCategory category,
    final String? subtitle,
    final List<String>? choices,
    final String? tip,
    final bool isSpicy,
  }) = _$IntimacyQuestionImpl;

  factory _IntimacyQuestion.fromJson(Map<String, dynamic> json) =
      _$IntimacyQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get question;
  @override
  QuestionFormat get format;
  @override
  QuestionCategory get category;
  @override
  String? get subtitle; // Sous-texte explicatif
  @override
  List<String>? get choices; // Pour les choix multiples
  @override
  String? get tip; // Conseil pour répondre
  @override
  bool get isSpicy;

  /// Create a copy of IntimacyQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IntimacyQuestionImplCopyWith<_$IntimacyQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
