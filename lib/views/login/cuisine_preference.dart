import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/views/login/allergen_filter.dart';
import 'package:fyp_flutter/views/login/login_view.dart';
import 'package:provider/provider.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class CuisinePreference extends StatefulWidget {
  const CuisinePreference({super.key});

  @override
  State<CuisinePreference> createState() => _CuisinePreferenceState();
}

class _CuisinePreferenceState extends State<CuisinePreference> {
  List cuisineArr = [];
  List<String> selectedCuisines = [];
  late User user;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      // If the user is not logged in, navigate to the login page
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const LoginView(), // Replace LoginPage with your actual login page
          ),
        );
      });
    } else {
      user = authProvider.getAuthenticatedUser();
      _fetchCuisines();
    }
  }

  _fetchCuisines() async {
    try {
      var cuisines = await authProvider.getCuisines();
      setState(() {
        cuisineArr = cuisines;
        selectedCuisines =
            user.cuisines.map((cuisine) => cuisine['id'].toString()).toList();
      });
    } catch (e) {
      print("Error fetching cuisines: $e");
    }
  }

  void _toggleCuisineSelection(String cuisineId) {
    setState(() {
      if (selectedCuisines.contains(cuisineId)) {
        selectedCuisines.remove(cuisineId);
      } else {
        selectedCuisines.add(cuisineId);
      }
    });
  }

  Future<void> _confirmButtonPressed() async {
    try {
      var result =
          await authProvider.setCuisinePreferences(cuisines: selectedCuisines);

      if (result == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AllergenPreference(),
          ),
        );
      } else {
        print("Error setting cuisine preferences");
        // Handle unsuccessful setCuisines, show an error message if needed
      }
    } catch (e) {
      print("Error: $e");
      // Handle errors, show a message to the user if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "What is your cuisine preference?",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Only choose if you want to filter based on cuisines.",
                    style: TextStyle(
                      color: TColor.gray, // You can adjust the color as needed
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cuisineArr.length,
                itemBuilder: (context, index) {
                  var gObj = cuisineArr[index];
                  bool isSelected = selectedCuisines.contains(gObj["id"]);
                  return GestureDetector(
                    onTap: () {
                      _toggleCuisineSelection(gObj["id"]);
                    },
                    child: Card(
                      color: isSelected ? TColor.primaryColor1 : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          gObj["name"].toString(),
                          style: TextStyle(
                            color: isSelected ? TColor.white : TColor.black,
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
