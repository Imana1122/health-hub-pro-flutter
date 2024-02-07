import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/models/allergen.dart';
import 'package:fyp_flutter/models/cuisine.dart';
import 'package:fyp_flutter/models/health_condition.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ProfileService {
  String baseUrl = 'http://10.0.2.2:8000/api';

  Future<dynamic> getCuisines({required String token}) async {
    var url = '$baseUrl/account/cuisines';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        var cuisines = data['cuisines'];

        return cuisines;
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<dynamic> getAllergens({required String token}) async {
    var url = '$baseUrl/account/allergens';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        var allergens = data['allergens'];

        return allergens;
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<dynamic> getHealthConditions({required String token}) async {
    var url = '$baseUrl/account/health-conditions';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        var healthConditions = data['healthConditions'];

        return healthConditions;
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<List<Cuisine>> setCuisines(
      {required List cuisines, required String token}) async {
    var url = '$baseUrl/account/set-cuisine-preferences';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var body = jsonEncode({
      'cuisines': cuisines,
    });
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        List<dynamic> cuisineDataList = data['userCuisines'];
        List<Cuisine> cuisines = cuisineDataList
            .map((cuisineData) => Cuisine.fromJson(cuisineData))
            .toList();
        Fluttertoast.showToast(
          msg: "Successfully updated cuisine preferences.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return cuisines;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to update cuisine preferences.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<List<Allergen>> setAllergens(
      {required List allergens, required String token}) async {
    var url = '$baseUrl/account/set-allergens';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var body = jsonEncode({
      'allergens': allergens,
    });
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        List<dynamic> allergenDataList = data['userAllergens'];
        List<Allergen> allergens = allergenDataList
            .map((allergenData) => Allergen.fromJson(allergenData))
            .toList();
        Fluttertoast.showToast(
          msg: "Successfully updated allergens.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return allergens;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to update allergens.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<List<HealthCondition>> setHealthConditions(
      {required List healthConditions, required String token}) async {
    var url = '$baseUrl/account/set-health-conditions';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var body = jsonEncode({
      'healthConditions': healthConditions,
    });
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        List<dynamic> healthConditionDataList = data['userHealthConditions'];
        List<HealthCondition> healthConditions = healthConditionDataList
            .map((healthConditionData) =>
                HealthCondition.fromJson(healthConditionData))
            .toList();
        Fluttertoast.showToast(
          msg: "Successfully updated health conditions.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return healthConditions;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to update health conditions.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }
}
