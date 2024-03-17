import 'package:flutter/material.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/views/account/login/login_view.dart';
import 'package:fyp_flutter/views/dietician/login/dietician_login_view.dart';
import 'package:fyp_flutter/views/layouts/unauthenticated_layout.dart';

class UserTypeSelectionPage extends StatelessWidget {
  const UserTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return UnauthenticatedLayout(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/logo.gif',
                  width: media.width * 0.8,
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
                        builder: (context) => const DieticianLoginView(),
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
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
