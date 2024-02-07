import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/models/allergen.dart';
import 'package:fyp_flutter/models/cuisine.dart';
import 'package:fyp_flutter/models/health_condition.dart';
import 'package:fyp_flutter/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:fyp_flutter/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  String baseUrl = 'http://10.0.2.2:8000/api';

  Future<User> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
    var url = '$baseUrl/account/process-register';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'password_confirmation': passwordConfirmation
    });
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        var userData = data['user'];
        var accessToken = data['token'];

        User user = User.fromJson(userData);
        user.token = 'Bearer $accessToken';
        Fluttertoast.showToast(
          msg: "Successfully registered.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return user;
      } else {
        Fluttertoast.showToast(
          msg: "${data['errors']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 231, 105, 96),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("Errors: $data['errors']");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to Register');
    }
  }

  Future<User> login({
    required String phoneNumber,
    required String password,
  }) async {
    var url = '$baseUrl/account/process-login';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'phone_number': phoneNumber,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        var userData = data['user'];
        var accessToken = data['token'];
        var profile = data['userProfile'];

        User user = User.fromJson(userData);
        user.token = 'Bearer $accessToken';
        user.profile = UserProfile.fromJson(profile);

        List<dynamic> allergenDataList = data['userAllergens'];
        List<Allergen> allergens = allergenDataList
            .map((allergenData) => Allergen.fromJson(allergenData))
            .toList();
        user.allergens = allergens;

        List<dynamic> cuisineDataList = data['userCuisines'];
        List<Cuisine> cuisines = cuisineDataList
            .map((cuisineData) => Cuisine.fromJson(cuisineData))
            .toList();

        user.cuisines = cuisines;

        List<dynamic> healthConditionDataList = data['userHealthConditions'];
        List<HealthCondition> healthConditions = healthConditionDataList
            .map((healthConditionData) =>
                HealthCondition.fromJson(healthConditionData))
            .toList();

        user.healthConditions = healthConditions;

        Fluttertoast.showToast(
          msg: "Successfully logged in.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return user;
      } else {
        Fluttertoast.showToast(
          msg: "${data['errors']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 231, 105, 96),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("${data['errors']}");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to Login');
    }
  }

  Future<bool> logout({required String token}) async {
    var url = '$baseUrl/account/logout';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        Fluttertoast.showToast(
          msg: "Successfully logged out.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "${data['errors']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 231, 105, 96),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("${data['errors']}");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to connect');
    }
  }

  Future<UserProfile> completeProfile(
      {required double height,
      required double weight,
      required double waist,
      required double hips,
      required double bust,
      required double targetedWeight,
      required int age,
      required String gender,
      required String token}) async {
    var url = '$baseUrl/account/complete-profile';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token,
    };
    var body = jsonEncode({
      'height': height,
      'weight': weight,
      'waist': waist,
      'hips': hips,
      'bust': bust,
      'targeted_weight': targetedWeight,
      'age': age,
      'gender': gender
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        var userData = data['userProfile'];

        UserProfile userProfile = UserProfile.fromJson(userData);
        Fluttertoast.showToast(
          msg: "Successfully updated profile.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return userProfile;
      } else {
        Fluttertoast.showToast(
          msg: "${data['errors']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 231, 105, 96),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("${data['errors']}");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to connect');
    }
  }

  Future<bool> changePassword(
      {required String password,
      required String passwordConfirmation,
      required String oldPassword,
      required String token}) async {
    var url = '$baseUrl/account/process-change-password';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var body = jsonEncode({
      'old_password': oldPassword,
      'password': password,
      'password_confirmation': passwordConfirmation
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        Fluttertoast.showToast(
          msg: "Successfully updated password.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "${data['errors']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 231, 105, 96),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("${data['errors']}");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to Login');
    }
  }

  Future<dynamic> updatePersonalInfo(
      {required String name,
      required String email,
      required String phoneNumber,
      required String token}) async {
    var url = '$baseUrl/account/update-info';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var body = jsonEncode({
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
    });
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        var userData = data['user'];

        Fluttertoast.showToast(
          msg: "Successfully updated.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return userData;
      } else {
        Fluttertoast.showToast(
          msg: "${data['errors']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 231, 105, 96),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("Errors: $data['errors']");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to Register');
    }
  }


}
