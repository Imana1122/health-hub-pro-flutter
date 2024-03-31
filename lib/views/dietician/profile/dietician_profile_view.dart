import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/common_widget/setting_row.dart';
import 'package:fyp_flutter/common_widget/title_subtitle_cell.dart';
import 'package:fyp_flutter/models/dietician.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/views/dietician/profile/update_dietician.dart';
import 'package:provider/provider.dart';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class DieticianProfileView extends StatefulWidget {
  const DieticianProfileView({super.key});

  @override
  State<DieticianProfileView> createState() => _DieticianProfileViewState();
}

class _DieticianProfileViewState extends State<DieticianProfileView> {
  bool positive = false;
  late DieticianAuthProvider authProvider;
  late Dietician authenticatedUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    authenticatedUser = authProvider.getAuthenticatedDietician();
  }

  List otherArr = [
    {
      "image": "assets/img/p_contact.png",
      "name": "Contact Us",
      "tag": "1",
      "url": "/"
    },
    {
      "image": "assets/img/p_privacy.png",
      "name": "Privacy Policy",
      "tag": "2",
      "url": "/privacy-policy"
    },
    {
      "image": "assets/img/p_setting.png",
      "name": "Change Password",
      "tag": "3",
      "url": "/dietician-change-password"
    },
  ];
  @override
  Widget build(BuildContext context) {
    DieticianAuthProvider authProvider =
        Provider.of<DieticianAuthProvider>(context);

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
        : Scaffold(
            appBar: AppBar(
              backgroundColor: TColor.white,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              title: Text(
                "Profile",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
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
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            authenticatedUser.image != ''
                                ? 'http://10.0.2.2:8000/uploads/dietician/profile/${authenticatedUser.image}'
                                : 'http://w3schools.fzxgj.top/Static/Picture/img_avatar3.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
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
                                authenticatedUser.firstName +
                                    authenticatedUser.lastName,
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
                                              const DieticianProfileEditView(),
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
                    TitleSubtitleCell(
                      title: "Booking Amount",
                      subtitle: "NRs. ${authenticatedUser.bookingAmount}",
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: 'Description'),
                              Tab(text: 'Speciality'),
                              Tab(text: 'Bio'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 300, // Height of the Tab content
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    authenticatedUser.description,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    authenticatedUser.speciality,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    authenticatedUser.bio,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.25,
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
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: isLoading ? null : handleLogout,
                        backgroundColor: const Color.fromARGB(255, 195, 76, 68),
                        child: const Icon(Icons.logout),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
