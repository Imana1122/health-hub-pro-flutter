import 'dart:async';

import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/icon_title_next_row.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'exercises_step_details.dart';
import './workout_schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../common_widget/exercises_set_section.dart';

class WorkoutDetailView extends StatefulWidget {
  final Map dObj;
  const WorkoutDetailView({super.key, required this.dObj});

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  final List<Map<dynamic, dynamic>> exerciseSets = [];
  double totalCaloriesBurned = 0.0;
  late AuthProvider authProvider;
  // Define a timer for the workout
  late Timer _workoutTimer;
  int _currentExerciseIndex = 0;
  int _currentExerciseIndexInSet = 0;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loadWorkouts();
    User user = authProvider.getAuthenticatedUser();
    // Assuming widget.dObj["exercises"] is a Map<int, Map<String, dynamic>>
    double minutes = widget.dObj["exercises"].keys.toList().length.toDouble();

    // Iterate over each exercise and accumulate total calories burned
    widget.dObj["exercises"].forEach((key, exercise) {
      double calories =
          exercise["metabolic_equivalent"] * user.profile.weight * minutes / 60;
      totalCaloriesBurned += calories;
    });
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      final exerciseKeys = widget.dObj['exercises'].keys.toList();

      for (int i = 0; i < exerciseKeys.length; i += 3) {
        final endIndex =
            (i + 3 < exerciseKeys.length) ? i + 3 : exerciseKeys.length;
        final setKeys = exerciseKeys.sublist(i, endIndex);
        final setExercises =
            setKeys.map((key) => widget.dObj['exercises'][key]).toList();
        final Map<dynamic, dynamic> setMap = {};
        for (int j = 0; j < setKeys.length; j++) {
          setMap[setKeys[j]] = setExercises[j];
        }
        exerciseSets.add(setMap);
      }
    });
  }

  List latestArr = [
    {
      "image": "assets/img/Workout1.png",
      "title": "Fullbody Workout",
      "time": "Today, 03:00pm"
    },
    {
      "image": "assets/img/Workout2.png",
      "title": "Upperbody Workout",
      "time": "June 05, 02:00pm"
    },
  ];

  List youArr = [
    {"image": "assets/img/barbell.png", "title": "Barbell"},
    {"image": "assets/img/skipping_rope.png", "title": "Skipping Rope"},
    {"image": "assets/img/bottle.png", "title": "Bottle 1 Liters"},
  ];
  void _displayExercise(media) {
    var currentSet = {};
    // Get the current set
    if (exerciseSets != []) {
      currentSet = exerciseSets[_currentExerciseIndex];
    } else {
      print(exerciseSets);
    }
    if (currentSet != {}) {
      // Get the current exercise in the set
      var currentExercise =
          currentSet.values.elementAt(_currentExerciseIndexInSet);
        flutterTts.speak('OK');

      // Show the exercise image fullscreen
      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing the dialog on tap outside
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              children: [
                Image.network(
                  'http://10.0.2.2:8000/uploads/exercise/${currentExercise['image']}',
                  height: media.height * 1,
                  width: media.width,
                  fit: BoxFit.contain,
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _nextExercise(media);
                        },
                        child: const Text('Next'),
                      ),
                      SizedBox(width: 10), // Add some spacing between buttons
                      TextButton(
                        onPressed: () {
                          dispose();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

      // Increment the exercise index for the next iteration
      _currentExerciseIndexInSet++;

      // Check if the current set is finished
      if (_currentExerciseIndexInSet >= currentSet.length) {
        // Wait for 30 seconds before moving to the next set
        Future.delayed(Duration(seconds: 30), () {
          _nextSet(media);
        });
      } else {
        // Wait for 10 seconds before displaying the next exercise in the same set
        Future.delayed(Duration(seconds: 10), () {
          _displayExercise(media);
        });
      }
    }
  }

  void _nextExercise(media) {
    // Close the fullscreen exercise image dialog
    Navigator.of(context).pop();

    // Check if all sets have been displayed
    if (_currentExerciseIndexInSet >= exerciseSets.length) {
      // Workout finished
      return;
    }

    // Display the next exercise
    _displayExercise(media);
  }

  void _nextSet(media) {
    // Check if all sets have been displayed
    if (_currentExerciseIndex >= exerciseSets.length) {
      // Workout finished
      return;
    }
    // Increment the set index for the next iteration
    _currentExerciseIndex++;

    // Reset the exercise index in the set
    _currentExerciseIndexInSet = 0;

    // Display the next set
    _displayExercise(media);
  }

  @override
  void dispose() {
    // Dispose the timer when the screen is disposed
    _workoutTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
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
                child: Image.asset(
                  "assets/img/detail_top.png",
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
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dObj["name"].toString(),
                                  style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "${widget.dObj["exercises"].length} exercises | ${widget.dObj["exercises"].length} mins | ${totalCaloriesBurned.round()} Calories Burn",
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
                          time: "5/27, 09:00 AM",
                          color: TColor.primaryColor2.withOpacity(0.3),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WorkoutScheduleView()));
                          }),
                      SizedBox(
                        height: media.width * 0.02,
                      ),
                      IconTitleNextRow(
                          icon: "assets/img/difficulity.png",
                          title: "Difficulity",
                          time: "Beginner",
                          color: TColor.secondaryColor2.withOpacity(0.3),
                          onPressed: () {}),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              style:
                                  TextStyle(color: TColor.gray, fontSize: 12),
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
                                                BorderRadius.circular(15)),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          yObj["image"].toString(),
                                          width: media.width * 0.2,
                                          height: media.width * 0.2,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              "${youArr.length} Sets",
                              style:
                                  TextStyle(color: TColor.gray, fontSize: 12),
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
                            var sObj = exerciseSets[index] as Map? ?? {};
                            return ExercisesSetSection(
                              sObj: sObj,
                              set: index.toString(),
                              onPressed: (obj) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExercisesStepDetails(
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
                            _displayExercise(media);
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
