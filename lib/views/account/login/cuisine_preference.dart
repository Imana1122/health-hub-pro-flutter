import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/views/account/login/allergen_filter.dart';
import 'package:fyp_flutter/views/account/login/login_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
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
      user = authProvider.getAuthenticatedUser();
      _fetchCuisines();
    }
  }

  _fetchCuisines() async {
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      isLoading = false;
    });
  }

  void _toggleCuisineSelection(String cuisineId) {
    setState(() {
      isLoading = true;
    });
    setState(() {
      if (selectedCuisines.contains(cuisineId)) {
        selectedCuisines.remove(cuisineId);
      } else {
        selectedCuisines.add(cuisineId);
      }
      isLoading = false;
    });
  }

  Future<void> _confirmButtonPressed() async {
    setState(() {
      isLoading = true;
    });
    try {
      var result =
          await authProvider.setCuisinePreferences(cuisines: selectedCuisines);

      if (result == true) {
        if (user.cuisines.isNotEmpty) {
          Navigator.pushNamed(context, '/profile');
        }
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
        : AuthenticatedLayout(
            child: Scaffold(
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
                        itemCount: cuisineArr.length,
                        itemBuilder: (context, index) {
                          var gObj = cuisineArr[index];
                          bool isSelected =
                              selectedCuisines.contains(gObj["id"]);
                          return GestureDetector(
                            onTap: () {
                              _toggleCuisineSelection(gObj["id"]);
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
                                    color: isSelected
                                        ? TColor.white
                                        : TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                trailing: Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color:
                                      isSelected ? TColor.white : TColor.black,
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
            ),
          );
  }
}
