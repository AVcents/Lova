// ============================================
// lib/features/profile/data/models/profile_streak_model.dart

class ProfileStreak {
  final String userId;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastActivityDate;
  final DateTime updatedAt;

  ProfileStreak({
    required this.userId,
    required this.currentStreak,
    required this.bestStreak,
    this.lastActivityDate,
    required this.updatedAt,
  });

  factory ProfileStreak.fromJson(Map<String, dynamic> json) {
    return ProfileStreak(
      userId: json['user_id'] as String,
      currentStreak: json['current_streak'] as int,
      bestStreak: json['best_streak'] as int,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.parse(json['last_activity_date'] as String)
          : null,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
