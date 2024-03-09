import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/recipe_recommendation_service.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/meal_food_schedule_row.dart';
import '../../../common_widget/nutritions_row.dart';
import 'package:fyp_flutter/models/meal_type.dart';

class MealScheduleView extends StatefulWidget {
  const MealScheduleView({super.key});

  @override
  State<MealScheduleView> createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  final CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();

  List breakfastArr = [];
  List<dynamic> mealTypes = [];
  List lunchArr = [];
  List snacksArr = [];
  List dinnerArr = [];
  late AuthProvider authProvider;
  bool isLoading = false;
  List nutritionArr = [];
  DateTime selectedDate = DateTime.now();
  late User user;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.getAuthenticatedUser();

    // Check if the user is already logged in
    if (!authProvider.isLoggedIn) {
      // Navigate to DieticianProfilePage and replace the current route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context,
            '/'); // Replace '/dietician-profile' with the route of DieticianProfilePage
      });
    }
    _loadMealLogs();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      isLoading = true;
    });
    var result = await RecipeRecommendationService(authProvider).getMealTypes();

    setState(() {
      mealTypes = result;
      isLoading = false;
    });
  }

  Future<void> _loadMealLogs() async {
    setState(() {
      isLoading = true;
    });

    var result = await authProvider.getMealLogs();
    List<dynamic> mealLogs = result['recipeLogs'];
    var userNutrients = result['userNutrients'];
    setState(() {
      lunchArr = mealLogs.where((meal) {
        // Check if meal['recipe']['meal_type_id'] matches the selected meal type's ID
        return meal['recipe']['meal_type_id'] ==
            '058152c4-4894-4756-95ae-3bba523be047';
      }).toList();
      dinnerArr = mealLogs.where((meal) {
        // Check if meal['recipe']['meal_type_id'] matches the selected meal type's ID
        return meal['recipe']['meal_type_id'] ==
            '26ef8a66-455c-4a01-bffd-3cae152e3730';
      }).toList();
      breakfastArr = mealLogs.where((meal) {
        // Check if meal['recipe']['meal_type_id'] matches the selected meal type's ID
        return meal['recipe']['meal_type_id'] ==
            '4bcd628b-2595-4c9e-ae57-2ff6e83eadba';
      }).toList();
      snacksArr = mealLogs.where((meal) {
        // Check if meal['recipe']['meal_type_id'] matches the selected meal type's ID
        return meal['recipe']['meal_type_id'] ==
            'd37900ed-e44c-468a-bfaf-533734b39155';
      }).toList();
      // Initialize variables to store the sum of each nutrition type
      double totalCalories = 0;
      double totalProteins = 0;
      double totalFats = 0;
      double totalCarbo = 0;

      // Iterate through mealLogs to calculate the sum of each nutrition type
      for (var meal in mealLogs) {
        totalCalories += meal['recipe']['calories'];
        totalProteins += meal['recipe']['protein'];
        totalFats += meal['recipe']['total_fat'];
        totalCarbo += meal['recipe']['carbohydrates'];
      }

      nutritionArr = [
        {
          "title": "Calories",
          "image": "assets/img/burn.png",
          "unit_name": "kCal",
          "value": totalCalories.toString(),
          "max_value": userNutrients != null
              ? userNutrients['calories']
              : user.profile.calories,
        },
        {
          "title": "Proteins",
          "image": "assets/img/proteins.png",
          "unit_name": "g",
          "value": totalProteins.toString(),
          "max_value": userNutrients != null
              ? userNutrients['protein']
              : user.profile.protein,
        },
        {
          "title": "Fats",
          "image": "assets/img/egg.png",
          "unit_name": "g",
          "value": totalFats.toString(),
          "max_value": userNutrients != null
              ? userNutrients['total_fat']
              : user.profile.totalFat,
        },
        {
          "title": "Carbo",
          "image": "assets/img/carbo.png",
          "unit_name": "g",
          "value": totalCarbo.toString(),
          "max_value": userNutrients != null
              ? userNutrients['carbohydrates']
              : user.profile.carbohydrates,
        },
      ];
      isLoading = false;
    });
  }

  Future<void> _loadSpecificMealLogs(DateTime selectedDate) async {
    setState(() {
      isLoading = true;
    });

    // Handle the retrieved meal logs as needed
    List<dynamic> mealLogs = await authProvider.getSpecificMealLogs(
        datetime: selectedDate.toIso8601String());

    setState(() {
      lunchArr = mealLogs.where((meal) {
        // Check if meal['recipe']['meal_type_id'] matches the selected meal type's ID
        return meal['recipe']['meal_type_id'] ==
            '058152c4-4894-4756-95ae-3bba523be047';
      }).toList();
      dinnerArr = mealLogs.where((meal) {
        // Check if meal['recipe']['meal_type_id'] matches the selected meal type's ID
        return meal['recipe']['meal_type_id'] ==
            '26ef8a66-455c-4a01-bffd-3cae152e3730';
      }).toList();
      breakfastArr = mealLogs.where((meal) {
        // Check if meal['recipe']['meal_type_id'] matches the selected meal type's ID
        return meal['recipe']['meal_type_id'] ==
            '4bcd628b-2595-4c9e-ae57-2ff6e83eadba';
      }).toList();
      snacksArr = mealLogs.where((meal) {
        // Check if meal['recipe']['meal_type_id'] matches the selected meal type's ID
        return meal['recipe']['meal_type_id'] ==
            'd37900ed-e44c-468a-bfaf-533734b39155';
      }).toList();

      // Initialize variables to store the sum of each nutrition type
      double totalCalories = 0;
      double totalProteins = 0;
      double totalFats = 0;
      double totalCarbo = 0;

      // Iterate through mealLogs to calculate the sum of each nutrition type
      for (var meal in mealLogs) {
        totalCalories += meal['recipe']['calories'];
        totalProteins += meal['recipe']['protein'];
        totalFats += meal['recipe']['total_fat'];
        totalCarbo += meal['recipe']['carbohydrates'];
      }

      nutritionArr = [
        {
          "title": "Calories",
          "image": "assets/img/burn.png",
          "unit_name": "kCal",
          "value": totalCalories.toString(),
          "max_value": user.profile.calories,
        },
        {
          "title": "Proteins",
          "image": "assets/img/proteins.png",
          "unit_name": "g",
          "value": totalProteins.toString(),
          "max_value": user.profile.protein,
        },
        {
          "title": "Fats",
          "image": "assets/img/egg.png",
          "unit_name": "g",
          "value": totalFats.toString(),
          "max_value": user.profile.totalFat,
        },
        {
          "title": "Carbo",
          "image": "assets/img/carbo.png",
          "unit_name": "g",
          "value": totalCarbo.toString(),
          "max_value": user.profile.carbohydrates,
        },
      ];
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
                "Meal  Schedule",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              actions: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      "assets/img/more_btn.png",
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: TColor.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CalendarAgenda(
                  controller: _calendarAgendaControllerAppBar,
                  appbar: false,
                  selectedDayPosition: SelectedDayPosition.center,
                  leading: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/img/ArrowLeft.png",
                        width: 15,
                        height: 15,
                      )),
                  training: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/img/ArrowRight.png",
                        width: 15,
                        height: 15,
                      )),
                  weekDay: WeekDay.short,
                  dayNameFontSize: 12,
                  dayNumberFontSize: 16,
                  dayBGColor: Colors.grey.withOpacity(0.15),
                  titleSpaceBetween: 15,
                  backgroundColor: Colors.transparent,
                  // fullCalendar: false,
                  fullCalendarScroll: FullCalendarScroll.horizontal,
                  fullCalendarDay: WeekDay.short,
                  selectedDateColor: Colors.white,
                  dateColor: Colors.black,
                  locale: 'en',

                  initialDate: selectedDate,
                  calendarEventColor: TColor.primaryColor2,
                  firstDate: DateTime.now().subtract(const Duration(days: 140)),
                  lastDate: DateTime.now().add(const Duration(days: 60)),

                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                    _loadSpecificMealLogs(date);
                  },
                  selectedDayLogo: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: TColor.primaryG,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "BreakFast",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${breakfastArr.isEmpty ? "0 items | 0 calories" : breakfastArr.length} Items | ${breakfastArr.isEmpty ? 0 : breakfastArr.fold<double>(0, (sum, item) => sum + item['recipe']['calories'])} calories",
                                style:
                                    TextStyle(color: TColor.gray, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            breakfastArr.isEmpty ? 1 : breakfastArr.length,
                        itemBuilder: (context, index) {
                          if (breakfastArr.isEmpty) {
                            // If breakfastArr is empty, display a message
                            return const Center(
                              child: Text("Breakfast not logged"),
                            );
                          } else {
                            // If breakfastArr is not empty, display the list items
                            var mObj = breakfastArr[index] as Map? ?? {};
                            if (mealTypes.isNotEmpty) {
                              MealType dObj = mealTypes.firstWhere((mealType) =>
                                  mObj['recipe']['meal_type_id'] ==
                                  mealType.id);
                              return MealFoodScheduleRow(
                                mObj: mObj,
                                dObj: dObj,
                                index: index,
                              );
                            }
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lunch",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${lunchArr.isEmpty ? "0 items | 0 calories" : lunchArr.length} Items | ${lunchArr.isEmpty ? 0 : lunchArr.fold<double>(0, (sum, item) => sum + item['recipe']['calories'])} calories",
                                style:
                                    TextStyle(color: TColor.gray, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: lunchArr.length,
                          itemBuilder: (context, index) {
                            if (lunchArr.isEmpty) {
                              // If breakfastArr is empty, display a message
                              return const Center(
                                child: Text("Lunch not logged"),
                              );
                            } else {
                              // If lunchArr is not empty, display the list items
                              var mObj = lunchArr[index] as Map? ?? {};
                              if (mealTypes.isNotEmpty) {
                                MealType dObj = mealTypes.firstWhere(
                                    (mealType) =>
                                        mObj['recipe']['meal_type_id'] ==
                                        mealType.id);
                                return MealFoodScheduleRow(
                                  mObj: mObj,
                                  dObj: dObj,
                                  index: index,
                                );
                              }
                            }
                            return null;
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Snacks",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${snacksArr.isEmpty ? "0 items | 0 calories" : snacksArr.length} Items | ${snacksArr.isEmpty ? 0 : snacksArr.fold<double>(0, (sum, item) => sum + item['recipe']['calories'])} calories",
                                style:
                                    TextStyle(color: TColor.gray, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snacksArr.length,
                          itemBuilder: (context, index) {
                            if (snacksArr.isEmpty) {
                              // If snacksArr is empty, display a message
                              return const Center(
                                child: Text("Snacks not logged"),
                              );
                            } else {
                              // If snacksArr is not empty, display the list items
                              var mObj = snacksArr[index] as Map? ?? {};
                              if (mealTypes.isNotEmpty) {
                                MealType dObj = mealTypes.firstWhere(
                                    (mealType) =>
                                        mObj['recipe']['meal_type_id'] ==
                                        mealType.id);
                                return MealFoodScheduleRow(
                                  mObj: mObj,
                                  dObj: dObj,
                                  index: index,
                                );
                              }
                            }
                            return null;
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Dinner",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${dinnerArr.isEmpty ? "0 items | 0 calories" : dinnerArr.length} Items | ${dinnerArr.isEmpty ? 0 : dinnerArr.fold<double>(0, (sum, item) => sum + item['recipe']['calories'])} calories",
                                style:
                                    TextStyle(color: TColor.gray, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dinnerArr.length,
                          itemBuilder: (context, index) {
                            if (dinnerArr.isEmpty) {
                              // If dinnerArr is empty, display a message
                              return const Center(
                                child: Text("Dinners not logged"),
                              );
                            } else {
                              // If dinnerArr is not empty, display the list items
                              var mObj = dinnerArr[index] as Map? ?? {};
                              if (mealTypes.isNotEmpty) {
                                MealType dObj = mealTypes.firstWhere(
                                    (mealType) =>
                                        mObj['recipe']['meal_type_id'] ==
                                        mealType.id);
                                return MealFoodScheduleRow(
                                  mObj: mObj,
                                  dObj: dObj,
                                  index: index,
                                );
                              }
                            }
                            return null;
                          }),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      breakfastArr.isEmpty &&
                              lunchArr.isEmpty &&
                              snacksArr.isEmpty &&
                              dinnerArr.isEmpty
                          ? const SizedBox()
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                        height: media.width * 0.05,
                      )
                    ],
                  ),
                ))
              ],
            ),
          );
  }
}
