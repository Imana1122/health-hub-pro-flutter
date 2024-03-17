import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';

class ScheduleWorkoutService extends BaseApi {
  var authProvider = AuthProvider();
  ScheduleWorkoutService(this.authProvider);

  Future<dynamic> getScheduledWorkouts({required String day}) async {
    var url = 'account/get-scheduled-workouts/$day';
    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getUpcomingWorkouts() async {
    var url = 'account/get-upcoming-workouts';
    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> scheduleWorkout({required Object body, String? type}) async {
    var url = 'account/schedule-workout';
    if (type != null) {
      url += '?type=$type';
    }
    String token = authProvider.user.token;
    return await api.httpPost(url, body: body, token: token);
  }

  Future<dynamic> updateNotifiable({required Object body}) async {
    var url = 'account/update-workout-notifiable';

    String token = authProvider.user.token;
    return await api.httpPut(url, body: body, token: token);
  }

  Future<dynamic> updateWorkoutDone({required Object body}) async {
    var url = 'account/update-workout-done';

    String token = authProvider.user.token;
    return await api.httpPut(url, body: body, token: token);
  }
}
