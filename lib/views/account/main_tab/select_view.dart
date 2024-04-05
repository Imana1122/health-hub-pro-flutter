import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/views/account/bookmarks/bookmarks.dart';
import 'package:fyp_flutter/views/account/chat/main_chat_screen.dart';
import 'package:fyp_flutter/views/account/customize_workout/workout_form.dart';
import 'package:fyp_flutter/views/account/dietician_subscription/dietician_list.dart';
import 'package:fyp_flutter/views/account/dietician_subscription/payment_details.dart';
import 'package:fyp_flutter/views/account/dietician_subscription/subscription_details.dart';
import 'package:fyp_flutter/views/account/meal_recipes/meal_planner_view.dart';
import 'package:fyp_flutter/views/account/workout_tracker/customized_workout_view.dart';
import 'package:fyp_flutter/views/account/workout_tracker/workout_tracker_view.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';

class SelectView extends StatefulWidget {
  const SelectView({super.key});

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  @override
  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundButton(
                title: "Bookmarked Recipes",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Bookmarks(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              RoundButton(
                title: "Customized Workouts",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomizedWorkoutView(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              RoundButton(
                title: "Customize Workout",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutForm(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
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
                title: "Subscription",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionDetails(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              RoundButton(
                title: "Payments",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentDetails(),
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
      ),
    );
  }
}
