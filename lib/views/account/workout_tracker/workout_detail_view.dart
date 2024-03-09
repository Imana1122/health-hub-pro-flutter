import 'dart:async';

import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/icon_title_next_row.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/workout_recommendation_service.dart';
import 'package:fyp_flutter/views/account/workout_tracker/workout_tracker_view.dart';
import 'package:provider/provider.dart';
import 'exercises_step_details.dart';
import 'workout_schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../common_widget/exercises_set_section.dart';

class WorkoutDetailView extends StatefulWidget {
  final Map dObj;
  const WorkoutDetailView({super.key, required this.dObj});

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  final List<Map<dynamic, dynamic>> exerciseSets = [];
  double caloriesBurned = 0.0;
  late AuthProvider authProvider;
  // Define a timer for the workout
  int _currentExerciseIndex = 0;
  int _currentExerciseIndexInSet = 0;
  final FlutterTts flutterTts = FlutterTts();
  int gapBetweenExercises = 2;
  int exerciseDuration = 5;
  int gapBetweenSets = 3;
  int noOfDialogs = 1;
  double totalCaloriesBurned = 0;
  late User user;
  String startedAt = '';
  String endedAt = '';
  int completionStatus = 0;
  bool continueCountdown = true; // Add a flag to control the countdown
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loadWorkouts();
    user = authProvider.getAuthenticatedUser();

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
      isLoading = false;
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
    {"image": "assets/img/bottle.png", "title": "Bottle 1 Liters"},
  ];

  Future<void> submitWorkoutDone() async {
    setState(() {
      isLoading = true;
    });
    try {
      await WorkoutRecommendationService(authProvider).logWorkout(
        workoutId: widget.dObj['id'],
        caloriesBurned: totalCaloriesBurned,
        workoutName: widget.dObj['name'],
        startAt: startedAt,
        endAt: endedAt,
        completionStatus: completionStatus,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutDetailView(
            dObj: widget.dObj,
          ),
        ),
      );
    } catch (e) {
      print("Error: $e");
      // Handle errors, show a message to the user if needed
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
        : Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  var sObj = exerciseSets[index] as Map? ?? {};
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
                                  _currentExerciseIndex = 0;
                                  _currentExerciseIndexInSet = 0;
                                  _startWorkout(media, 5);
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

  Future<void> _displayExercise(media) async {
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
      // var language = 'en-US';
      // var isLanguageAvailable = await flutterTts.isLanguageAvailable(language);
      // if (isLanguageAvailable) {
      //   await flutterTts.setLanguage(language);
      //   await flutterTts.speak(currentExercise["name"]);
      // } else {
      //   print('Language $language is not available on this device.');
      // }
      noOfDialogs += 1;
      startedAt = DateTime.now().toIso8601String();
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
                          popContextMultipleTimes(context);
                          endedAt = DateTime.now().toIso8601String();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Workout cancelled!',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                          submitWorkoutDone();
                          return;
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
        Future.delayed(Duration(seconds: exerciseDuration), () {
          double calories = currentExercise["metabolic_equivalent"] *
              user.profile.weight /
              60;
          totalCaloriesBurned += calories;
          showCountdownDialog(media, gapBetweenSets, 'REST AND START NEW SET');

          Future.delayed(Duration(seconds: gapBetweenSets), () {
            _nextSet(media);
          });
        });
      } else {
        // Wait for 45 seconds before displaying the next exercise in the same set
        Future.delayed(Duration(seconds: exerciseDuration), () async {
          double calories = currentExercise["metabolic_equivalent"] *
              user.profile.weight /
              60;
          totalCaloriesBurned += calories;
          // if (isLanguageAvailable) {
          //   var currentExercise =
          //       currentSet.values.elementAt(_currentExerciseIndexInSet);
          //   await flutterTts.setLanguage(language);
          //   await flutterTts.speak(currentExercise["name"]);
          // } else {
          //   print('Language $language is not available on this device.');
          // }

          showCountdownDialog(media, gapBetweenExercises,
              'REST AND BE READY FOR NEXT EXERCISE');
          Future.delayed(Duration(seconds: gapBetweenExercises), () {
            _displayExercise(media);
          });
        });
      }
    }
  }

  void popContextMultipleTimes(BuildContext context) {
    continueCountdown = false;

    for (int i = 0; i < noOfDialogs; i++) {
      Navigator.pop(context);
    }
  }

  void showCountdownDialog(Size media, int seconds, String txt) {
    if (seconds > 0 && continueCountdown) {
      noOfDialogs += 1;

      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing the dialog on tap outside
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              children: [
                SizedBox(
                  height: media.height * 1,
                  width: media.width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$txt | ${(_currentExerciseIndex + 1).toString()} Set",
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 10), // Add spacing
                        Text(
                          "$seconds remaining", // Countdown timer
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      // Decrement seconds and schedule the next dialog
      Future.delayed(const Duration(seconds: 1), () {
        if (continueCountdown) {
          seconds -= 1;

          showCountdownDialog(media, seconds, txt); // Recursive call
        }
      });
    }
  }

  void _startWorkout(Size media, int seconds) {
    if (seconds > 0 && continueCountdown) {
      noOfDialogs += 1;

      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing the dialog on tap outside
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              children: [
                SizedBox(
                  height: media.height * 1,
                  width: media.width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BE READY FOR WORKOUT | ${(_currentExerciseIndex + 1).toString()} Set",
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 10), // Add spacing
                        Text(
                          "$seconds remaining", // Countdown timer
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      // Decrement seconds and schedule the next dialog
      Future.delayed(const Duration(seconds: 1), () {
        if (continueCountdown) {
          setState(() {
            seconds -= 1;
          });

          _startWorkout(media, seconds); // Recursive call
        }
      });
    } else {
      _displayExercise(media);
    }
  }

  void _nextSet(media) {
    // Increment the set index for the next iteration
    _currentExerciseIndex++;

    // Check if all sets have been displayed
    if (_currentExerciseIndex >= exerciseSets.length) {
      // Workout finished
      popContextMultipleTimes(context);
      endedAt = DateTime.now().toIso8601String();
      completionStatus = 1;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: TColor.secondaryColor1,
          content: const Text(
            'Congratulations! You successfully completed workout.',
            textAlign: TextAlign.center,
          ),
        ),
      );
      submitWorkoutDone();

      return;
    } else {
      // Reset the exercise index in the set
      _currentExerciseIndexInSet = 0;

      // Display the next set
      _displayExercise(media);
    }
  }
}
