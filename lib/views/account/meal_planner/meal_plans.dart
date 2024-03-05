import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/meal_plan_service.dart';
import 'package:provider/provider.dart';

class MealPlans extends StatefulWidget {
  const MealPlans({super.key});

  @override
  State<MealPlans> createState() => _MealPlansState();
}

class _MealPlansState extends State<MealPlans> {
  late AuthProvider authProvider;
  List<dynamic> mealPlans = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    // Access the authentication provider
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if the user is already logged in
    if (!authProvider.isLoggedIn) {
      // Navigate to DieticianProfilePage and replace the current route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context,
            '/'); // Replace '/dietician-profile' with the route of DieticianProfilePage
      });
    }
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      isLoading = true;
    });
    var fetchedData = await MealPlanService(authProvider)
        .getMealPlans(); // Convert type to lowercase

    setState(() {
      mealPlans = fetchedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);
    return isLoading
        ? SizedBox(
            height: media.height,
            width: media.width,
            child: const CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: TColor.primaryColor1,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              title: const Text('Meal Planner'),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 3,
                        vertical: SizeConfig.safeBlockHorizontal * 3),
                    itemCount: mealPlans.length,
                    itemBuilder: (context, index) {
                      return RoundButton(
                          onPressed: () {}, title: "Meal Plan $index");
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
