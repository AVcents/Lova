// lib/features/me_dashboard/data/models/intention_progress_model.dart

class IntentionProgress {
  final String id;
  final String intentionId;
  final String userId;
  final DateTime timestamp;
  final DateTime progressDate;
  final int incrementValue;
  final String? note;
  final String source;
  final DateTime createdAt;

  IntentionProgress({
    required this.id,
    required this.intentionId,
    required this.userId,
    required this.timestamp,
    required this.progressDate,
    required this.incrementValue,
    this.note,
    required this.source,
    required this.createdAt,
  });

  factory IntentionProgress.fromJson(Map<String, dynamic> json) {
    return IntentionProgress(
      id: json['id'] as String,
      intentionId: json['intention_id'] as String,
      userId: json['user_id'] as String,
      timestamp: DateTime.parse(json['ts'] as String),
      progressDate: DateTime.parse(json['progress_date'] as String),
      incrementValue: json['increment_value'] as int,
      note: json['note'] as String?,
      source: json['source'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intention_id': intentionId,
      'user_id': userId,
      'ts': timestamp.toIso8601String(),
      'progress_date': progressDate.toIso8601String().split('T')[0],
      'increment_value': incrementValue,
      'note': note,
      'source': source,
    };
  }

  bool get isAutoTracked => source == 'auto_ritual';
  bool get isManual => source == 'manual';
}