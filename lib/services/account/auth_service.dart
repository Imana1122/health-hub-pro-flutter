import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:fyp_flutter/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  String baseUrl = '';

  // Initialize the field in the constructor
  AuthService() {
    baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000';
    baseUrl += '/api';
  }

  Future<User> register({
    required File image,
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
    var url = '$baseUrl/account/process-register';

    // Create headers
    var headers = {'Content-Type': 'multipart/form-data'};

    // Create a multipart request body
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    // Add fields to the request
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['phone_number'] = phoneNumber;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = passwordConfirmation;

    // Add files to the request
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      // Send the request
      var streamedResponse = await request.send();
      // Read and decode the response
      var response = await http.Response.fromStream(streamedResponse);
      // Check the response status code
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == true) {
          var userData = data['user'];
          var accessToken = data['token'];

          User user = User.fromJson(userData);
          user.token = 'Bearer $accessToken';
          user.profile = UserProfile.empty();
          user.allergens = [];
          user.cuisines = [];
          user.healthConditions = [];
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
          if (data.containsKey('error')) {
            Fluttertoast.showToast(
              msg: data[
                  'error'], // Concatenate elements with '\n' (newline) separator
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            throw Exception("${data['error']}");
          } else {
            Map<String, dynamic> errorMap = data['errors'];
            List<String> errorMessages = [];

            errorMap.forEach((field, errors) {
              for (var error in errors) {
                errorMessages.add('$field: $error');
              }
            });

            Fluttertoast.showToast(
              msg: errorMessages.join(
                  '\n\n'), // Concatenate elements with '\n' (newline) separator
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            throw Exception("${data['errors']}");
          }
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to connect",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 231, 105, 96),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('Failed to Register');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print("An error occurred: $e");
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
    print(url);
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
        if (profile != null) {
          user.profile = UserProfile.fromJson(profile);
        } else {
          user.profile = UserProfile.empty();
        }
        List<dynamic> allergens = data['userAllergens'];

        user.allergens = allergens;

        List<dynamic> cuisines = data['userCuisines'];

        user.cuisines = cuisines;

        List<dynamic> healthConditions = data['userHealthConditions'];

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
        if (data.containsKey('error')) {
          Fluttertoast.showToast(
            msg: data[
                'error'], // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['error']}");
        } else {
          Map<String, dynamic> errorMap = data['errors'];
          List<String> errorMessages = [];

          errorMap.forEach((field, errors) {
            for (var error in errors) {
              errorMessages.add('$field: $error');
            }
          });

          Fluttertoast.showToast(
            msg: errorMessages.join(
                '\n\n'), // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['errors']}");
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(response.body);
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
        if (data.containsKey('error')) {
          Fluttertoast.showToast(
            msg: data[
                'error'], // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['error']}");
        } else {
          Map<String, dynamic> errorMap = data['errors'];
          List<String> errorMessages = [];

          errorMap.forEach((field, errors) {
            for (var error in errors) {
              errorMessages.add('$field: $error');
            }
          });

          Fluttertoast.showToast(
            msg: errorMessages.join(
                '\n\n'), // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['errors']}");
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 231, 105, 96),
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
      required String token,
      required double calorieDifference}) async {
    var url = '$baseUrl/account/complete-profile';
    print(url);
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
      'gender': gender,
      'calorie_difference': calorieDifference
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
        if (data.containsKey('error')) {
          Fluttertoast.showToast(
            msg: data[
                'error'], // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['error']}");
        } else {
          Map<String, dynamic> errorMap = data['errors'];
          List<String> errorMessages = [];

          errorMap.forEach((field, errors) {
            for (var error in errors) {
              errorMessages.add('$field: $error');
            }
          });

          Fluttertoast.showToast(
            msg: errorMessages.join(
                '\n\n'), // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['errors']}");
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(response.body);
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
        if (data.containsKey('error')) {
          Fluttertoast.showToast(
            msg: data[
                'error'], // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['error']}");
        } else {
          if (data.containsKey('error')) {
            Fluttertoast.showToast(
              msg: data[
                  'error'], // Concatenate elements with '\n' (newline) separator
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            throw Exception("${data['error']}");
          } else {
            Map<String, dynamic> errorMap = data['errors'];
            List<String> errorMessages = [];

            errorMap.forEach((field, errors) {
              for (var error in errors) {
                errorMessages.add('$field: $error');
              }
            });

            Fluttertoast.showToast(
              msg: errorMessages.join(
                  '\n\n'), // Concatenate elements with '\n' (newline) separator
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            throw Exception("${data['errors']}");
          }
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 231, 105, 96),
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
        if (data.containsKey('error')) {
          Fluttertoast.showToast(
            msg: data[
                'error'], // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['error']}");
        } else {
          Map<String, dynamic> errorMap = data['errors'];
          List<String> errorMessages = [];

          errorMap.forEach((field, errors) {
            for (var error in errors) {
              errorMessages.add('$field: $error');
            }
          });

          Fluttertoast.showToast(
            msg: errorMessages.join(
                '\n\n'), // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['errors']}");
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to Register');
    }
  }
}
