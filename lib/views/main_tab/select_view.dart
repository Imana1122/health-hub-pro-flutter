import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/views/chat/main_chat_screen.dart';
import 'package:fyp_flutter/views/dietician_booking/dietician_list.dart';
import 'package:fyp_flutter/views/meal_planner/meal_planner_view.dart';
import 'package:fyp_flutter/views/workout_tracker/workout_tracker_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectView extends StatefulWidget {
  const SelectView({super.key});

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(
              title: "Workout Tracker",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutTrackerView(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            RoundButton(
              title: "Meal Planner",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MealPlannerView(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            RoundButton(
              title: "Book Dietician",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DieticianListView(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            RoundButton(
              title: "Chat",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainChatScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
