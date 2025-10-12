// lib/features/me_dashboard/data/models/life_intention_model.dart

enum IntentionType {
  monthly,
  seasonal,
  ongoing;

  String get label {
    switch (this) {
      case IntentionType.monthly:
        return 'Ce mois';
      case IntentionType.seasonal:
        return 'Cette saison';
      case IntentionType.ongoing:
        return 'Sans limite';
    }
  }

  String get description {
    switch (this) {
      case IntentionType.monthly:
        return 'Jusqu\'à la fin du mois';
      case IntentionType.seasonal:
        return '3 mois';
      case IntentionType.ongoing:
        return 'Aussi longtemps que nécessaire';
    }
  }
}

enum IntentionStatus {
  active,
  completed,
  paused,
  archived;

  String get label {
    switch (this) {
      case IntentionStatus.active:
        return 'En cours';
      case IntentionStatus.completed:
        return 'Complétée';
      case IntentionStatus.paused:
        return 'En pause';
      case IntentionStatus.archived:
        return 'Archivée';
    }
  }
}

enum IntentionCategory {
  mental,
  physical,
  social,
  creative,
  spiritual;

  String get label {
    switch (this) {
      case IntentionCategory.mental:
        return 'Mental';
      case IntentionCategory.physical:
        return 'Physique';
      case IntentionCategory.social:
        return 'Social';
      case IntentionCategory.creative:
        return 'Créatif';
      case IntentionCategory.spiritual:
        return 'Spirituel';
    }
  }

  String get emoji {
    switch (this) {
      case IntentionCategory.mental:
        return '🧠';
      case IntentionCategory.physical:
        return '💪';
      case IntentionCategory.social:
        return '👥';
      case IntentionCategory.creative:
        return '🎨';
      case IntentionCategory.spiritual:
        return '🙏';
    }
  }
}

class LifeIntention {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final IntentionCategory category;
  final String? iconName;
  final IntentionType type;
  final DateTime startDate;
  final DateTime? endDate;
  final IntentionStatus status;
  final bool isTrackable;
  final int? targetValue;
  final int currentValue;
  final String? unit;
  final String? frequency;
  final List<String> linkedRitualTypes;
  final bool autoTrack;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  LifeIntention({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.category,
    this.iconName,
    required this.type,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.isTrackable,
    this.targetValue,
    required this.currentValue,
    this.unit,
    this.frequency,
    required this.linkedRitualTypes,
    required this.autoTrack,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory LifeIntention.fromJson(Map<String, dynamic> json) {
    return LifeIntention(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: IntentionCategory.values.firstWhere(
            (e) => e.name == json['category'],
      ),
      iconName: json['icon_name'] as String?,
      type: IntentionType.values.firstWhere(
            (e) => e.name == json['type'],
      ),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      status: IntentionStatus.values.firstWhere(
            (e) => e.name == json['status'],
      ),
      isTrackable: json['is_trackable'] as bool? ?? false,
      targetValue: json['target_value'] as int?,
      currentValue: json['current_value'] as int? ?? 0,
      unit: json['unit'] as String?,
      frequency: json['frequency'] as String?,
      linkedRitualTypes: (json['linked_ritual_types'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      autoTrack: json['auto_track'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      // ❌ NE PAS inclure user_id ici (le repository le gère)
      // 'user_id': userId,
      'title': title,
      'category': category.name,
      'type': type.name,
      'start_date': startDate.toIso8601String().split('T')[0],
      'status': status.name,
      'is_trackable': isTrackable,
      'current_value': currentValue,
      'auto_track': autoTrack,
    };

    // ... reste du code inchangé
    if (description != null) json['description'] = description;
    if (iconName != null) json['icon_name'] = iconName;
    if (endDate != null) json['end_date'] = endDate!.toIso8601String().split('T')[0];
    if (targetValue != null) json['target_value'] = targetValue;
    if (unit != null) json['unit'] = unit;
    if (frequency != null) json['frequency'] = frequency;

    if (linkedRitualTypes.isNotEmpty) {
      json['linked_ritual_types'] = linkedRitualTypes;
    }

    return json;
  }

  // Helpers
  double get progressPercentage {
    if (!isTrackable || targetValue == null || targetValue == 0) return 0.0;
    return (currentValue / targetValue!).clamp(0.0, 1.0);
  }

  int? get daysRemaining {
    if (endDate == null) return null;
    return endDate!.difference(DateTime.now()).inDays;
  }

  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  bool get isCompleted => status == IntentionStatus.completed;

  String get progressText {
    if (!isTrackable) return '';
    return '$currentValue${targetValue != null ? '/$targetValue' : ''} ${unit ?? ''}';
  }

  LifeIntention copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    IntentionCategory? category,
    String? iconName,
    IntentionType? type,
    DateTime? startDate,
    DateTime? endDate,
    IntentionStatus? status,
    bool? isTrackable,
    int? targetValue,
    int? currentValue,
    String? unit,
    String? frequency,
    List<String>? linkedRitualTypes,
    bool? autoTrack,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return LifeIntention(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      isTrackable: isTrackable ?? this.isTrackable,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      frequency: frequency ?? this.frequency,
      linkedRitualTypes: linkedRitualTypes ?? this.linkedRitualTypes,
      autoTrack: autoTrack ?? this.autoTrack,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}