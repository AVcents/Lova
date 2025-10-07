// ============================================
// lib/features/me_dashboard/data/models/me_streak_model.dart

class MeStreak {
  final String userId;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastActivityDate;
  final DateTime updatedAt;

  MeStreak({
    required this.userId,
    required this.currentStreak,
    required this.bestStreak,
    this.lastActivityDate,
    required this.updatedAt,
  });

  factory MeStreak.fromJson(Map<String, dynamic> json) {
    return MeStreak(
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
