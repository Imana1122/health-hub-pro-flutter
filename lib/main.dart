import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/providers/dietician_conversation_provider.dart';
import 'package:fyp_flutter/views/account/login/allergen_filter.dart';
import 'package:fyp_flutter/views/account/login/cuisine_preference.dart';
import 'package:fyp_flutter/views/account/login/health_condition_filter.dart';
import 'package:fyp_flutter/views/dietician/layout.dart';
import 'package:fyp_flutter/views/dietician/profile/dietician_change_password.dart';
import 'package:fyp_flutter/views/dietician/profile/dietician_profile_view.dart';
import 'package:fyp_flutter/views/dietician/profile/update_dietician.dart';
import 'package:fyp_flutter/views/account/login/change_password.dart';
import 'package:fyp_flutter/views/account/login/complete_profile_view.dart';
import 'package:fyp_flutter/views/dietician/login/dietician_login_view.dart';
import 'package:fyp_flutter/views/dietician/login/dietician_signup_view.dart';
import 'package:fyp_flutter/views/account/login/login_view.dart';
import 'package:fyp_flutter/views/account/login/signup_view.dart';
import 'package:fyp_flutter/views/account/login/update_personal_info.dart';
import 'package:fyp_flutter/views/account/login/what_your_goal_view.dart';
import 'package:fyp_flutter/views/account/main_tab/main_tab_view.dart';
import 'package:fyp_flutter/views/account/meal_recipes/meal_planner_view.dart';
import 'package:fyp_flutter/views/account/profile/profile_view.dart';
import 'package:fyp_flutter/views/user_selection/user_type_selection_page.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/common/theme.dart' as theme;
import 'package:fyp_flutter/common/settings.dart' as settings;

void main() async {
  await dotenv.load(); // Load the environment variables from the .env file

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Fluttertoast before runApp
    Fluttertoast.showToast;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DieticianAuthProvider()),
        ChangeNotifierProvider(create: (context) => ConversationProvider()),
        ChangeNotifierProvider(
            create: (context) => DieticianConversationProvider()),
      ],
      child: MaterialApp(
        title: 'HealthHub Pro',
        theme: settings.isDarkMode ? theme.darkTheme : theme.lightTheme,
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const LoginView(),
          '/register': (context) => const SignUpView(),
          '/profile': (context) => const ProfileView(),
          '/complete-profile': (context) => const CompleteProfileView(),
          '/choose-goal': (context) => const WhatYourGoalView(),
          '/cuisine-preferences': (context) => const CuisinePreference(),
          '/allergen-filtration': (context) => const AllergenPreference(),
          '/health-condition-filtration': (context) =>
              const HealthConditionPreference(),

          '/update-personal-data': (context) => const ProfileEditView(),
          '/dashboard': (context) => const WhatYourGoalView(),
          '/personal-activity': (context) => const WhatYourGoalView(),
          '/workout-progress': (context) => const WhatYourGoalView(),
          '/change-password': (context) => const ChangePassword(),
          '/privacy-policy': (context) => const ChangePassword(),
          '/contact-us': (context) => const ChangePassword(),
          '/meal-planner': (context) => const MealPlannerView(),

          // Dietician Routes
          '/login-dietician': (context) => const DieticianLoginView(),
          '/register-dietician': (context) => const DieticianSignUpView(),
          '/dietician-change-password': (context) =>
              const DieticianChangePassword(),
          '/dietician-profile': (context) => const DieticianProfileView(),
          '/dietician-update-profile': (context) =>
              const DieticianProfileEditView(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dieticianAuthProvider = Provider.of<DieticianAuthProvider>(context);

    if (authProvider.isLoggedIn) {
      return const MainTabView();
    } else if (dieticianAuthProvider.isLoggedIn) {
      return const DieticianCommonLayout();
    } else {
      return const UserTypeSelectionPage();
    }
  }
}
