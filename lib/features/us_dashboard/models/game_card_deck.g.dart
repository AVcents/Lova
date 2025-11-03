// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_card_deck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameCardDeckImpl _$$GameCardDeckImplFromJson(Map<String, dynamic> json) =>
    _$GameCardDeckImpl(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      deckName: json['deck_name'] as String,
      deckDescription: json['deck_description'] as String,
      deckEmoji: json['deck_emoji'] as String,
      cardCount: (json['card_count'] as num).toInt(),
      priceEuros: (json['price_euros'] as num).toDouble(),
      unlockPriceEuros: (json['unlock_price_euros'] as num).toDouble(),
      difficultyLevel: $enumDecode(
        _$DeckDifficultyEnumMap,
        json['difficulty_level'],
      ),
      isFree: json['is_free'] as bool,
      sortOrder: (json['sort_order'] as num).toInt(),
      status: $enumDecode(_$DeckStatusEnumMap, json['status']),
      previewQuestions: (json['preview_questions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$GameCardDeckImplToJson(_$GameCardDeckImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'game_id': instance.gameId,
      'deck_name': instance.deckName,
      'deck_description': instance.deckDescription,
      'deck_emoji': instance.deckEmoji,
      'card_count': instance.cardCount,
      'price_euros': instance.priceEuros,
      'unlock_price_euros': instance.unlockPriceEuros,
      'difficulty_level': _$DeckDifficultyEnumMap[instance.difficultyLevel]!,
      'is_free': instance.isFree,
      'sort_order': instance.sortOrder,
      'status': _$DeckStatusEnumMap[instance.status]!,
      'preview_questions': instance.previewQuestions,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$DeckDifficultyEnumMap = {
  DeckDifficulty.beginner: 'beginner',
  DeckDifficulty.intermediate: 'intermediate',
  DeckDifficulty.advanced: 'advanced',
  DeckDifficulty.spicy: 'spicy',
};

const _$DeckStatusEnumMap = {
  DeckStatus.available: 'available',
  DeckStatus.comingSoon: 'comingSoon',
};
