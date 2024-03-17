import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/meal_plans_cards/meal_plan_card.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/meal_plan_service.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

class MealPlans extends StatefulWidget {
  const MealPlans({super.key});

  @override
  State<MealPlans> createState() => _MealPlansState();
}

class _MealPlansState extends State<MealPlans> {
  late AuthProvider authProvider;
  List<dynamic> mealPlans = [];
  int pageNumber = 1;
  int lastPage = 1;
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
      mealPlans = fetchedData['data'];
      pageNumber = fetchedData['current_page'];
      lastPage = fetchedData['to'];
      isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    if (pageNumber < lastPage) {
      setState(() {
        isLoading = true;
        pageNumber += 1;
      });
      var fetchedData = await MealPlanService(authProvider)
          .getMealPlans(currentPage: pageNumber); // Convert type to lowercase

      setState(() {
        mealPlans.addAll(fetchedData['data']);

        pageNumber = fetchedData['current_page'];
        lastPage = fetchedData['to'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);
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
              backgroundColor: TColor.lightGray,
              appBar: AppBar(
                backgroundColor: TColor.white,
                centerTitle: true,
                elevation: 0,
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      "assets/img/black_btn.png",
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Text(
                  'Meal Planner',
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              body: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.safeBlockHorizontal * 3,
                            vertical: SizeConfig.safeBlockHorizontal * 3),
                        itemCount: mealPlans.length,
                        itemBuilder: (context, index) {
                          var mObj = mealPlans[index];
                          mObj['name'] = "Meal Plan $index";
                          return MealPlanCard(mObj: mObj);
                        },
                      ),
                    ),
                    SizedBox(
                      height: media.height * 0.1,
                    ),
                    RoundButton(
                        title: 'More',
                        onPressed: () {
                          _loadMore();
                        })
                  ],
                ),
              ),
            ),
          );
  }
}
