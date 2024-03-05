import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/workout_recommendation_service.dart';
import 'package:fyp_flutter/views/account/home/activity_tracker_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'workout_detail_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../common_widget/round_button.dart';
import '../../../common_widget/upcoming_workout_row.dart';
import '../../../common_widget/what_train_row.dart';

class WorkoutTrackerView extends StatefulWidget {
  const WorkoutTrackerView({super.key});

  @override
  State<WorkoutTrackerView> createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {
  List latestArr = [
    {
      "image": "assets/img/Workout1.png",
      "title": "Fullbody Workout",
      "time": "Today, 03:00pm"
    },
    {
      "image": "assets/img/Workout2.png",
      "title": "Upperbody Workout",
      "time": "June 05, 02:00pm"
    },
  ];
  late AuthProvider authProvider;
  List whatArr = [];
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

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _loadLineChartDetails(type: selectedType);
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      isLoading = true;
    });
    var result = await WorkoutRecommendationService(authProvider)
        .getWorkoutRecommendations();
    setState(() {
      whatArr = result;
      isLoading = false;
    });
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
    print("DoubleString ::: $doubleString");
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
        interval: 50,
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

  Future<void> _loadLineChartDetails({required String type}) async {
    setState(() {
      isLoading = true;
    });
    var chartData = await WorkoutRecommendationService(authProvider)
        .getWorkoutLineChartDetails(
            type: type.toLowerCase()); // Convert type to lowercase
    setState(() {
      lineChartData = chartData;
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
          print("X-VALUE :: $x");
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
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 3,
            color: Colors.white,
            strokeWidth: 1,
            strokeColor: TColor.secondaryColor1,
          ),
        ),
        spots: flSpots,
      );
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
        : Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG)),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    elevation: 0,
                    pinned: false,
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
                      "Workout Tracker",
                      style: TextStyle(
                          color: TColor.white,
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
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    elevation: 0,
                    pinned: false,
                    leadingWidth: 0,
                    leading: const SizedBox(),
                    expandedHeight: media.height * 0.7,
                    flexibleSpace: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(left: 15),
                      child: Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                gradient:
                                    LinearGradient(colors: TColor.primaryG),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: selectedType,
                                  items: ["Monthly", "Daily"].map((name) {
                                    return DropdownMenuItem(
                                      value: name,
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          color: TColor.gray,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        selectedType = value;
                                        // Convert the value to lowercase before passing it to _loadLineChartDetails
                                        _loadLineChartDetails(
                                            type: value.toLowerCase());
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.expand_more,
                                      color: TColor.white),
                                  hint: Text(
                                    "Select a meal type",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: media.width *
                                  0.02, // Adjust the height as needed
                            ),
                            SizedBox(
                              height: media.width *
                                  0.02, // Adjust the height as needed
                            ),

                            lineChartData.isNotEmpty
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                        height: media.height *
                                            0.5, // Set a fixed height for the chart container
                                        width: media.width * 0.8,
                                        child: LineChart(
                                          LineChartData(
                                            showingTooltipIndicators:
                                                showingTooltipOnSpots
                                                    .map((index) {
                                              return ShowingTooltipIndicators([
                                                LineBarSpot(
                                                  tooltipsOnBar,
                                                  lineBarsData
                                                      .indexOf(tooltipsOnBar),
                                                  tooltipsOnBar.spots[index],
                                                ),
                                              ]);
                                            }).toList(),
                                            lineTouchData: LineTouchData(
                                              enabled: true,
                                              handleBuiltInTouches: false,
                                              touchCallback: (FlTouchEvent
                                                      event,
                                                  LineTouchResponse? response) {
                                                if (response == null ||
                                                    response.lineBarSpots ==
                                                        null) {
                                                  return;
                                                }
                                                if (event is FlTapUpEvent) {
                                                  final spotIndex = response
                                                      .lineBarSpots!
                                                      .first
                                                      .spotIndex;
                                                  showingTooltipOnSpots.clear();
                                                  setState(() {
                                                    showingTooltipOnSpots
                                                        .add(spotIndex);
                                                  });
                                                }
                                              },
                                              mouseCursorResolver: (FlTouchEvent
                                                      event,
                                                  LineTouchResponse? response) {
                                                if (response == null ||
                                                    response.lineBarSpots ==
                                                        null) {
                                                  return SystemMouseCursors
                                                      .basic;
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
                                                      getDotPainter: (spot,
                                                              percent,
                                                              barData,
                                                              index) =>
                                                          FlDotCirclePainter(
                                                        radius: 3,
                                                        color: Colors.white,
                                                        strokeWidth: 3,
                                                        strokeColor: TColor
                                                            .secondaryColor1,
                                                      ),
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                              touchTooltipData:
                                                  LineTouchTooltipData(
                                                tooltipBgColor:
                                                    TColor.secondaryColor1,
                                                tooltipRoundedRadius: 20,
                                                getTooltipItems:
                                                    (List<LineBarSpot>
                                                        lineBarsSpot) {
                                                  return lineBarsSpot
                                                      .map((lineBarSpot) {
                                                    return LineTooltipItem(
                                                      "${lineBarSpot.x.toInt()} mins ago",
                                                      const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              ),
                                            ),
                                            gridData: FlGridData(
                                              show: true,
                                              drawHorizontalLine: true,
                                              horizontalInterval: 25,
                                              drawVerticalLine: false,
                                              getDrawingHorizontalLine:
                                                  (value) {
                                                return FlLine(
                                                  color: TColor.gray
                                                      .withOpacity(0.15),
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
                                        )),
                                  )
                                : const SizedBox(), // If lineChartData is empty, show an empty SizedBox
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                              color: TColor.gray.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            color: TColor.primaryColor2.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Daily Workout Schedule",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 90,
                                height: 30,
                                child: RoundButton(
                                  title: "Check",
                                  type: RoundButtonType.bgGradient,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ActivityTrackerView(),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Upcoming Workout",
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
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: latestArr.length,
                            itemBuilder: (context, index) {
                              var wObj = latestArr[index] as Map? ?? {};
                              return UpcomingWorkoutRow(wObj: wObj);
                            }),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "What Do You Want to Train",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: whatArr.length,
                            itemBuilder: (context, index) {
                              var wObj = whatArr[index] as Map? ?? {};
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WorkoutDetailView(
                                                  dObj: wObj,
                                                )));
                                  },
                                  child: WhatTrainRow(wObj: wObj));
                            }),
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
