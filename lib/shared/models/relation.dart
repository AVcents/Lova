class Relation {
  final String id;
  final String status;
  final String? relationMode;
  final DateTime createdAt;
  final DateTime updatedAt;

  Relation({
    required this.id,
    required this.status,
    this.relationMode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Relation.fromJson(Map<String, dynamic> json) {
    return Relation(
      id: json['id'],
      status: json['status'],
      relationMode: json['relation_mode'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}