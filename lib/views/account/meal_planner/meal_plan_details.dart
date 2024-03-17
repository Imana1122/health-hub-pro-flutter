import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/meal_plans_cards/meal_plan_details_row.dart';
import 'package:fyp_flutter/common_widget/nutritions_row.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/meal_plan_service.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

class MealPlanDetails extends StatefulWidget {
  final Map mealPlan;
  const MealPlanDetails({super.key, required this.mealPlan});
  @override
  State<MealPlanDetails> createState() => _MealPlanDetailsState();
}

class _MealPlanDetailsState extends State<MealPlanDetails> {
  late User user;
  List nutritionArr = [];
  @override
  void initState() {
    super.initState();
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.getAuthenticatedUser();

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

  void _loadDetails() async {
    nutritionArr = [
      {
        "title": "Calories",
        "image": "assets/img/burn.png",
        "unit_name": "kCal",
        "value": widget.mealPlan['calories'].toString(),
        "max_value": user.profile.calories,
      },
      {
        "title": "Proteins",
        "image": "assets/img/proteins.png",
        "unit_name": "g",
        "value": widget.mealPlan['protein'].toString(),
        "max_value": user.profile.protein,
      },
      {
        "title": "Fats",
        "image": "assets/img/egg.png",
        "unit_name": "g",
        "value": widget.mealPlan['total_fat'].toString(),
        "max_value": user.profile.totalFat,
      },
      {
        "title": "Carbo",
        "image": "assets/img/carbo.png",
        "unit_name": "g",
        "value": widget.mealPlan['carbohydrates'].toString(),
        "max_value": user.profile.carbohydrates,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);
    return AuthenticatedLayout(
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
            widget.mealPlan['name'],
            style: TextStyle(
                color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "BreakFast",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    MealPlanDetailsRow(
                        mObj: widget.mealPlan['breakfast_recipe'],
                        dObj: MealType.fromJson(
                            widget.mealPlan['breakfast_recipe']['meal_type'])),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Lunch",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    MealPlanDetailsRow(
                        mObj: widget.mealPlan['lunch_recipe'],
                        dObj: MealType.fromJson(
                            widget.mealPlan['lunch_recipe']['meal_type'])),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Snacks",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    MealPlanDetailsRow(
                        mObj: widget.mealPlan['snack_recipe'],
                        dObj: MealType.fromJson(
                            widget.mealPlan['snack_recipe']['meal_type'])),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Dinner",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    MealPlanDetailsRow(
                        mObj: widget.mealPlan['dinner_recipe'],
                        dObj: MealType.fromJson(
                            widget.mealPlan['dinner_recipe']['meal_type'])),
                  ],
                ),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Today Meal Nutritions",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: nutritionArr.length,
                  itemBuilder: (context, index) {
                    var nObj = nutritionArr[index] as Map? ?? {};

                    return NutritionRow(
                      nObj: nObj,
                    );
                  }),
              SizedBox(
                height: media.height * 0.1,
              ),
              RoundButton(
                  title: 'Select',
                  onPressed: () async {
                    AuthProvider authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    await MealPlanService(authProvider).selectMealPlan(
                        mealPlanId: widget.mealPlan['id'],
                        token: authProvider.getAuthenticatedToken());
                    Navigator.pushNamed(context, '/');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
