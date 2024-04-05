import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/icon_title_next_row.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/workout_recommendation_service.dart';
import 'package:fyp_flutter/views/account/home/finished_workout_view.dart';
import 'package:fyp_flutter/views/account/workout_tracker/perform_workout_view.dart';
import 'package:fyp_flutter/views/account/workout_tracker/schedule_workout_view.dart';
import 'package:fyp_flutter/views/account/workout_tracker/workout_tracker_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';
import 'exercises_step_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../common_widget/exercises_set_section.dart';

class WorkoutDetailView extends StatefulWidget {
  final Map dObj;
  final Function? done;
  const WorkoutDetailView({super.key, required this.dObj, this.done});

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  final List<Map<dynamic, dynamic>> exerciseSets = [];
  double caloriesBurned = 0.0;
  late AuthProvider authProvider;
  // Define a timer for the workout

  late User user;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.getAuthenticatedUser();
    _loadWorkouts();

    // Iterate over each exercise and accumulate total calories burned
    widget.dObj["exercises"].forEach((key, exercise) {
      double calories =
          exercise["metabolic_equivalent"] * user.profile.weight / 60;
      caloriesBurned += calories;
    });
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      final exerciseKeys = widget.dObj['exercises'].keys.toList();
      // Parse "no_of_ex_per_set" into an integer
      int noOfExPerSet = widget.dObj['no_of_ex_per_set'];

      // Verify that "no_of_ex_per_set" is a valid integer
      if (noOfExPerSet != null && noOfExPerSet > 0) {
        // Iterate over exercise keys
        for (int i = 0; i < exerciseKeys.length; i += noOfExPerSet) {
          // Determine the end index for the current set
          final endIndex = (i + noOfExPerSet < exerciseKeys.length)
              ? i + noOfExPerSet
              : exerciseKeys.length;

          // Get the keys for the current set
          final setKeys = exerciseKeys.sublist(i, endIndex);

          // Get exercises for the current set
          final setExercises =
              setKeys.map((key) => widget.dObj['exercises'][key]).toList();

          // Create a map for the current set
          final Map<dynamic, dynamic> setMap = {};
          for (int j = 0; j < setKeys.length; j++) {
            setMap[setKeys[j]] = setExercises[j];
          }

          // Add the current set to exerciseSets
          exerciseSets.add(setMap);
        }
      } else {
        // Handle the case where "no_of_ex_per_set" is not a valid positive integer
        print('Error: "no_of_ex_per_set" is not a valid positive integer.');
      }

      // Set isLoading to false after processing
      isLoading = false;
    });
  }

  List latestArr = [];

  List youArr = [
    {"image": "assets/img/bottle.png", "title": "Bottle 1 Liters"},
  ];

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
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      elevation: 0,
                      leading: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WorkoutTrackerView(),
                            ),
                          );
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
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      elevation: 0,
                      leadingWidth: 0,
                      leading: Container(),
                      expandedHeight: media.width * 0.5,
                      flexibleSpace: Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          '${dotenv.env['BASE_URL']}/storage/uploads/workout/${widget.dObj['image']}',
                          width: media.width * 0.75,
                          height: media.width * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      children: [
                        SingleChildScrollView(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.dObj["name"].toString(),
                                          style: TextStyle(
                                              color: TColor.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          "${widget.dObj["exercises"].length} exercises | ${widget.dObj["exercises"].length} mins | ${caloriesBurned.round()} Calories Burn",
                                          style: TextStyle(
                                              color: TColor.gray, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Image.asset(
                                      "assets/img/fav.png",
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              IconTitleNextRow(
                                  icon: "assets/img/time.png",
                                  title: "Schedule Workout",
                                  time: " ",
                                  color: TColor.primaryColor2.withOpacity(0.3),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ScheduleWorkoutView(
                                                    workout: widget.dObj)));
                                  }),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "You'll Need",
                                    style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "${youArr.length} Items",
                                      style: TextStyle(
                                          color: TColor.gray, fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: media.width * 0.5,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: youArr.length,
                                    itemBuilder: (context, index) {
                                      var yObj = youArr[index] as Map? ?? {};
                                      return Container(
                                          margin: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: media.width * 0.35,
                                                width: media.width * 0.35,
                                                decoration: BoxDecoration(
                                                    color: TColor.lightGray,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  yObj["image"].toString(),
                                                  width: media.width * 0.2,
                                                  height: media.width * 0.2,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  yObj["title"].toString(),
                                                  style: TextStyle(
                                                      color: TColor.black,
                                                      fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ));
                                    }),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Exercises",
                                    style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "${exerciseSets.length} Sets",
                                      style: TextStyle(
                                          color: TColor.gray, fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: exerciseSets.length,
                                  itemBuilder: (context, index) {
                                    var sObj =
                                        exerciseSets[index] as Map? ?? {};
                                    return ExercisesSetSection(
                                      sObj: sObj,
                                      set: index.toString(),
                                      onPressed: (obj) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ExercisesStepDetails(
                                              eObj: obj,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                              SizedBox(
                                height: media.width * 0.1,
                              ),
                            ],
                          ),
                        ),
                        SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RoundButton(
                                  title: "Start Workout",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PerformWorkoutView(
                                          set: exerciseSets,
                                          dObj: widget.dObj,
                                        ), // Replace PerformWorkoutView with your actual page
                                      ),
                                    );
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
