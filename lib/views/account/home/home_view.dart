import 'package:fyp_flutter/common_widget/meal_plans_cards/meal_plan_details_row.dart';
import 'package:fyp_flutter/common_widget/nutritions_row.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/common_widget/workout_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/providers/notification_provider.dart';
import 'package:fyp_flutter/services/account/home_service.dart';
import 'package:fyp_flutter/services/account/workout_recommendation_service.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../../../common/color_extension.dart';
import 'finished_workout_view.dart';
import 'notification_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late AuthProvider authProvider;
  late User user;
  Map mealPlan = {};
  Map<String, dynamic> todayUserDetails = {};
  List<dynamic> lineChartData = []; // Updated lineChartData
  List<Map<String, dynamic>> parsedList = [];
  List<FlSpot> spots = [];
  LineChartBarData lineChartBarData1_1 = LineChartBarData(
    isCurved: true,
    color: TColor.primaryColor2,
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: true,
      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
        radius: 3,
        color: Colors.white,
        strokeWidth: 1,
        strokeColor: TColor.primaryColor2,
      ),
    ),
    belowBarData: BarAreaData(show: false),
    spots: [], // Placeholder list of FlSpot
  );
  List<int> showingTooltipOnSpots = []; // Assuming this is a list of integers
  LineChartBarData tooltipsOnBar =
      LineChartBarData(); // Assuming this is LineChartBarData
  List<LineChartBarData> lineBarsData =
      []; // Assuming this is a list of LineChartBarData
  String selectedType = 'Monthly';
  bool isLoading = false;
  List lastWorkoutArr = [];
  List nutritionArr = [];
  late NotificationProvider notiProvider;
  @override
  void initState() {
    super.initState();

    // Access the authentication provider
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
    loadDetails();
    _loadLineChartDetails(type: 'Monthly');
    notiProvider = Provider.of<NotificationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notiProvider.getNotifications(
          token: authProvider.getAuthenticatedToken());
    });
  }

  void loadDetails() async {
    setState(() {
      isLoading = true;
    });
    var result = await HomeService(authProvider).getHomeDetails();
    setState(() {
      todayUserDetails = result['mealData'];
      lastWorkoutArr = result['workoutLogs'];
      print(result['mealPlan']);
      if (result.containsKey('mealPlan')) {
        mealPlan = result['mealPlan'];
        nutritionArr = [
          {
            "title": "Calories",
            "image": "assets/img/burn.png",
            "unit_name": "kCal",
            "value": mealPlan['calories'].toString(),
            "max_value": user.profile.calories,
          },
          {
            "title": "Proteins",
            "image": "assets/img/proteins.png",
            "unit_name": "g",
            "value": mealPlan['protein'].toString(),
            "max_value": user.profile.protein,
          },
          {
            "title": "Fats",
            "image": "assets/img/egg.png",
            "unit_name": "g",
            "value": mealPlan['total_fat'].toString(),
            "max_value": user.profile.totalFat,
          },
          {
            "title": "Carbo",
            "image": "assets/img/carbo.png",
            "unit_name": "g",
            "value": mealPlan['carbohydrates'].toString(),
            "max_value": user.profile.carbohydrates,
          },
        ];
      }
    });
  }

  String getBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return "under weight";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return "normal weight";
    } else if (bmi >= 24.9 && bmi < 29.9) {
      return "over weight";
    } else {
      return "Obese";
    }
  }

  Future<void> _loadLineChartDetails({required String type}) async {
    var chartData = await WorkoutRecommendationService(authProvider)
        .getWorkoutLineChartDetails(
            type: type.toLowerCase()); // Convert type to lowercase
    setState(() {
      lineChartData = chartData;
      print(lineChartData);
      if (lineChartData.isNotEmpty) {
        print('hello');
        parsedList = lineChartData.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
        spots = parsedList.map((e) {
          double x;
          if (e['x'] is String && selectedType == "Daily") {
            // Parse the string value to double
            String result = e['x'].replaceAll("-", "");
            // DateTime result = DateTime.parse(e['x']);
            double doubleValue = double.parse(result);
            x = doubleValue;
          } else if (e['x'] is String && selectedType == "Monthly") {
            String dateString = e['x'];
            List<String> dateParts = dateString.split("-");
            int year = int.parse(dateParts[0]);
            int month = int.parse(dateParts[1]);
            int numericDate = year * 100 + month;
            x = numericDate.toDouble();
          } else {
            x = 0.0;
          }
          double yValue = double.parse(e['y'].toStringAsFixed(1));

          return FlSpot(x, yValue);
        }).toList();

        // Convert parsed list into list of FlSpot
        List<FlSpot> flSpots = parsedList.map((data) {
          double x;
          if (data['x'] is String && selectedType == "Daily") {
            // Parse the string value to double
            String result = data['x'].replaceAll("-", "");
            double doubleValue = double.parse(result);
            x = doubleValue;
          } else if (data['x'] is String && selectedType == "Monthly") {
            String dateString = data['x'];
            List<String> dateParts = dateString.split("-");
            int year = int.parse(dateParts[0]);
            int month = int.parse(dateParts[1]);
            int numericDate = year * 100 +
                month; // For example, 2022-02 becomes 202202.0 as a int
            x = numericDate.toDouble();
          } else {
            x = 0.0;
          }
          double yValue = double.parse(data['y'].toStringAsFixed(1));
          return FlSpot(x, yValue);
        }).toList();
        lineChartBarData1_1 = LineChartBarData(
          isCurved: true,
          gradient: LinearGradient(colors: TColor.secondaryG),
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: TColor.secondaryG
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: 3,
              color: Colors.white,
              strokeWidth: 1,
              strokeColor: TColor.secondaryColor1,
            ),
          ),
          spots: flSpots,
        );
      }
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
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome Back,",
                                  style: TextStyle(
                                      color: TColor.gray, fontSize: 12),
                                ),
                                Text(
                                  user.name,
                                  style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Consumer<NotificationProvider>(
                              builder: (context, notiProvider, _) {
                                // Count the number of unread notifications
                                int unreadNotificationCount = notiProvider
                                    .notifications
                                    .where((notification) =>
                                        notification.read == 0)
                                    .length;

                                return Stack(
                                  children: [
                                    IconButton(
                                      icon: Image.asset(
                                        "assets/img/notification_active.png",
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NotificationView(),
                                          ),
                                        );
                                      },
                                    ),
                                    if (unreadNotificationCount >
                                        0) // Show count only if there are unread notifications
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                          ),
                                          child: Text(
                                            '$unreadNotificationCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Container(
                          height: media.width * 0.4,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: TColor.primaryG),
                              borderRadius:
                                  BorderRadius.circular(media.width * 0.075)),
                          child: Stack(alignment: Alignment.center, children: [
                            Image.asset(
                              "assets/img/bg_dots.png",
                              height: media.width * 0.4,
                              width: double.maxFinite,
                              fit: BoxFit.fitHeight,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "BMI (Body Mass Index)",
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "You have a ${getBMIStatus(user.profile.bmi)}.",
                                        style: TextStyle(
                                            color:
                                                TColor.white.withOpacity(0.7),
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      SizedBox(
                                          width: 120,
                                          height: 35,
                                          child: RoundButton(
                                              title: "View More",
                                              type: RoundButtonType.bgSGradient,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              onPressed: () {}))
                                    ],
                                  ),
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: PieChart(
                                      PieChartData(
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event,
                                              pieTouchResponse) {},
                                        ),
                                        startDegreeOffset: 250,
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 1,
                                        centerSpaceRadius: 0,
                                        sections: showingSections(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: media.width * 0.45,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 2)
                                  ]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Calories",
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                                colors: TColor.primaryG,
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight)
                                            .createShader(Rect.fromLTRB(0, 0,
                                                bounds.width, bounds.height));
                                      },
                                      child: Text(
                                        '${user.profile.calories} calories',
                                        style: TextStyle(
                                            color:
                                                TColor.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: media.width * 0.2,
                                        height: media.width * 0.2,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: media.width * 0.15,
                                              height: media.width * 0.15,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: TColor.primaryG),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        media.width * 0.075),
                                              ),
                                              child: FittedBox(
                                                child: Text(
                                                  (user.profile.calories -
                                                          todayUserDetails[
                                                              'calories'])
                                                      .toStringAsFixed(2),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: TColor.white,
                                                      fontSize: 11),
                                                ),
                                              ),
                                            ),
                                            SimpleCircularProgressBar(
                                              progressStrokeWidth: 10,
                                              backStrokeWidth: 10,
                                              progressColors: (user.profile
                                                              .calories -
                                                          todayUserDetails[
                                                              'calories'] <
                                                      0)
                                                  ? TColor
                                                      .secondaryG // Use secondaryG if the difference is negative
                                                  : TColor
                                                      .primaryG, // Use primaryG color otherwise

                                              backColor: Colors.grey.shade100,
                                              valueNotifier: ValueNotifier(
                                                  todayUserDetails['calories'] *
                                                      100 /
                                                      user.profile.calories),
                                              startAngle: -180,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Workout Progress",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        lineChartData.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.only(left: 15),
                                height: media.width * 0.5,
                                width: double.maxFinite,
                                child: LineChart(
                                  LineChartData(
                                    showingTooltipIndicators:
                                        showingTooltipOnSpots.map((index) {
                                      return ShowingTooltipIndicators([
                                        LineBarSpot(
                                          tooltipsOnBar,
                                          lineBarsData.indexOf(tooltipsOnBar),
                                          tooltipsOnBar.spots[index],
                                        ),
                                      ]);
                                    }).toList(),
                                    lineTouchData: LineTouchData(
                                      enabled: true,
                                      handleBuiltInTouches: false,
                                      touchCallback: (FlTouchEvent event,
                                          LineTouchResponse? response) {
                                        if (response == null ||
                                            response.lineBarSpots == null) {
                                          return;
                                        }
                                        if (event is FlTapUpEvent) {
                                          final spotIndex = response
                                              .lineBarSpots!.first.spotIndex;
                                          showingTooltipOnSpots.clear();
                                          setState(() {
                                            showingTooltipOnSpots
                                                .add(spotIndex);
                                          });
                                        }
                                      },
                                      mouseCursorResolver: (FlTouchEvent event,
                                          LineTouchResponse? response) {
                                        if (response == null ||
                                            response.lineBarSpots == null) {
                                          return SystemMouseCursors.basic;
                                        }
                                        return SystemMouseCursors.click;
                                      },
                                      getTouchedSpotIndicator:
                                          (LineChartBarData barData,
                                              List<int> spotIndexes) {
                                        return spotIndexes.map((index) {
                                          return TouchedSpotIndicatorData(
                                            const FlLine(
                                              color: Colors.transparent,
                                            ),
                                            FlDotData(
                                              show: true,
                                              getDotPainter: (spot, percent,
                                                      barData, index) =>
                                                  FlDotCirclePainter(
                                                radius: 3,
                                                color: Colors.white,
                                                strokeWidth: 3,
                                                strokeColor:
                                                    TColor.secondaryColor1,
                                              ),
                                            ),
                                          );
                                        }).toList();
                                      },
                                      touchTooltipData: LineTouchTooltipData(
                                        tooltipBgColor: TColor.secondaryColor1,
                                        tooltipRoundedRadius: 20,
                                        getTooltipItems:
                                            (List<LineBarSpot> lineBarsSpot) {
                                          return lineBarsSpot
                                              .map((lineBarSpot) {
                                            return LineTooltipItem(
                                              "${lineBarSpot.x.toInt()} mins ago",
                                              const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ),
                                    lineBarsData: lineBarsData1,
                                    minY: 0,
                                    maxY: 500,
                                    titlesData: FlTitlesData(
                                        show: true,
                                        leftTitles: const AxisTitles(),
                                        topTitles: const AxisTitles(),
                                        bottomTitles: AxisTitles(
                                          sideTitles: bottomTitles,
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles: rightTitles,
                                        )),
                                    gridData: FlGridData(
                                      show: true,
                                      drawHorizontalLine: true,
                                      horizontalInterval: 25,
                                      drawVerticalLine: false,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: TColor.gray.withOpacity(0.15),
                                          strokeWidth: 2,
                                        );
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ))
                            : Container(
                                alignment: Alignment.bottomCenter,
                                child:
                                    const Text('Not workout progress found.')),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Latest Workout",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "See More",
                                style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                        lastWorkoutArr.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: lastWorkoutArr.length,
                                itemBuilder: (context, index) {
                                  var wObj =
                                      lastWorkoutArr[index] as Map? ?? {};
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const FinishedWorkoutView(),
                                          ),
                                        );
                                      },
                                      child: WorkoutRow(wObj: wObj));
                                })
                            : const SizedBox(),
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                        mealPlan != {} && nutritionArr.isNotEmpty
                            ? SingleChildScrollView(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected Meal Plan For Tody',
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: media.height * 0.05,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "BreakFast",
                                            style: TextStyle(
                                                color: TColor.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          MealPlanDetailsRow(
                                              mObj:
                                                  mealPlan['breakfast_recipe'],
                                              dObj: MealType.fromJson(
                                                  mealPlan['breakfast_recipe']
                                                      ['meal_type'])),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Lunch",
                                            style: TextStyle(
                                                color: TColor.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          MealPlanDetailsRow(
                                              mObj: mealPlan['lunch_recipe'],
                                              dObj: MealType.fromJson(
                                                  mealPlan['lunch_recipe']
                                                      ['meal_type'])),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Snacks",
                                            style: TextStyle(
                                                color: TColor.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          MealPlanDetailsRow(
                                              mObj: mealPlan['snack_recipe'],
                                              dObj: MealType.fromJson(
                                                  mealPlan['snack_recipe']
                                                      ['meal_type'])),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Dinner",
                                            style: TextStyle(
                                                color: TColor.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          MealPlanDetailsRow(
                                              mObj: mealPlan['dinner_recipe'],
                                              dObj: MealType.fromJson(
                                                  mealPlan['dinner_recipe']
                                                      ['meal_type'])),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: nutritionArr.length,
                                        itemBuilder: (context, index) {
                                          var nObj =
                                              nutritionArr[index] as Map? ?? {};

                                          return NutritionRow(
                                            nObj: nObj,
                                          );
                                        }),
                                    SizedBox(
                                      height: media.height * 0.1,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  List<PieChartSectionData> showingSections() {
    double bmi = user.profile.bmi;
    var color0 = TColor.secondaryColor1;

    return [
      PieChartSectionData(
        color: color0,
        value: bmi,
        showTitle: false,
        radius: 55,
        titlePositionPercentageOffset: 0.55,
        badgeWidget: Text(
          bmi.toStringAsFixed(2),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      PieChartSectionData(
        color: Colors.white,
        value: 100 - bmi, // Adjust value based on total percentage
        title: '', // You can leave the title empty if needed
        radius: 45,
        titlePositionPercentageOffset: 0.55,
      ),
    ];
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    return Text(
      value.toString(),
      style: TextStyle(
        color: TColor.gray,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 12,
    );
    String doubleString = value.toString();
    Widget text;
    // Remove the dot from doubleString
    doubleString = doubleString.replaceAll(".0", "");
    if (selectedType == "Monthly") {
      // Parse the integer
      int month = int.parse(doubleString.substring(4));
      String yearString = doubleString.substring(0, 4);

      switch (month) {
        case 1:
          text = Text("$yearString-Jan", style: style);
          break;
        case 2:
          text = Text("$yearString-Feb", style: style);
          break;
        case 3:
          text = Text("$yearString-Mar", style: style);
          break;
        case 4:
          text = Text("$yearString-Apr", style: style);
          break;
        case 5:
          text = Text("$yearString-May", style: style);
          break;
        case 6:
          text = Text("$yearString-Jun", style: style);
          break;
        case 7:
          text = Text("$yearString-Jul", style: style);
          break;
        case 8:
          text = Text("$yearString-Aug", style: style);
          break;
        case 9:
          text = Text("$yearString-Sep", style: style);
          break;
        case 10:
          text = Text("$yearString-Oct", style: style);
          break;
        case 11:
          text = Text("$yearString-Nov", style: style);
          break;
        case 12:
          text = Text("$yearString-Dec", style: style);
          break;
        default:
          text = Text('None', style: style);
          break;
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: text,
      );
    } else {
      int month = int.parse(doubleString.substring(4, 6));
      String yearString = doubleString.substring(0, 4);
      String dayString = doubleString.substring(6);
      switch (month) {
        case 1:
          text = Text("$yearString-Jan-$dayString", style: style);
          break;
        case 2:
          text = Text("$yearString-Feb-$dayString", style: style);
          break;
        case 3:
          text = Text("$yearString-Mar-$dayString", style: style);
          break;
        case 4:
          text = Text("$yearString-Apr-$dayString", style: style);
          break;
        case 5:
          text = Text("$yearString-May-$dayString", style: style);
          break;
        case 6:
          text = Text("$yearString-Jun-$dayString", style: style);
          break;
        case 7:
          text = Text("$yearString-Jul-$dayString", style: style);
          break;
        case 8:
          text = Text("$yearString-Aug-$dayString", style: style);
          break;
        case 9:
          text = Text("$yearString-Sep-$dayString", style: style);
          break;
        case 10:
          text = Text("$yearString-Oct-$dayString", style: style);
          break;
        case 11:
          text = Text("$yearString-Nov-$dayString", style: style);
          break;
        case 12:
          text = Text("$yearString-Dec-$dayString", style: style);
          break;
        default:
          text = Text('None', style: style);
          break;
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: text,
      );
    }
  }

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 200,
        reservedSize: 40,
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 999999,
        getTitlesWidget: bottomTitleWidgets,
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];
}
