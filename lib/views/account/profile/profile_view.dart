import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/models/user_profile.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/profile_service.dart';
import 'package:fyp_flutter/views/account/login/complete_profile_view.dart';
import 'package:fyp_flutter/views/account/profile/update_user_profile_image.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/setting_row.dart';
import '../../../common_widget/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool positive = false;
  late AuthProvider authProvider;
  late User authenticatedUser;
  late UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    authenticatedUser = authProvider.getAuthenticatedUser();
    userProfile = authProvider.getAuthenticatedUser().profile;
    positive = authenticatedUser.profile.notification == 1 ? true : false;
    // Check if the user is already logged in
    if (!authProvider.isLoggedIn) {
      // Navigate to DieticianProfilePage and replace the current route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context,
            '/'); // Replace '/dietician-profile' with the route of DieticianProfilePage
      });
    }
  }

  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const ProfileView();

  List accountArr = [
    {
      "image": "assets/img/p_personal.png",
      "name": "Personal Data",
      "tag": "1",
      "url": "/update-personal-data"
    },
    {
      "image": "assets/img/p_choose_goal.png",
      "name": "Choose Goal",
      "tag": "1",
      "url": "/choose-goal"
    },
    {
      "image": "assets/img/p_achi.png",
      "name": "Recipe Filtration",
      "tag": "2",
      "url": "/cuisine-preferences"
    },
    {
      "image": "assets/img/p_activity.png",
      "name": "Activity History",
      "tag": "3",
      "url": "/personal-activity"
    },
    {
      "image": "assets/img/p_workout.png",
      "name": "Workout Progress",
      "tag": "4",
      "url": "/workout-progress"
    }
  ];

  List otherArr = [
    {
      "image": "assets/img/p_contact.png",
      "name": "Contact Us",
      "tag": "5",
      "url": "/contact-us"
    },
    {
      "image": "assets/img/p_privacy.png",
      "name": "Privacy Policy",
      "tag": "6",
      "url": "/privacy-policy"
    },
    {
      "image": "assets/img/p_setting.png",
      "name": "Change Password",
      "tag": "7",
      "url": "/change-password"
    },
  ];
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleLogout() async {
      setState(() {
        isLoading = true;
      });
      try {
        if (await authProvider.logout()) {
          Navigator.pushNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: TColor.primaryColor1,
              content: const Text(
                'Failed to logout',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: TColor.primaryColor1,
            content: Text(
              e.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    var media = MediaQuery.of(context).size;

    return isLoading
        ? SizedBox(
            height: media.height, // Adjust height as needed
            width: media.width, // Adjust width as needed
            child: const Center(
              child: SizedBox(
                width: 50, // Adjust size of the CircularProgressIndicator
                height: 50, // Adjust size of the CircularProgressIndicator
                child: CircularProgressIndicator(
                  strokeWidth:
                      4, // Adjust thickness of the CircularProgressIndicator
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue), // Change color
                ),
              ),
            ),
          )
        : AuthenticatedLayout(
            child: Scaffold(
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              backgroundColor: TColor.white,
              body: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdateUserProfileImage(),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                authenticatedUser.image != ''
                                    ? '${dotenv.env['BASE_URL']}/storage/uploads/users/${authenticatedUser.image}'
                                    : 'http://w3schools.fzxgj.top/Static/Picture/img_avatar3.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  // This function is called when the image fails to load
                                  // You can return a fallback image here
                                  return Image.asset(
                                    'assets/img/non.png', // Path to your placeholder image asset
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authenticatedUser.name,
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  authenticatedUser.profile.weightPlan,
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                              width: 100,
                              height: 40,
                              child: RoundButton(
                                onPressed: isLoading
                                    ? () {} // Provide a non-nullable function that does nothing
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CompleteProfileView(),
                                          ),
                                        );
                                      },
                                title: "Edit",
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TitleSubtitleCell(
                              title: userProfile.height.toString() ?? 'N/A',
                              subtitle: "Height",
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TitleSubtitleCell(
                              title: userProfile.weight.toString() ?? 'N/A',
                              subtitle: "Weight",
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TitleSubtitleCell(
                              title: userProfile.age.toString() ?? 'N/A',
                              subtitle: "Age",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 2)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Account",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: accountArr.length,
                              itemBuilder: (context, index) {
                                var iObj = accountArr[index] as Map? ?? {};
                                return SettingRow(
                                  icon: iObj["image"].toString(),
                                  title: iObj["name"].toString(),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '${iObj["url"]}');
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 2)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Notification",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 30,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/img/p_notification.png",
                                        height: 15,
                                        width: 15,
                                        fit: BoxFit.contain),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Pop-up Notification",
                                        style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    CustomAnimatedToggleSwitch<bool>(
                                      current: positive,
                                      values: const [false, true],
                                      spacing:
                                          0.0, // Updated parameter name from 'dif' to 'spacing'
                                      indicatorSize: const Size.square(30.0),
                                      animationDuration:
                                          const Duration(milliseconds: 200),
                                      animationCurve: Curves.linear,
                                      onChanged: (b) =>
                                          setState(() => positive = b),
                                      iconBuilder: (context, local, global) {
                                        return const SizedBox();
                                      },
                                      onTap: (TapProperties<bool>
                                          properties) async {
                                        setState(() {
                                          positive = !positive;
                                        });
                                        var result = await ProfileService()
                                            .changeNotification(
                                                token: authenticatedUser.token);
                                        authenticatedUser.profile.notification =
                                            result;
                                      },
                                      iconsTappable: false,
                                      wrapperBuilder: (context, global, child) {
                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned(
                                              left: 10.0,
                                              right: 10.0,
                                              height: 30.0,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: TColor.secondaryG,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(50.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child,
                                          ],
                                        );
                                      },
                                      foregroundIndicatorBuilder:
                                          (context, global) {
                                        return SizedBox.fromSize(
                                          size: const Size(10, 10),
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: TColor.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50.0)),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black38,
                                                    spreadRadius: 0.05,
                                                    blurRadius: 1.1,
                                                    offset: Offset(0.0, 0.8))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 2)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Other",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: otherArr.length,
                              itemBuilder: (context, index) {
                                var iObj = otherArr[index] as Map? ?? {};
                                return SettingRow(
                                  icon: iObj["image"].toString(),
                                  title: iObj["name"].toString(),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '${iObj["url"]}');
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: isLoading ? null : handleLogout,
                          backgroundColor:
                              const Color.fromARGB(255, 195, 76, 68),
                          child: const Icon(Icons.logout),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
