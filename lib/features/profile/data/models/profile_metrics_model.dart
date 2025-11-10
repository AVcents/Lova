// ============================================
// lib/features/profile/data/models/profile_metrics_model.dart

class ProfileMetrics {
  final String id;
  final String userId;
  final DateTime weekStart;
  final int progressScore; // 0-100
  final Map<String, dynamic> breakdown;
  final DateTime updatedAt;

  ProfileMetrics({
    required this.id,
    required this.userId,
    required this.weekStart,
    required this.progressScore,
    required this.breakdown,
    required this.updatedAt,
  });

  factory ProfileMetrics.fromJson(Map<String, dynamic> json) {
    return ProfileMetrics(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      weekStart: DateTime.parse(json['week_start'] as String),
      progressScore: json['progress_score'] as int,
      breakdown: Map<String, dynamic>.from(json['breakdown'] as Map),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Helpers pour accéder au breakdown
  int get checkinsCount => breakdown['checkins'] as int? ?? 0;

  int get ritualsMinutes => breakdown['rituals_min'] as int? ?? 0;

  int get journalsCount => breakdown['journals'] as int? ?? 0;

  bool get streakActive => breakdown['streak_active'] as bool? ?? false;
}