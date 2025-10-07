// lib/features/me_dashboard/data/models/me_checkin_model.dart

class MeCheckin {
  final String id;
  final String userId;
  final DateTime timestamp;
  final int mood; // 1-5
  final String? trigger;
  final String? note;

  MeCheckin({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.mood,
    this.trigger,
    this.note,
  });

  factory MeCheckin.fromJson(Map<String, dynamic> json) {
    return MeCheckin(
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