// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameCardImpl _$$GameCardImplFromJson(Map<String, dynamic> json) =>
    _$GameCardImpl(
      id: json['id'] as String,
      deckId: json['deck_id'] as String,
      cardNumber: (json['card_number'] as num).toInt(),
      question: json['question'] as String,
      category: json['category'] as String,
      format: json['format'] as String,
      isSpicy: json['is_spicy'] as bool? ?? false,
      subtitle: json['subtitle'] as String?,
      tip: json['tip'] as String?,
      choices: json['choices'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$GameCardImplToJson(_$GameCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deck_id': instance.deckId,
      'card_number': instance.cardNumber,
      'question': instance.question,
      'category': instance.category,
      'format': instance.format,
      'is_spicy': instance.isSpicy,
      'subtitle': instance.subtitle,
      'tip': instance.tip,
      'choices': instance.choices,
      'created_at': instance.createdAt?.toIso8601String(),
    };
