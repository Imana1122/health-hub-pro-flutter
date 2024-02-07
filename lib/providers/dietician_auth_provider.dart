import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/dietician.dart';
import 'package:fyp_flutter/services/dietician/dietician_auth_service.dart';

class DieticianAuthProvider with ChangeNotifier {
  late Dietician _dietician;
  bool _isLoggedIn = false;

  Dietician get dietician => _dietician;
  bool get isLoggedIn => _isLoggedIn;

  set dietician(Dietician dietician) {
    _dietician = dietician;
    notifyListeners();
  }

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<bool> register({
    required firstName,
    required lastName,
    required email,
    required phoneNumber,
    required cv,
    required image,
    required speciality,
    required description,
    required esewaId,
    required bookingAmount,
    required bio,
  }) async {
    try {
      Dietician dietician = await DieticianAuthService().register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        cv: cv,
        image: image,
        speciality: speciality,
        description: description,
        esewaId: esewaId,
        bookingAmount: bookingAmount,
        bio: bio,
      );

      _dietician = dietician;
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
      Dietician dietician = await DieticianAuthService().login(
        phoneNumber: phoneNumber,
        password: password,
      );

      _dietician = dietician;

      _isLoggedIn = true;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      bool result =
          await DieticianAuthService().logout(token: _dietician.token);
      if (result == true) {
        _dietician = Dietician.empty();

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

  Future<bool> updatePersonalInfo({
    required String name,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      var dieticianData = await DieticianAuthService().updatePersonalInfo(
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          token: _dietician.token);

      _dietician.firstName = dieticianData['first_name'];
      _dietician.email = dieticianData['email'];
      _dietician.phoneNumber = dieticianData['phone_number'];

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
      bool result = await DieticianAuthService().changePassword(
          oldPassword: oldPassword,
          password: password,
          passwordConfirmation: passwordConfirmation,
          token: _dietician.token);

      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Getter method to retrieve the authenticated dietician
  Dietician getAuthenticatedDietician() {
    return _dietician;
  }

  // Getter method to retrieve the authenticated status
  bool getAuthenticatedStatus() {
    return _isLoggedIn;
  }

  // Getter method to retrieve the authenticated token
  String getAuthenticatedToken() {
    return _dietician.token;
  }
}
