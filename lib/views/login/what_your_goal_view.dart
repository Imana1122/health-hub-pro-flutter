import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/weight_plan_service.dart';
import 'package:fyp_flutter/views/login/cuisine_preference.dart';
import 'package:provider/provider.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key});

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  CarouselController buttonCarouselController = CarouselController();
  List goalArr = [];
  int currentPage = 0; // Add this variable to track the current page index

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchWeightPlans();
  }

  _fetchWeightPlans() async {
    try {
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: true);
      var weightPlanService = WeightPlanService(authProvider);
      var weightPlans = await weightPlanService.getWeightPlans();
      setState(() {
        goalArr = weightPlans;
      });
    } catch (e) {
      print("Error fetching weight plans: $e");
    }
  }

  Future<void> _confirmButtonPressed() async {
    try {
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      ;
      var weightPlanService = WeightPlanService(authProvider);

      String selectedGoalId = goalArr[currentPage]["id"];

      var result = await weightPlanService.setGoal(goal: selectedGoalId);

      if (result == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CuisinePreference(),
          ),
        );
      } else {
        print("Error setting goal");
        // Handle unsuccessful setGoal, show an error message if needed
      }
    } catch (e) {
      print("Error: $e");
      // Handle errors, show a message to the user if needed
    }
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
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
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
                            vertical: media.width * 0.1, horizontal: 25),
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
                  initialPage: 0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPage = index;
                    });
                  },
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
