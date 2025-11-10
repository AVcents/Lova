// lib/features/profile/data/models/profile_checkin_model.dart

class ProfileCheckin {
  final String id;
  final String userId;
  final DateTime timestamp;
  final int mood; // 1-5
  final String? trigger;
  final String? note;

  ProfileCheckin({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.mood,
    this.trigger,
    this.note,
  });

  factory ProfileCheckin.fromJson(Map<String, dynamic> json) {
    return ProfileCheckin(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      timestamp: DateTime.parse(json['ts'] as String),
      mood: json['mood'] as int,
      trigger: json['trigger'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mood': mood,
      'trigger': trigger,
      'note': note,
    };
  }
}