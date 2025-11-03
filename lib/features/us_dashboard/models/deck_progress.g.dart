// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeckProgressImpl _$$DeckProgressImplFromJson(Map<String, dynamic> json) =>
    _$DeckProgressImpl(
      relationId: json['relation_id'] as String,
      deckId: json['deck_id'] as String,
      cardsCompleted: (json['cards_completed'] as num).toInt(),
      totalCards: (json['total_cards'] as num).toInt(),
      isCompleted: json['is_completed'] as bool? ?? false,
      isLocked: json['is_locked'] as bool? ?? false,
      canReplay: json['can_replay'] as bool? ?? false,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      lastPlayedAt: json['last_played_at'] == null
          ? null
          : DateTime.parse(json['last_played_at'] as String),
    );

Map<String, dynamic> _$$DeckProgressImplToJson(_$DeckProgressImpl instance) =>
    <String, dynamic>{
      'relation_id': instance.relationId,
      'deck_id': instance.deckId,
      'cards_completed': instance.cardsCompleted,
      'total_cards': instance.totalCards,
      'is_completed': instance.isCompleted,
      'is_locked': instance.isLocked,
      'can_replay': instance.canReplay,
      'completed_at': instance.completedAt?.toIso8601String(),
      'last_played_at': instance.lastPlayedAt?.toIso8601String(),
    };
