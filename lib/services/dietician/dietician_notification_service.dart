import '../base_api.dart';

class DieticianNotificationService extends BaseApi {
  Future<dynamic> getNotifications({required String token}) async {
    return await api.httpGet('dietician/notifications', token: token);
  }

  Future<dynamic> loadMoreNotifications(
      {required int page, required String token}) async {
    return await api.httpGet('dietician/notifications?page=$page',
        token: token);
  }

  Future<dynamic> readNotification({required String token}) async {
    return await api.httpPut('dietician/notifications/read',
        body: {'to': 'user'}, token: token);
  }
}
