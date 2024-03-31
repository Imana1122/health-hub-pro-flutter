import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/tab_button.dart';
import 'package:fyp_flutter/models/user_profile.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:fyp_flutter/providers/notification_provider.dart';
import 'package:fyp_flutter/services/pusher_service.dart';
import 'package:fyp_flutter/views/account/login/complete_profile_view.dart';
import 'package:fyp_flutter/views/account/meal_planner/meal_plans.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';
import 'select_view.dart';
import 'package:flutter/material.dart';

import '../home/home_view.dart';
import '../photo_progress/photo_progress_view.dart';
import '../profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const HomeView();
  late NotificationProvider notiProvider;
  late AuthProvider authProvider;
  late ConversationProvider convProvider;

  @override
  void initState() {
    super.initState();

    // Access the authentication provider
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    convProvider = Provider.of<ConversationProvider>(context, listen: false);
    notiProvider = Provider.of<NotificationProvider>(context, listen: false);
    print("Data:: ${authProvider.getAuthenticatedUser().profile.height}");

    if (authProvider.getAuthenticatedUser().profile.height == null) {
      // Navigate to DieticianProfilePage and replace the current route
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompleteProfileView()),
        );
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notiProvider.getNotifications(
          token: authProvider.getAuthenticatedToken());
    });

    connectPusher();
  }

  // Inside the connectPusher method
  void connectPusher() async {
    PusherService pusherService =
        PusherService(); // Create an instance of PusherService
    var result = await pusherService.getMessages(
        channelName: "private-user.${authProvider.getAuthenticatedUser().id}",
        notiProvider: notiProvider,
        convProvider: convProvider);
    if (result == true) {
      notiProvider.readNotifications(
          token: authProvider.getAuthenticatedToken());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
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
                MaterialPageRoute(builder: (context) => const MealPlans()),
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
                Icons.search,
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
                    currentTab = const HomeView();
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
                    currentTab = const SelectView();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              const SizedBox(
                width: 40,
              ),
              TabButton(
                  icon: const Icon(Icons.bar_chart, color: Colors.black),
                  selectIcon:
                      Icon(Icons.bar_chart, color: TColor.secondaryColor1),
                  isActive: selectTab == 2,
                  onTap: () {
                    selectTab = 2;
                    currentTab = const PhotoProgressView();
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
                    currentTab = const ProfileView();
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
