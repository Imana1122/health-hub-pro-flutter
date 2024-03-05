import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/views/account/login/login_view.dart';
import 'package:fyp_flutter/views/account/login/welcome_view.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';

class HealthConditionPreference extends StatefulWidget {
  const HealthConditionPreference({super.key});

  @override
  State<HealthConditionPreference> createState() =>
      _HealthConditionPreferenceState();
}

class _HealthConditionPreferenceState extends State<HealthConditionPreference> {
  List healthConditionArr = [];
  List<String> selectedHealthConditions = [];
  late User user;
  late AuthProvider authProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      // If the user is not logged in, navigate to the login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const LoginView(), // Replace LoginPage with your actual login page
          ),
        );
      });
    } else {
      // If the user is logged in, fetch the authenticated user data
      user = authProvider.getAuthenticatedUser();
      _fetchHealthConditions();
    }
  }

  _fetchHealthConditions() async {
    setState(() {
      isLoading = true;
    });
    try {
      var healthConditions = await authProvider.getHealthConditions();
      setState(() {
        healthConditionArr = healthConditions;

        // Initialize selectedHealthConditions here
        selectedHealthConditions = user.healthConditions
            .map((healthCondition) => healthCondition['id'].toString())
            .toList();
      });
    } catch (e) {
      print("Error fetching healthConditions: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  void _toggleHealthConditionSelection(String healthConditionId) {
    setState(() {
      isLoading = true;
    });
    setState(() {
      if (selectedHealthConditions.contains(healthConditionId)) {
        selectedHealthConditions.remove(healthConditionId);
      } else {
        selectedHealthConditions.add(healthConditionId);
      }
      isLoading = false;
    });
  }

  Future<void> _confirmButtonPressed() async {
    setState(() {
      isLoading = true;
    });
    try {
      var result = await authProvider.setHealthConditions(
          healthConditions: selectedHealthConditions);

      if (result == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeView(),
          ),
        );
      } else {
        print("Error setting healthCondition preferences");
        // Handle unsuccessful setHealthConditions, show an error message if needed
      }
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
        : Scaffold(
            backgroundColor: TColor.white,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What is your healthCondition preference?",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Only choose if you want to filter based on healthConditions.",
                          style: TextStyle(
                            color: TColor
                                .gray, // You can adjust the color as needed
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: healthConditionArr.length,
                      itemBuilder: (context, index) {
                        var gObj = healthConditionArr[index];
                        bool isSelected =
                            selectedHealthConditions.contains(gObj["id"]);
                        return GestureDetector(
                          onTap: () {
                            _toggleHealthConditionSelection(gObj["id"]);
                          },
                          child: Card(
                            color: isSelected ? TColor.primaryColor1 : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              title: Text(
                                gObj["name"].toString(),
                                style: TextStyle(
                                  color:
                                      isSelected ? TColor.white : TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              trailing: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isSelected ? TColor.white : TColor.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RoundButton(
                      title: "Next",
                      onPressed: _confirmButtonPressed,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
