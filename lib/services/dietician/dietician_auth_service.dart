import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:http/http.dart' as http;
import 'package:fyp_flutter/models/dietician.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DieticianAuthService {
  String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Dietician> register({
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
    var url = '$baseUrl/account/process-register';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'cv': cv,
      'image': image,
      'speciality': speciality,
      'description': description,
      'esewa_id': esewaId,
      'booking_amount': bookingAmount,
      'bio': bio,
    });
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        var dieticianData = data['dietician'];
        var accessToken = data['token'];

        Dietician dietician = Dietician.fromJson(dieticianData);
        dietician.token = 'Bearer $accessToken';
        Fluttertoast.showToast(
          msg: "Successfully registered.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return dietician;
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

  Future<Dietician> login({
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
        var dieticianData = data['dietician'];
        var accessToken = data['token'];

        Dietician dietician = Dietician.fromJson(dieticianData);
        dietician.token = 'Bearer $accessToken';

        Fluttertoast.showToast(
          msg: "Successfully logged in.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return dietician;
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
        var dieticianData = data['dietician'];

        Fluttertoast.showToast(
          msg: "Successfully updated.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return dieticianData;
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
