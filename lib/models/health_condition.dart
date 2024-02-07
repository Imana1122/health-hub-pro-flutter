class HealthCondition {
  late String id;
  late String name;
  late String slug;
  late int status;
  late DateTime createdAt;
  late DateTime updatedAt;
  late Pivot pivot;

  HealthCondition({
    required this.id,
    required this.name,
    required this.slug,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  // Add a factory method to convert a map to HealthCondition object
  factory HealthCondition.fromJson(Map<String, dynamic> json) {
    return HealthCondition(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pivot: Pivot.fromJson(json['pivot']),
    );
  }
}

class Pivot {
  late String userId;
  late String healthConditionId;
  late int status;
  late DateTime createdAt;
  late DateTime updatedAt;

  Pivot({
    required this.userId,
    required this.healthConditionId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Add a factory method to convert a map to Pivot object
  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      userId: json['user_id'],
      healthConditionId: json['health_condition_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
