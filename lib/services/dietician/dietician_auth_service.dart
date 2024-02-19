import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:http/http.dart' as http;
import 'package:fyp_flutter/models/dietician.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DieticianAuthService {
  String baseUrl = 'http://10.0.2.2:8000/api';

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required File cv,
    required File image,
    required String speciality,
    required String description,
    required String esewaId,
    required String bookingAmount,
    required String bio,
  }) async {
    var url = '$baseUrl/dietician/process-register';

    // Create headers
    var headers = {'Content-Type': 'multipart/form-data'};

    // Create a multipart request body
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    // Add fields to the request
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['email'] = email;
    request.fields['phone_number'] = phoneNumber;
    request.fields['speciality'] = speciality;
    request.fields['description'] = description;
    request.fields['esewa_id'] = esewaId;
    request.fields['booking_amount'] = bookingAmount;
    request.fields['bio'] = bio;

    // Add files to the request
    request.files.add(await http.MultipartFile.fromPath('cv', cv.path));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      // Send the request
      var streamedResponse = await request.send();
      // Read and decode the response
      var response = await http.Response.fromStream(streamedResponse);
      // Check the response status code
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Check if registration was successful
        if (data['status'] == true) {
          Fluttertoast.showToast(
            msg: "Successfully registered.",
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
        throw Exception('Failed to Register');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print("An error occurred: $e");
      throw Exception('Failed to Register');
    }
  }

  Future<Dietician> login({
    required String phoneNumber,
    required String password,
  }) async {
    var url = '$baseUrl/dietician/process-login';
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
      print(data);
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
        if (data.containsKey('errors')) {
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
        } else {
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

  Future<bool> logout({required String token}) async {
    var url = '$baseUrl/dietician/logout';
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
          backgroundColor: const Color.fromARGB(255, 231, 105, 96),
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
        backgroundColor: const Color.fromARGB(255, 231, 105, 96),
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
    var url = '$baseUrl/dietician/process-change-password';
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
          backgroundColor: const Color.fromARGB(255, 231, 105, 96),
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
        backgroundColor: const Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to Login');
    }
  }

  Future<dynamic> updatePersonalInfo(
      {required String bio,
      required String email,
      required String phoneNumber,
      required String token}) async {
    var url = '$baseUrl/dietician/update-info';
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var body = jsonEncode({
      'bio': bio,
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
          backgroundColor: const Color.fromARGB(255, 231, 105, 96),
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
        backgroundColor: const Color.fromARGB(255, 231, 105, 96),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to Register');
    }
  }
}
