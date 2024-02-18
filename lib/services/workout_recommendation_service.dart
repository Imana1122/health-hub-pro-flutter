import 'dart:convert';
import 'dart:io';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class WorkoutRecommendationService {
  String baseUrl = 'http://10.0.2.2:8000/api';
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
}
