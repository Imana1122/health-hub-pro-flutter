import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WorkoutRecommendationService {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000/api';
  var authProvider = AuthProvider();
  WorkoutRecommendationService(this.authProvider);

  Future<dynamic> getWorkoutRecommendations(
      {int currentPage = 1, String keyword = '', String category = ''}) async {
    var url = '$baseUrl/account/workout-recommendations?page=$currentPage';

    // Append keyword and category parameters if they are not empty
    if (keyword != '') {
      url += '&keyword=$keyword';
    }
    if (category != '') {
      url += '&category=$category';
    }
    print(url);
    String token = authProvider.user.token;
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data['workouts'];
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<dynamic> getWorkoutExercises({required String id}) async {
    var url = '$baseUrl/account/workout-exercises/$id';

    print(url);
    String token = authProvider.user.token;
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data['workout'];
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<dynamic> getWorkoutLineChartDetails({required String type}) async {
    var url = '$baseUrl/account/get-workout-linechart-details/$type';

    String token = authProvider.user.token;
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data['data'];
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<List<dynamic>> logWorkout(
      {required String workoutId,
      required double caloriesBurned,
      required String workoutName,
      required String startAt,
      required String endAt,
      required int completionStatus,
      required dynamic exercises}) async {
    var url = '$baseUrl/account/log-workout';
    String now = DateTime.now().toIso8601String();
    String token = authProvider.user.token;

    print(now);
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var body = jsonEncode({
      'workout_id': workoutId,
      'start_at': startAt,
      'end_at': endAt,
      'calories_burned': caloriesBurned,
      'exercises': exercises,
      'workout_name': workoutName,
      'completion_status': completionStatus
    });
    print(body);
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        List<dynamic> workoutLogs = data['workoutLogs'];

        Fluttertoast.showToast(
          msg: "Successfully logged workout.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return workoutLogs;
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
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to connect');
    }
  }

  Future<List<dynamic>> deleteWorkoutLog({required String id}) async {
    var url = '$baseUrl/account/deleteWorkoutLog/$id';
    String now = DateTime.now().toIso8601String();
    String token = authProvider.user.token;

    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var body = jsonEncode({'created_at': now});

    var response =
        await http.delete(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        List<dynamic> workoutLogs = data['workoutLogs'];

        Fluttertoast.showToast(
          msg: "Successfully deleted logged workout.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return workoutLogs;
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
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to connect');
    }
  }

  Future<List<dynamic>> getWorkoutLogs() async {
    String now = DateTime.now().toIso8601String();
    var url = '$baseUrl/account/get-workout-logs/$now';
    String token = authProvider.user.token;

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
        List<dynamic> workoutLogs = data['workoutLogs'];

        return workoutLogs;
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
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to connect');
    }
  }
}
