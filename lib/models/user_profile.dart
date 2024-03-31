class UserProfile {
  String id;
  String userId;
  int height;
  int weight;
  int waist;
  int hips;
  int bust;
  int targetedWeight;
  double calorieDifference;

  int age;
  String gender;
  String weightPlanId;
  String createdAt;
  String updatedAt;
  String activityLevel;
  double calories;
  double carbohydrates;
  double protein;
  double totalFat;
  double sodium;
  double sugar;
  double bmi;
  int notification;

  UserProfile({
    required this.id,
    required this.userId,
    required this.height,
    required this.weight,
    required this.waist,
    required this.hips,
    required this.bust,
    required this.targetedWeight,
    required this.calorieDifference,
    required this.age,
    required this.gender,
    required this.weightPlanId,
    required this.createdAt,
    required this.updatedAt,
    required this.activityLevel,
    required this.calories,
    required this.carbohydrates,
    required this.protein,
    required this.totalFat,
    required this.sodium,
    required this.sugar,
    required this.bmi,
    required this.notification,
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
        calorieDifference = 0,
        age = 0,
        gender = '',
        weightPlanId = '',
        createdAt = '',
        updatedAt = '',
        activityLevel = '',
        calories = 0,
        carbohydrates = 0,
        protein = 0,
        totalFat = 0,
        sodium = 0,
        sugar = 0,
        bmi = 0,
        notification = 1;

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
      calorieDifference:
          (json['calorie_difference'] ?? 0).toDouble(), // Handle null value
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      weightPlanId: json['weight_plan_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      activityLevel: json['activity_level'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(), // Handle null value
      carbohydrates:
          (json['carbohydrates'] ?? 0).toDouble(), // Handle null value
      protein: (json['protein'] ?? 0).toDouble(), // Handle null value
      totalFat: (json['total_fat'] ?? 0).toDouble(), // Handle null value
      sodium: (json['sodium'] ?? 0).toDouble(), // Handle null value
      sugar: (json['sugar'] ?? 0).toDouble(), // Handle null value
      bmi: (json['bmi'] ?? 0).toDouble(), // Handle null value
      notification: json['notification'] ?? 0,
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
        calorieDifference == 0 &&
        age == 0 &&
        gender.isEmpty &&
        weightPlanId.isEmpty &&
        createdAt.isEmpty &&
        updatedAt.isEmpty &&
        activityLevel == '' &&
        calories == 0 &&
        carbohydrates == 0 &&
        protein == 0 &&
        totalFat == 0 &&
        sodium == 0 &&
        sugar == 0 &&
        bmi == 0 &&
        notification == 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['height'] = height;
    data['weight'] = weight;
    data['waist'] = waist;
    data['hips'] = hips;
    data['bust'] = bust;
    data['targeted_weight'] = targetedWeight;
    data['calorie_difference'] = calorieDifference;
    data['age'] = age;
    data['gender'] = gender;
    data['weight_plan_id'] = weightPlanId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['activity_level'] = activityLevel;
    data['calories'] = calories;
    data['carbohydrates'] = carbohydrates;
    data['protein'] = protein;
    data['total_fat'] = totalFat;
    data['sodium'] = sodium;
    data['sugar'] = sugar;
    data['bmi'] = bmi;
    data['notification'] = notification;
    return data;
  }
}
