import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/common_widget/title_subtitle_cell.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/services/dietician/shared_progress_service.dart';
import 'package:fyp_flutter/views/account/profile/update_user_profile_image.dart';
import 'package:fyp_flutter/views/dietician/user_progress/shared_photo_progress_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_dietician_layout.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';

class SharedUserProfileView extends StatefulWidget {
  final String id;
  const SharedUserProfileView({super.key, required this.id});

  @override
  State<SharedUserProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<SharedUserProfileView> {
  bool isLoading = false;
  late DieticianAuthProvider authProvider;
  User profileUser = User.empty();

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    loadDetails();
  }

  void loadDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      var result = await SharedProgressService(authProvider)
          .getUserProfile(id: widget.id);
      setState(() {
        profileUser = User.fromJson(result);
      });
      print('Result:: $result');
      print(profileUser);
    } catch ($e) {
      print($e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        : AuthenticatedDieticianLayout(
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
                      "${profileUser.name} Profile",
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
                                profileUser.image != ''
                                    ? '${dotenv.env['BASE_URL']}/storage/uploads/users/${profileUser.image}'
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
                                  profileUser.name,
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  profileUser.profile.weightPlan,
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TitleSubtitleCell(
                              title: profileUser.profile.height.toString() ??
                                  'N/A',
                              subtitle: "Height",
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TitleSubtitleCell(
                              title: profileUser.profile.weight.toString() ??
                                  'N/A',
                              subtitle: "Weight",
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TitleSubtitleCell(
                              title:
                                  profileUser.profile.age.toString() ?? 'N/A',
                              subtitle: "Age",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TitleSubtitleCell(
                              title: profileUser.profile.targetedWeight
                                      .toString() ??
                                  'N/A',
                              subtitle: "Target Weight",
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TitleSubtitleCell(
                              title: profileUser.profile.activityLevel
                                      .toString() ??
                                  'N/A',
                              subtitle: "Activity Level",
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TitleSubtitleCell(
                              title: profileUser.profile.calorieDifference
                                      .toString() ??
                                  'N/A',
                              subtitle: "Cal difference",
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
                              const Text(
                                'Allergens',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: profileUser.allergens.length,
                                itemBuilder: (context, index) {
                                  var condition = profileUser.allergens[index];
                                  return ListTile(
                                    title: Text(
                                      condition['name'] ?? 'N/A',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    leading: const Icon(Icons.warning),
                                    // You can add more details or actions here if needed
                                  );
                                },
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 16,
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
                              const Text(
                                'Health Conditions',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: profileUser.healthConditions.length,
                                itemBuilder: (context, index) {
                                  var condition =
                                      profileUser.healthConditions[index];
                                  return ListTile(
                                    title: Text(
                                      condition['name'] ?? 'N/A',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    leading: const Icon(Icons.healing_outlined),
                                    // You can add more details or actions here if needed
                                  );
                                },
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 16,
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
                              const Text(
                                'Cuisines',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: profileUser.cuisines.length,
                                itemBuilder: (context, index) {
                                  var condition = profileUser.cuisines[index];
                                  return ListTile(
                                    title: Text(
                                      condition['name'] ?? 'N/A',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    leading: const Icon(Icons.restaurant_menu),
                                    // You can add more details or actions here if needed
                                  );
                                },
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SharedPhotoProgressView(id: widget.id),
                    ),
                  );
                },
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.secondaryG),
                      borderRadius: BorderRadius.circular(27.5),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2))
                      ]),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.scale,
                    size: 20,
                    color: TColor.white,
                  ),
                ),
              ),
            ),
          );
  }
}
