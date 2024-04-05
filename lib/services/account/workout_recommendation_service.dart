import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';

class WorkoutRecommendationService extends BaseApi {
  var authProvider = AuthProvider();
  WorkoutRecommendationService(this.authProvider);

  Future<dynamic> getWorkoutRecommendations(
      {int currentPage = 1, String keyword = '', String category = ''}) async {
    var url = 'account/workout-recommendations?page=$currentPage';

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

  Future<dynamic> getWorkoutDetails({required String id}) async {
    var url = 'account/workout-details/$id';

    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getWorkoutExercises({required String id}) async {
    var url = 'account/workout-exercises/$id';

    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getWorkoutLineChartDetails(
      {required String type,
      required String year,
      required String month}) async {
    var url =
        'account/get-workout-linechart-details/$type?year=$year&month=$month';

    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> logWorkout(
      {required String workoutId,
      required double caloriesBurned,
      required String workoutName,
      required String startAt,
      required String endAt,
      required int completionStatus,
      String? type}) async {
    var url = 'account/log-workout';
    if (type != null) {
      url += "?type=$type";
    }
    String token = authProvider.user.token;

    var body = {
      'workout_id': workoutId,
      'start_at': startAt,
      'end_at': endAt,
      'calories_burned': caloriesBurned,
      'workout_name': workoutName,
      'completion_status': completionStatus
    };
    return await api.httpPost(url, body: body, token: token);
  }

  Future<dynamic> deleteWorkoutLog({required String id}) async {
    var url = 'account/deleteWorkoutLog/$id';
    String now = DateTime.now().toIso8601String();
    String token = authProvider.user.token;

    var body = {'created_at': now};

    return await api.httpDelete(url, body: body, token: token);
  }

  Future<dynamic> getWorkoutLogs({String? now}) async {
    now ??= DateTime.now().toIso8601String();
    var url = 'account/get-workout-logs/$now';
    String token = authProvider.user.token;

    return await api.httpGet(url, token: token);
  }
}
