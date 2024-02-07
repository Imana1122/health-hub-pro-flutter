class UserProfile {
  String id;
  String userId;
  int height;
  int weight;
  int waist;
  int hips;
  int bust;
  int targetedWeight;
  int age;
  String gender;
  String weightPlanId;
  String createdAt;
  String updatedAt;

  UserProfile({
    required this.id,
    required this.userId,
    required this.height,
    required this.weight,
    required this.waist,
    required this.hips,
    required this.bust,
    required this.targetedWeight,
    required this.age,
    required this.gender,
    required this.weightPlanId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Named constructor with default values
  UserProfile.empty()
      : id = '',
        userId = '',
        height = 0,
        weight = 0,
        waist = 0,
        hips = 0,
        bust = 0,
        targetedWeight = 0,
        age = 0,
        gender = '',
        weightPlanId = '',
        createdAt = '',
        updatedAt = '';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      waist: json['waist'] ?? 0,
      hips: json['hips'] ?? 0,
      bust: json['bust'] ?? 0,
      targetedWeight: json['targeted_weight'] ?? 0,
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      weightPlanId: json['weight_plan_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Method to check if the UserProfile has values
  bool isEmpty() {
    return height == 0 &&
        weight == 0 &&
        waist == 0 &&
        hips == 0 &&
        bust == 0 &&
        targetedWeight == 0 &&
        age == 0 &&
        gender.isEmpty &&
        weightPlanId.isEmpty &&
        createdAt.isEmpty &&
        updatedAt.isEmpty;
  }
}
