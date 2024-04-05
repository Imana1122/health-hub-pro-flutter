import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/tab_button.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/providers/dietician_conversation_provider.dart';
import 'package:fyp_flutter/providers/dietician_notification_provider.dart';
import 'package:fyp_flutter/services/pusher_service.dart';
import 'package:fyp_flutter/views/dietician/chat/dietician_conversations_screen.dart';
import 'package:fyp_flutter/views/dietician/dietician_home_view.dart';
import 'package:fyp_flutter/views/dietician/dietician_payment_history.dart';
import 'package:fyp_flutter/views/dietician/profile/dietician_profile_view.dart';
import 'package:fyp_flutter/views/dietician/dietician_ratings_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_dietician_layout.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DieticianCommonLayout extends StatefulWidget {
  const DieticianCommonLayout({super.key});

  @override
  State<DieticianCommonLayout> createState() => _DieticianCommonLayoutState();
}

class _DieticianCommonLayoutState extends State<DieticianCommonLayout> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const DieticianHomeView();
  late DieticianNotificationProvider notiProvider;
  late DieticianAuthProvider dieticianAuthProvider;
  late DieticianConversationProvider convProvider;

  @override
  void initState() {
    super.initState();

    // Access the authentication provider
    dieticianAuthProvider =
        Provider.of<DieticianAuthProvider>(context, listen: false);
    convProvider =
        Provider.of<DieticianConversationProvider>(context, listen: false);
    notiProvider =
        Provider.of<DieticianNotificationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notiProvider.getNotifications(
          token: dieticianAuthProvider.getAuthenticatedToken());
    });
    connectPusher();
  }

  // Inside the connectPusher method
  void connectPusher() async {
    PusherService pusherService =
        PusherService(); // Create an instance of PusherService
    var result = await pusherService.getMessagesForDietician(
        channelName:
            "private-dietician.${dieticianAuthProvider.getAuthenticatedDietician().id}",
        notiProvider: notiProvider,
        convProvider: convProvider);
    if (result == true) {
      notiProvider.readNotifications(
          token: dieticianAuthProvider.getAuthenticatedToken());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticatedDieticianLayout(
      child: Scaffold(
        backgroundColor: TColor.white,
        body: PageStorage(bucket: pageBucket, child: currentTab),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DieticianConversationScreen()),
              );
            },
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: TColor.primaryG,
                  ),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                    )
                  ]),
              child: Icon(
                Icons.chat,
                color: TColor.white,
                size: 35,
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          decoration: BoxDecoration(color: TColor.white, boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
          ]),
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  icon: const Icon(Icons.home, color: Colors.black),
                  selectIcon: Icon(Icons.home, color: TColor.secondaryColor1),
                  isActive: selectTab == 0,
                  onTap: () {
                    selectTab = 0;
                    currentTab = const DieticianHomeView();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              TabButton(
                  icon: const Icon(Icons.local_activity, color: Colors.black),
                  selectIcon:
                      Icon(Icons.local_activity, color: TColor.secondaryColor1),
                  isActive: selectTab == 1,
                  onTap: () {
                    selectTab = 1;
                    currentTab = const DieticianSelectView();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              const SizedBox(
                width: 40,
              ),
              TabButton(
                  icon: const Icon(Icons.payment, color: Colors.black),
                  selectIcon:
                      Icon(Icons.payment, color: TColor.secondaryColor1),
                  isActive: selectTab == 2,
                  onTap: () {
                    selectTab = 2;
                    currentTab = const DieticianSalaryPaymentHistory();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              TabButton(
                  icon: const Icon(Icons.person, color: Colors.black),
                  selectIcon: Icon(Icons.person, color: TColor.secondaryColor1),
                  isActive: selectTab == 3,
                  onTap: () {
                    selectTab = 3;
                    currentTab = const DieticianProfileView();
                    if (mounted) {
                      setState(() {});
                    }
                  })
            ],
          ),
        )),
      ),
    );
  }
}
