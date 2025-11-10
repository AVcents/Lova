// lib/features/profile/data/models/intention_reflection_model.dart

class IntentionReflection {
  final String id;
  final String userId;
  final int year;
  final int month;
  final String? whatWorked;
  final String? whatStruggled;
  final String? learnings;
  final String? nextFocus;
  final int? overallSatisfaction;
  final DateTime createdAt;
  final DateTime updatedAt;

  IntentionReflection({
    required this.id,
    required this.userId,
    required this.year,
    required this.month,
    this.whatWorked,
    this.whatStruggled,
    this.learnings,
    this.nextFocus,
    this.overallSatisfaction,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IntentionReflection.fromJson(Map<String, dynamic> json) {
    return IntentionReflection(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      year: json['year'] as int,
      month: json['month'] as int,
      whatWorked: json['what_worked'] as String?,
      whatStruggled: json['what_struggled'] as String?,
      learnings: json['learnings'] as String?,
      nextFocus: json['next_focus'] as String?,
      overallSatisfaction: json['overall_satisfaction'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'year': year,
      'month': month,
      'what_worked': whatWorked,
      'what_struggled': whatStruggled,
      'learnings': learnings,
      'next_focus': nextFocus,
      'overall_satisfaction': overallSatisfaction,
    };
  }

  bool get isComplete {
    return whatWorked != null &&
        whatStruggled != null &&
        learnings != null &&
        nextFocus != null &&
        overallSatisfaction != null;
  }

  IntentionReflection copyWith({
    String? id,
    String? userId,
    int? year,
    int? month,
    String? whatWorked,
    String? whatStruggled,
    String? learnings,
    String? nextFocus,
    int? overallSatisfaction,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IntentionReflection(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      year: year ?? this.year,
      month: month ?? this.month,
      whatWorked: whatWorked ?? this.whatWorked,
      whatStruggled: whatStruggled ?? this.whatStruggled,
      learnings: learnings ?? this.learnings,
      nextFocus: nextFocus ?? this.nextFocus,
      overallSatisfaction: overallSatisfaction ?? this.overallSatisfaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}