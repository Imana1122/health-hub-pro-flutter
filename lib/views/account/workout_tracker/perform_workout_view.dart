import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/workout_recommendation_service.dart';
import 'package:fyp_flutter/views/account/home/finished_workout_view.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:provider/provider.dart';

class PerformWorkoutView extends StatefulWidget {
  final List<Map<dynamic, dynamic>> set;
  final Map dObj;

  const PerformWorkoutView({super.key, required this.set, required this.dObj});

  @override
  State<PerformWorkoutView> createState() => _PerformWorkoutViewState();
}

class _PerformWorkoutViewState extends State<PerformWorkoutView> {
  int _currentSet = 0;
  int _currentExerciseIndexInSet = 0;
  late AuthProvider authProvider;
  late User user;
  late FlutterTts flutterTts;
  List<Map<dynamic, dynamic>> exerciseSets = [];
  bool isLoading = false;
  bool continueCountdown = true;
  int exerciseDuration = 10;

  String startedAt = '';
  String endedAt = '';
  int completionStatus = 0;
  double totalCaloriesBurned = 0;
  int restDuration = 10;
  int setsCount = 0;
  bool isRest = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.getAuthenticatedUser();
    exerciseSets = widget.set;
    flutterTts = FlutterTts();
    setsCount = exerciseSets.length;
    _startWorkout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: Text(
          "Perform Workout",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: _currentSet < setsCount
          ? isRest
              ? _buildRestWidget()
              : _buildExerciseWidget()
          : const Center(
              child: Text('Workout Finished'),
            ),
    );
  }

  Widget _buildRestWidget() {
    var currentSet = exerciseSets[_currentSet];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Get Ready',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Get Ready in $restDuration seconds',
            style: const TextStyle(fontSize: 18),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SimpleAnimationProgressBar(
                height: 10,
                width: MediaQuery.of(context).size.width - 120,
                backgroundColor: TColor.primaryColor1,
                foregrondColor: const Color(0xffFFB2B1),
                ratio:
                    (_currentExerciseIndexInSet) / currentSet.length.toDouble(),
                direction: Axis.horizontal,
                curve: Curves.linear,
                duration: const Duration(seconds: 0),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Text('Set ${_currentSet + 1} of $setsCount'),
        ],
      ),
    );
  }

  Widget _buildExerciseWidget() {
    var currentSet = exerciseSets[_currentSet];
    var currentExercise =
        currentSet.values.elementAt(_currentExerciseIndexInSet);
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Image.network(
                'http://10.0.2.2:8000/storage/uploads/exercise/${currentExercise['image']}',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SimpleAnimationProgressBar(
                    height: 10,
                    width: MediaQuery.of(context).size.width - 120,
                    backgroundColor: TColor.primaryColor1,
                    foregrondColor: const Color(0xffFFB2B1),
                    ratio: (_currentExerciseIndexInSet + 1) /
                        currentSet.length.toDouble(),
                    direction: Axis.horizontal,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(seconds: 3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(currentExercise["name"]),
        Text('Set ${_currentSet + 1} of $setsCount'),
        ElevatedButton(
          onPressed: () {
            _cancelWorkout();
          },
          child: const Text('Cancel Workout'),
        ),
      ],
    );
  }

  Future<void> _startWorkout() async {
    // Start workout
    setState(() {
      isRest = true;

      startedAt = DateTime.now().toIso8601String();
    });

    await _speak('Get Ready');
    for (int i = restDuration; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      await _speak('$i ');
    }
    setState(() {
      isRest = false;
    });
    _displayExercise();
  }

  Future<void> _displayExercise() async {
    var currentSet = exerciseSets[_currentSet];
    var currentExercise =
        currentSet.values.elementAt(_currentExerciseIndexInSet);
    await _speak(currentExercise["name"]);

    // Wait for exercise duration
    await Future.delayed(
        Duration(seconds: exerciseDuration)); // Adjust duration as needed

    // Move to next exercise or set
    _nextExerciseOrSet();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setSpeechRate(0.5); // Adjust the value as needed
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    var language = 'en-US';
    var isLanguageAvailable = await flutterTts.isLanguageAvailable(language);
    if (isLanguageAvailable) {
      await flutterTts.setLanguage(language);
      await flutterTts.speak(text);
    }
  }

  void _nextExerciseOrSet() {
    setState(() {
      var currentSet = exerciseSets[_currentSet];
      var currentExercise =
          currentSet.values.elementAt(_currentExerciseIndexInSet);
      // Calculate calories burned for the current exercise
      double metabolicEquivalent =
          currentExercise['metabolic_equivalent'].toDouble();
      double weightKg =
          authProvider.getAuthenticatedUser().profile.weight.toDouble();
      double durationMinutes = 1.0; // Duration of each exercise in minutes
      double durationHours =
          durationMinutes / 60.0; // Convert duration from minutes to hours
      double caloriesBurned = metabolicEquivalent * weightKg * durationHours;
      totalCaloriesBurned += caloriesBurned;
      _currentExerciseIndexInSet++;
      if (_currentExerciseIndexInSet >= exerciseSets[_currentSet].length) {
        _currentSet++;
        _currentExerciseIndexInSet = 0;
        if (_currentSet < setsCount) {
          _startRestTimer();
        } else {
          _endWorkout();
        }
      } else {
        _startRestTimer();
      }
    });
  }

  void _startRestTimer() async {
    setState(() {
      isRest = true;
    });
    await _speak('Rest for $restDuration seconds');
    for (int i = restDuration; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      await _speak('$i ');
    }
    setState(() {
      isRest = false;
    });
    _displayExercise();
  }

  void _endWorkout() async {
    setState(() {
      endedAt = DateTime.now().toIso8601String();
      completionStatus = 1;
      isLoading = true;
    });
    await WorkoutRecommendationService(authProvider).logWorkout(
      workoutId: widget.dObj['id'],
      caloriesBurned: totalCaloriesBurned,
      workoutName: widget.dObj['name'],
      startAt: startedAt,
      endAt: endedAt,
      completionStatus: completionStatus,
      type: widget.dObj['user_id'] == null ? null : 'customized',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinishedWorkoutView(),
      ),
    );
  }

  void _cancelWorkout() {
    setState(() {
      continueCountdown = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Workout'),
          content: const Text('Are you sure you want to cancel the workout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _endWorkout();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  continueCountdown = true;
                });
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
