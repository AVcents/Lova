// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intimacy_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IntimacyQuestionImpl _$$IntimacyQuestionImplFromJson(
  Map<String, dynamic> json,
) => _$IntimacyQuestionImpl(
  id: json['id'] as String,
  question: json['question'] as String,
  format: $enumDecode(_$QuestionFormatEnumMap, json['format']),
  category: $enumDecode(_$QuestionCategoryEnumMap, json['category']),
  subtitle: json['subtitle'] as String?,
  choices: (json['choices'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  tip: json['tip'] as String?,
  isSpicy: json['isSpicy'] as bool? ?? false,
);

Map<String, dynamic> _$$IntimacyQuestionImplToJson(
  _$IntimacyQuestionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'format': _$QuestionFormatEnumMap[instance.format]!,
  'category': _$QuestionCategoryEnumMap[instance.category]!,
  'subtitle': instance.subtitle,
  'choices': instance.choices,
  'tip': instance.tip,
  'isSpicy': instance.isSpicy,
};

const _$QuestionFormatEnumMap = {
  QuestionFormat.openEnded: 'openEnded',
  QuestionFormat.yesNo: 'yesNo',
  QuestionFormat.scale: 'scale',
  QuestionFormat.choice: 'choice',
  QuestionFormat.both: 'both',
};

const _$QuestionCategoryEnumMap = {
  QuestionCategory.intimacy: 'intimacy',
  QuestionCategory.emotional: 'emotional',
  QuestionCategory.fantasy: 'fantasy',
  QuestionCategory.past: 'past',
  QuestionCategory.future: 'future',
  QuestionCategory.preferences: 'preferences',
};
