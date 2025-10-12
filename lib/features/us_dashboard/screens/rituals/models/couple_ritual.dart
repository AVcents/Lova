import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_ritual.freezed.dart';
part 'couple_ritual.g.dart';

@freezed
class CoupleRitual with _$CoupleRitual {
  const factory CoupleRitual({
    required String id,
    required String title,
    required String emoji,
    required String description,
    required int defaultDuration,
    required List<int> durationOptions,
    required String category,
    required String benefits,
    required String instructions,
    required String tips,
    required int points,
    @Default(0) int timesCompleted,
    @Default(0) int currentStreak,
    @Default(false) bool isFavorite,
    @Default(false) bool isCustom,
    @Default(false) bool isPremium,
  }) = _CoupleRitual;

  factory CoupleRitual.fromJson(Map<String, dynamic> json) =>
      _$CoupleRitualFromJson(json);
}