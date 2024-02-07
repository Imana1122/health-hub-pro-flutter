import 'package:fyp_flutter/models/allergen.dart';
import 'package:fyp_flutter/models/cuisine.dart';
import 'package:fyp_flutter/models/health_condition.dart';
import 'package:fyp_flutter/models/user_profile.dart';

class User {
  String id;
  String email;
  String name;
  String phoneNumber;
  String token;
  UserProfile profile;
  List<Cuisine>? cuisines; // Make the list nullable
  List<Allergen>? allergens; // Make the list nullable
  List<HealthCondition>? healthConditions; // Make the list nullable

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.token,
    required this.profile,
    this.cuisines, // Update the parameter to be nullable
    this.allergens, // Update the parameter to be nullable
    this.healthConditions, // Update the parameter to be nullable
  });

  // Named constructor with default values
  User.empty()
      : id = '',
        email = '',
        name = '',
        phoneNumber = '',
        token = '',
        profile = UserProfile.empty(),
        cuisines = null, // Initialize the list as null
        allergens = null, // Initialize the list as null
        healthConditions = null; // Initialize the list as null

  factory User.fromJson(Map<String, dynamic> json) {
    // Extract cuisines list from the JSON
    List<dynamic>? cuisinesJson = json['cuisines'];

    // Use null-aware operator to handle null case
    List<Cuisine>? userCuisines =
        cuisinesJson?.map((cuisine) => Cuisine.fromJson(cuisine)).toList();

    // Extract cuisines list from the JSON
    List<dynamic>? allergensJson = json['allergens'];

    // Use null-aware operator to handle null case
    List<Allergen>? userAllergens =
        allergensJson?.map((allergen) => Allergen.fromJson(allergen)).toList();

    // Extract cuisines list from the JSON
    List<dynamic>? healthConditionsJson = json['healthConditions'];

    // Use null-aware operator to handle null case
    List<HealthCondition>? userHealthConditions = healthConditionsJson
        ?.map((allergen) => HealthCondition.fromJson(allergen))
        .toList();

    return User(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        token: json['token'] ?? '',
        profile: UserProfile.fromJson(json['profile'] ?? {}),
        cuisines: userCuisines,
        healthConditions: userHealthConditions,
        allergens: userAllergens);
  }
}
