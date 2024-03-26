import '../base_api.dart';

class NotificationService extends BaseApi {
  Future<dynamic> getNotifications({required String token}) async {
    return await api.httpGet('account/notifications', token: token);
  }

  Future<dynamic> loadMoreNotifications(
      {required int page, required String token}) async {
    return await api.httpGet('account/notifications?page=$page', token: token);
  }

  Future<dynamic> readNotification({required String token}) async {
    return await api.httpPut('account/notifications/read',
        body: {'to': 'user'}, token: token);
  }
}
