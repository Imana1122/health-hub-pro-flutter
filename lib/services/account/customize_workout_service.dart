import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';
import 'package:http/http.dart' as http;

class CustomizeWorkoutService extends BaseApi {
  var authProvider = AuthProvider();
  CustomizeWorkoutService(this.authProvider);

  Future<dynamic> getCustomizedWorkouts(
      {int currentPage = 1, String keyword = '', String category = ''}) async {
    var url = 'account/get-customized-workouts?page=$currentPage';

    // Append keyword and category parameters if they are not empty
    if (keyword != '') {
      url += '&keyword=$keyword';
    }
    if (category != '') {
      url += '&category=$category';
    }
    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getExercises() async {
    var url = 'account/get-exercises';
    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> saveCustomizedWorkout({
    required Object body,
    required File? image,
  }) async {
    if (image == null) {
      return;
    }
    String token = authProvider.user.token;

    var url = '${dotenv.env['BASE_URL']}/api/account/customized-workout/store';

    // Create headers
    var headers = {
      'Content-Type': 'multipart/form-data',
      HttpHeaders.authorizationHeader: token
    };

    // Create a multipart request body
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    // Add fields to the request
    Map<String, dynamic> bodyMap = body as Map<String, dynamic>;

    bodyMap.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    print(request.fields);

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
          Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: TColor.secondaryColor1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          if (data.containsKey('data')) {
            print(data['data']);
            return data['data'];
          } else {
            return data['status'];
          }
        } else {
          if (data.containsKey('message')) {
            Fluttertoast.showToast(
              msg: data[
                  'message'], // Concatenate elements with '\n' (newline) separator
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
          msg: "Failed to connect.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception(response.body);
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print("An error occurred: $e");
      throw Exception('Failed to Register');
    }
  }
}
