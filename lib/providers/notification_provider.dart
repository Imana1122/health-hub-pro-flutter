import 'package:fyp_flutter/models/notification.dart';
import 'package:fyp_flutter/providers/base_provider.dart';
import 'package:fyp_flutter/services/account/notification_service.dart';

class NotificationProvider extends BaseProvider {
  final NotificationService _notificationService = NotificationService();
  int currentPage = 1;
  int lastPage = 1;
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<List<NotificationModel>> getNotifications(
      {required String token}) async {
    setBusy(true);

    var data = await _notificationService.getNotifications(token: token);
    List<NotificationModel> notifications = List<NotificationModel>.from(
        data['data']
            .map((notification) => NotificationModel.fromJson(notification)));
    currentPage = data['current_page'];
    lastPage = data['last_page'];

    _notifications = notifications;

    notifyListeners();
    setBusy(false);

    return _notifications;
  }

  Future<void> loadMoreNotifications({required String token}) async {
    if (currentPage < lastPage) {
      setBusy(true);

      var loadedMessages = await _notificationService.loadMoreNotifications(
        page: currentPage + 1,
        token: token,
      );

      List<dynamic> dynamicList = loadedMessages['data'];
      List<NotificationModel> chatMessagesList = dynamicList.map((data) {
        return NotificationModel.fromJson(data);
      }).toList();
      _notifications.addAll(chatMessagesList);
      currentPage = loadedMessages['current_page'];
      lastPage = loadedMessages['last_page'];
      notifyListeners();

      setBusy(false);
    }
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
