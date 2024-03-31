import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/notification.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/providers/dietician_notification_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/notification_row.dart';

class DieticianNotificationView extends StatefulWidget {
  const DieticianNotificationView({super.key});

  @override
  State<DieticianNotificationView> createState() =>
      _DieticianNotificationViewState();
}

class _DieticianNotificationViewState extends State<DieticianNotificationView> {
  List<NotificationModel> notificationArr = [];
  int currentPage = 1;
  late DieticianAuthProvider authProvider;
  late DieticianNotificationProvider notiProvider;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    notiProvider =
        Provider.of<DieticianNotificationProvider>(context, listen: false);
    print(notiProvider.notifications);

    notificationArr = notiProvider.notifications;
    readNotifications();

    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    loadMore();
  }

  void _scrollListener() {
    if (_scrollController.offset <= 0.0) {
      loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void loadMore() {
    if (currentPage > 1) {
      notiProvider.loadMoreNotifications(
          page: currentPage + 1, token: authProvider.getAuthenticatedToken());
    }
  }

  void readNotifications() {
    notiProvider.readNotifications(token: authProvider.getAuthenticatedToken());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.white,
          centerTitle: true,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/black_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text(
            "Notification",
            style: TextStyle(
                color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: TColor.lightGray,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  "assets/img/more_btn.png",
                  width: 12,
                  height: 12,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
        backgroundColor: TColor.white,
        body: Consumer<DieticianNotificationProvider>(
            builder: (context, cartProvider, _) {
          return notificationArr.isNotEmpty
              ? ListView.separated(
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  itemBuilder: (context, index) {
                    var nObj = notificationArr[index]; // No need for casting
                    return NotificationRow(nObj: nObj);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: TColor.gray.withOpacity(0.5),
                      height: 1,
                    );
                  },
                  itemCount: notificationArr.length,
                )
              : Container(
                  alignment: Alignment.center,
                  child: const Text('No Notifications'));
        }));
  }
}
