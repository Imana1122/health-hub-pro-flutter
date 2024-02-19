import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/views/login/dietician/dietician_signup_view.dart';
import 'package:fyp_flutter/views/on_boarding/on_boarding_view.dart';

class UserTypeSelectionPage extends StatelessWidget {
  const UserTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [TColor.primaryColor2, TColor.primaryColor1],
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Hello,",
              style: TextStyle(color: TColor.gray, fontSize: 16),
            ),
            Text(
              "Choose User Type",
              style: TextStyle(
                color: TColor.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        centerTitle: true, // Center the title horizontally
        elevation: 4, // Add some elevation to the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo.gif',
                width: media.width * 0.5,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              RoundButton(
                title: "Dietician",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DieticianSignUpView(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              RoundButton(
                title: "Regular User",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnBoardingView(),
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
