import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/notification.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/providers/notification_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/notification_row.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<NotificationModel> notificationArr = [];

  late AuthProvider authProvider;
  late NotificationProvider notiProvider;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    notiProvider = Provider.of<NotificationProvider>(context, listen: false);

    notificationArr = notiProvider.notifications;
    readNotifications();

    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    loadMore();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void loadMore() {
    if (notiProvider.currentPage < notiProvider.lastPage) {
      notiProvider.loadMoreNotifications(
          token: authProvider.getAuthenticatedToken());
    }
  }

  void readNotifications() {
    notiProvider.readNotifications(token: authProvider.getAuthenticatedToken());
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

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
      body: Container(
        alignment: Alignment.centerLeft,
        height: media.height * 0.1 * notificationArr.length,
        child: Consumer<NotificationProvider>(
          builder: (context, cartProvider, _) {
            return notificationArr.isNotEmpty
                ? ListView.separated(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
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
          },
        ),
      ),
    );
  }
}
