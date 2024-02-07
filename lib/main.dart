import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/views/dietician/home.dart';
import 'package:fyp_flutter/views/login/change_password.dart';
import 'package:fyp_flutter/views/login/complete_profile_view.dart';
import 'package:fyp_flutter/views/login/dietician/dietician_login_view.dart';
import 'package:fyp_flutter/views/login/dietician/dietician_signup_view.dart';
import 'package:fyp_flutter/views/login/login_view.dart';
import 'package:fyp_flutter/views/login/signup_view.dart';
import 'package:fyp_flutter/views/login/update_personal_info.dart';
import 'package:fyp_flutter/views/login/what_your_goal_view.dart';
import 'package:fyp_flutter/views/main_tab/main_tab_view.dart';
import 'package:fyp_flutter/views/on_boarding/on_boarding_view.dart';
import 'package:fyp_flutter/views/profile/profile_view.dart';
import 'package:fyp_flutter/views/user_selection/user_type_selection_page.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(MyApp(key: UniqueKey()));
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
      ],
      child: MaterialApp(
        title: 'HealthHub Pro',
        theme: ThemeData(
          primaryColor: TColor.primaryColor1,
          fontFamily: "Poppins",
        ),
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const LoginView(),
          '/register': (context) => const SignUpView(),
          '/profile': (context) => const ProfileView(),
          '/complete-profile': (context) => const CompleteProfileView(),
          '/choose-goal': (context) => const WhatYourGoalView(),
          '/update-personal-data': (context) => const ProfileEditView(),
          '/dashboard': (context) => const WhatYourGoalView(),
          '/personal-activity': (context) => const WhatYourGoalView(),
          '/workout-progress': (context) => const WhatYourGoalView(),
          '/change-password': (context) => const ChangePassword(),
          '/privacy-policy': (context) => const ChangePassword(),
          '/contact-us': (context) => const ChangePassword(),
          '/login-dietician': (context) => const DieticianLoginView(),
          '/register-dietician': (context) => const DieticianSignUpView(),
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
      return const DieticianProfilePage();
    } else {
      return const UserTypeSelectionPage();
    }
  }
}
