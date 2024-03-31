import 'package:fyp_flutter/models/notification.dart';
import 'package:fyp_flutter/providers/base_provider.dart';
import 'package:fyp_flutter/services/dietician/dietician_notification_service.dart';

class DieticianNotificationProvider extends BaseProvider {
  final DieticianNotificationService _notificationService =
      DieticianNotificationService();
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<List<NotificationModel>> getNotifications(
      {required String token}) async {
    setBusy(true);

    var data = await _notificationService.getNotifications(token: token);
    print(data);
    List<NotificationModel> notifications = List<NotificationModel>.from(
        data['data']
            .map((notification) => NotificationModel.fromJson(notification)));

    _notifications = notifications;
    print(notifications);
    notifyListeners();
    setBusy(false);

    return _notifications;
  }

  Future<void> loadMoreNotifications(
      {required String token, required int page}) async {
    setBusy(true);

    var loadedMessages = await _notificationService.loadMoreNotifications(
      page: page,
      token: token,
    );

    List<dynamic> dynamicList = loadedMessages['data'];
    List<NotificationModel> chatMessagesList = dynamicList.map((data) {
      return NotificationModel.fromJson(data);
    }).toList();
    _notifications.insertAll(0, chatMessagesList);

    notifyListeners();

    setBusy(false);
  }

  Future<bool> readNotifications({required String token}) async {
    var data = await _notificationService.readNotification(token: token);
    if (data == true) {
      for (var notification in _notifications) {
        notification.read = 1;
      }
      notifyListeners();
    }

    return true;
  }

  Future<bool> setAllNotificationsRead() async {
    for (var notification in _notifications) {
      notification.read = 1;
    }

    notifyListeners();

    return true;
  }

  Future<dynamic> saveNotification({required NotificationModel item}) async {
    setBusy(true);
    _notifications.add(item);
    notifyListeners();
    setBusy(false);
  }
}
