import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/customize_workout_service.dart';
import 'package:fyp_flutter/views/account/workout_tracker/workout_schedule_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';
import 'workout_detail_view.dart';
import 'package:flutter/material.dart';

import '../../../common_widget/round_button.dart';
import '../../../common_widget/what_train_row.dart';

class CustomizedWorkoutView extends StatefulWidget {
  const CustomizedWorkoutView({super.key});

  @override
  State<CustomizedWorkoutView> createState() => _CustomizedWorkoutViewState();
}

class _CustomizedWorkoutViewState extends State<CustomizedWorkoutView> {
  List whatArr = [];
  late AuthProvider authProvider;

  bool isLoading = false;
  int pageNumber = 1;
  int totalPages = 1;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _loadWorkouts();

    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (totalPages > pageNumber) {
        setState(() {
          pageNumber += 1;
        });
        _loadWorkouts();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      isLoading = true;
    });
    var result = await CustomizeWorkoutService(authProvider)
        .getCustomizedWorkouts(currentPage: pageNumber);
    setState(() {
      if (whatArr.isEmpty) {
        whatArr = result['data'];
      } else {
        whatArr.addAll(result['data']);
      }
      pageNumber = result['current_page'];
      totalPages = result['to'];

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
        : AuthenticatedLayout(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: TColor.primaryG)),
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
                  title: Text(
                    "Personalized Customized Workouts",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                body: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                                color: TColor.gray.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3)),
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                              color: TColor.primaryColor2.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Daily Workout Schedule",
                                  style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 90,
                                  height: 30,
                                  child: RoundButton(
                                    title: "Check",
                                    type: RoundButtonType.bgGradient,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const WorkoutScheduleView(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "What Do You Want to Train",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: whatArr.length,
                              itemBuilder: (context, index) {
                                var wObj = whatArr[index] as Map? ?? {};
                                return InkWell(
                                    onTap: () async {
                                      var result =
                                          await CustomizeWorkoutService(
                                                  authProvider)
                                              .getWorkoutDetails(
                                                  id: wObj['id']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WorkoutDetailView(
                                                    dObj: result,
                                                  )));
                                    },
                                    child: WhatTrainRow(wObj: wObj));
                              }),
                          SizedBox(
                            height: media.width * 0.1,
                          ),
                          Container(
                              alignment: Alignment.bottomRight,
                              width: media.width,
                              child: pageNumber < totalPages
                                  ? IconButton(
                                      icon: const Icon(Icons.skip_next),
                                      onPressed: () {
                                        if (pageNumber < totalPages) {
                                          setState(() {
                                            pageNumber += 1;
                                          });
                                          _loadWorkouts();
                                        }
                                      })
                                  : const SizedBox())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
