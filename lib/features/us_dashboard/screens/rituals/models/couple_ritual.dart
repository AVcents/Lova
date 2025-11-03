import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_ritual.freezed.dart';
part 'couple_ritual.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
class CoupleRitual with _$CoupleRitual {
  const factory CoupleRitual({
    required String id,
    required String title,
    required String emoji,
    required String description,
    @JsonKey(name: 'default_duration') required int defaultDuration,
    @JsonKey(name: 'duration_options') required List<int> durationOptions,
    required String category,
    required String benefits,
    @JsonKey(name: 'instructions') required List<Map<String, dynamic>> instructions,
    required String tips,
    required int points,
    @Default(0) int timesCompleted,
    @Default(0) int currentStreak,
    @Default(false) bool isFavorite,
    @Default(false) bool isCustom,
    @JsonKey(name: 'is_premium') @Default(false) bool isPremium,
  }) = _CoupleRitual;

  factory CoupleRitual.fromJson(Map<String, dynamic> json) =>
      _$CoupleRitualFromJson(json);
}