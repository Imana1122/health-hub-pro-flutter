import 'package:fyp_flutter/models/user_profile.dart';

class User {
  String id;
  String email;
  String name;
  String phoneNumber;
  String token;
  UserProfile profile;
  List<dynamic> cuisines; // Make the list dynamic
  List<dynamic> allergens; // Make the list dynamic
  List<dynamic> healthConditions; // Make the list dynamic
  String image = '';
  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.phoneNumber,
      required this.token,
      required this.profile,
      required this.cuisines, // Update the parameter to be dynamic
      required this.allergens, // Update the parameter to be dynamic
      required this.healthConditions, // Update the parameter to be dynamic
      String image = ''});

  // Named constructor with default values
  User.empty()
      : id = '',
        email = '',
        name = '',
        phoneNumber = '',
        token = '',
        image = '',
        profile = UserProfile.empty(),
        cuisines = [], // Initialize the list as empty
        allergens = [], // Initialize the list as empty
        healthConditions = []; // Initialize the list as empty

  factory User.fromJson(Map<String, dynamic> json) {
    // Extract cuisines list from the JSON
    List<dynamic>? cuisinesJson = json['cuisines'];

    // Extract allergens list from the JSON
    List<dynamic>? allergensJson = json['allergens'];

    // Extract healthConditions list from the JSON
    List<dynamic>? healthConditionsJson = json['healthConditions'];

    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      token: json['token'] ?? '',
      profile: UserProfile.fromJson(json['profile'] ?? {}),
      cuisines: cuisinesJson ?? [],
      healthConditions: healthConditionsJson ?? [],
      allergens: allergensJson ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] =
        phoneNumber; // Assuming 'phone_number' is the key for phoneNumber
    data['token'] = token;
    data['profile'] = profile.toJson();
    data['cuisines'] = cuisines;
    data['health_conditions'] = healthConditions;
    data['allergens'] = allergens;
    return data;
  }
}
