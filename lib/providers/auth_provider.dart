import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/models/user_profile.dart';
import 'package:fyp_flutter/services/account/auth_service.dart';
import 'package:fyp_flutter/services/account/profile_service.dart';

class AuthProvider with ChangeNotifier {
  late User _user;
  late UserProfile _userProfile;
  bool _isLoggedIn = false;

  User get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  set user(User user) {
    _user = user;
    notifyListeners();
  }

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<bool> register(
      {required String name,
      required String email,
      required String phoneNumber,
      required String password,
      required String passwordConfirmation}) async {
    try {
      User user = await AuthService().register(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
          passwordConfirmation: passwordConfirmation);

      _user = user;

      _isLoggedIn = true;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      User user = await AuthService().login(
        phoneNumber: phoneNumber,
        password: password,
      );

      _user = user;
      _userProfile = user.profile;

      _isLoggedIn = true;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      bool result = await AuthService().logout(token: _user.token);
      if (result == true) {
        _user = User.empty();
        _userProfile = UserProfile.empty();

        _isLoggedIn = false; // Set to false for logout
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> completeProfile(
      {required double height,
      required double weight,
      required double waist,
      required double hips,
      required double bust,
      required double targetedWeight,
      required int age,
      required String gender}) async {
    try {
      UserProfile userProfile = await AuthService().completeProfile(
          height: height,
          weight: weight,
          waist: waist,
          hips: hips,
          bust: bust,
          targetedWeight: targetedWeight,
          age: age,
          gender: gender,
          token: _user.token);
      _user.profile = userProfile;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> setCuisinePreferences({required List cuisines}) async {
    try {
      var userCuisines = await ProfileService()
          .setCuisines(cuisines: cuisines, token: _user.token);
      _user.cuisines = userCuisines;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> setAllergens({required List allergens}) async {
    try {
      var userAllergens = await ProfileService()
          .setAllergens(allergens: allergens, token: _user.token);
      _user.allergens = userAllergens;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> setHealthConditions({required List healthConditions}) async {
    try {
      var userHealthConditions = await ProfileService().setHealthConditions(
          healthConditions: healthConditions, token: _user.token);

      _user.healthConditions = userHealthConditions;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePersonalInfo({
    required String name,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      var userData = await AuthService().updatePersonalInfo(
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          token: _user.token);

      _user.name = userData['name'];
      _user.email = userData['email'];
      _user.phoneNumber = userData['phone_number'];

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      bool result = await AuthService().changePassword(
          oldPassword: oldPassword,
          password: password,
          passwordConfirmation: passwordConfirmation,
          token: _user.token);

      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> getCuisines() async {
    try {
      var cuisines = await ProfileService().getCuisines(token: _user.token);

      return cuisines;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> getAllergens() async {
    try {
      var allergens = await ProfileService().getAllergens(token: _user.token);

      return allergens;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> getHealthConditions() async {
    try {
      var healthConditions =
          await ProfileService().getHealthConditions(token: _user.token);

      return healthConditions;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logMeal({required String recipeId}) async {
    try {
      await ProfileService().logMeal(recipeId: recipeId, token: _user.token);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteLogMeal({required String id}) async {
    try {
      await ProfileService().deleteLogMeal(id: id, token: _user.token);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> getMealLogs() async {
    try {
      var mealLogs = await ProfileService().getMealLogs(token: _user.token);
      return mealLogs;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<dynamic> getSpecificMealLogs({required String datetime}) async {
    try {
      var mealLogs = await ProfileService()
          .getSpecificMealLogs(datetime: datetime, token: _user.token);
      return mealLogs;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Getter method to retrieve the authenticated user
  User getAuthenticatedUser() {
    return _user;
  }

  // Getter method to retrieve the authenticated user profile
  UserProfile getAuthenticatedUserProfile() {
    return _userProfile;
  }

  // Getter method to retrieve the authenticated status
  bool getAuthenticatedStatus() {
    return _isLoggedIn;
  }

  // Getter method to retrieve the authenticated token
  String getAuthenticatedToken() {
    return _user.token;
  }
}
