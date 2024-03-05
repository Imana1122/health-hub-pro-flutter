import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/weight_plan_service.dart';
import 'package:fyp_flutter/views/account/login/cuisine_preference.dart';
import 'package:fyp_flutter/views/account/login/login_view.dart';
import 'package:fyp_flutter/views/account/profile/profile_view.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key});

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  CarouselController buttonCarouselController = CarouselController();
  List goalArr = [];
  int currentPage = 0; // Add this variable to track the current page index
  late User user;
  late AuthProvider authProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      // If the user is not logged in, navigate to the login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const LoginView(), // Replace LoginPage with your actual login page
          ),
        );
      });
    } else {
      user = authProvider.getAuthenticatedUser();
      _fetchWeightPlans();
    }
  }

  Future<void> _fetchWeightPlans() async {
    setState(() {
      isLoading = true;
    });
    try {
      var weightPlanService = WeightPlanService(authProvider);
      var weightPlans = await weightPlanService.getWeightPlans();
      setState(() {
        goalArr = weightPlans;
        for (int i = 0; i < goalArr.length; i++) {
          if (goalArr[i]["id"] == user.profile.weightPlanId) {
            currentPage = i;
            break;
          }
        }
      });
    } catch (e) {
      print("Error fetching weight plans: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _confirmButtonPressed() async {
    setState(() {
      isLoading = true;
    });
    try {
      var weightPlanService = WeightPlanService(authProvider);
      String selectedGoalId = goalArr[currentPage]["id"];
      var result = await weightPlanService.setGoal(goal: selectedGoalId);
      if (result == true || result != null) {
        if (user.profile.weightPlanId == '') {
          user.profile.weightPlanId = result['weight_plan_id'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CuisinePreference(),
            ),
          );
        } else {
          user.profile.weightPlanId = result['weight_plan_id'];
          Navigator.pushNamed(context, '/choose-goal');
        }
      } else {
        print("Error setting goal");
        // Handle unsuccessful setGoal, show an error message if needed
      }
    } catch (e) {
      print("Error: $e");
      // Handle errors, show a message to the user if needed
    }
    setState(() {
      isLoading = false;
    });
  }

  String breakTextIntoLines(String text, int wordsPerLine) {
    List<String> words = text.split(' ');
    List<String> lines = [];
    for (int i = 0; i < words.length; i += wordsPerLine) {
      int end = i + wordsPerLine;
      if (end > words.length) {
        end = words.length;
      }
      lines.add(words.sublist(i, end).join(' '));
    }
    return lines.join('\n');
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
        : Scaffold(
            backgroundColor: TColor.white,
            body: SafeArea(
              child: Stack(
                children: [
                  Visibility(
                    visible:
                        !isLoading, // Show the carousel only when data is loaded
                    child: Center(
                      child: CarouselSlider(
                        items: goalArr
                            .map(
                              (gObj) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: TColor.primaryG,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: media.width * 0.1,
                                    horizontal: 25),
                                alignment: Alignment.center,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      Image.network(
                                        'http://10.0.2.2:8000/uploads/weightPlan/thumb/${gObj["image"]}',
                                        width: media.width * 0.5,
                                        fit: BoxFit.fitWidth,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.1,
                                      ),
                                      Text(
                                        gObj["title"].toString(),
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Container(
                                        width: media.width * 0.1,
                                        height: 1,
                                        color: TColor.white,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.02,
                                      ),
                                      Text(
                                        breakTextIntoLines(
                                          gObj["subtitle"].toString(),
                                          6, // Set the number of words per line
                                        ),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: TColor.white,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        carouselController: buttonCarouselController,
                        options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 0.7,
                          aspectRatio: 0.74,
                          initialPage: currentPage,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    width: media.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Text(
                          "What is your goal ?",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "It will help us to choose a best\nprogram for you",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        RoundButton(
                            title: "Confirm", onPressed: _confirmButtonPressed),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
