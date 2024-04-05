import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/schedule_workout_service.dart';
import 'package:fyp_flutter/services/account/workout_recommendation_service.dart';
import 'package:fyp_flutter/views/account/workout_tracker/logged_workout_view.dart';
import 'package:fyp_flutter/views/account/workout_tracker/workout_schedule_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
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
  List latestArr = [];
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
  int pageNumber = 1;
  int totalPages = 1;
  late ScrollController _scrollController;
  String currentYear = DateFormat('yyyy').format(DateTime.now());
  String? selectedYear;
  String currentMonth = DateFormat('MM').format(DateTime.now());
  String? selectedMonth;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    selectedYear = currentYear;
    selectedMonth = currentMonth;
    _loadUpcomingWorkouts();

    _loadWorkouts();
    _loadLineChartDetails();

    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Future<void> _loadUpcomingWorkouts() async {
    setState(() {
      isLoading = true;
    });
    var result =
        await ScheduleWorkoutService(authProvider).getUpcomingWorkouts();
    setState(() {
      latestArr = result;
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (totalPages > pageNumber) {
        setState(() {
          pageNumber += 1;
        });
        _loadWorkouts();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      isLoading = true;
    });
    var result = await WorkoutRecommendationService(authProvider)
        .getWorkoutRecommendations(currentPage: pageNumber);
    setState(() {
      if (whatArr.isEmpty) {
        whatArr = result['data'];
      } else {
        whatArr.addAll(result['data']);
      }
      pageNumber = result['current_page'];
      totalPages = result['to'];

      isLoading = false;
    });
  }

  Future<void> _loadLineChartDetails() async {
    setState(() {
      isLoading = true;
    });
    var chartData = await WorkoutRecommendationService(authProvider)
        .getWorkoutLineChartDetails(
            type: selectedType.toLowerCase(),
            year: selectedYear!,
            month: selectedMonth!); // Convert type to lowercase
    setState(() {
      lineChartData = chartData;
      parsedList = lineChartData.map<Map<String, dynamic>>((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
      spots = parsedList.map((e) {
        double x;
        if (e['x'] is String) {
          // Parse the string value to double
          double doubleValue = double.parse(e['x']);
          x = doubleValue;
        } else {
          x = e['x'].toDouble();
        }
        double yValue = double.parse(e['y'].toStringAsFixed(1));

        return FlSpot(x, yValue);
      }).toList();

      // Convert parsed list into list of FlSpot
      List<FlSpot> flSpots = parsedList.map((data) {
        double x;
        if (data['x'] is String) {
          // Parse the string value to double
          double doubleValue = double.parse(data['x']);
          x = doubleValue;
        } else {
          x = data['x'].toDouble();
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
        : AuthenticatedLayout(
            child: Container(
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
                        padding: const EdgeInsets.all(15),
                        child: Expanded(
                          child: Column(
                            children: [
                              Row(children: [
                                Container(
                                  height: 30,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
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
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedType = value as String;
                                        });
                                        if (selectedType == "Monthly") {
                                          await _showMonthlyDialog();
                                        } else {
                                          await _showDailyDialog();
                                        }
                                      },
                                      icon: Icon(Icons.expand_more,
                                          color: TColor.white),
                                      hint: Text(
                                        "Select a type",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: TColor.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 30,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient:
                                        LinearGradient(colors: TColor.primaryG),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    selectedType.toLowerCase() == 'monthly'
                                        ? selectedYear ?? ''
                                        : '${selectedYear ?? ''}-${selectedMonth ?? ''}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: TColor.gray),
                                  ),
                                ),
                              ]),
                              SizedBox(height: media.height * 0.1),
                              lineChartData.isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                          height: media.height *
                                              0.5, // Set a fixed height for the chart container
                                          width:
                                              media.width * 0.2 * spots.length,
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
                                                touchCallback:
                                                    (FlTouchEvent event,
                                                        LineTouchResponse?
                                                            response) {
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
                                                    showingTooltipOnSpots
                                                        .clear();
                                                    setState(() {
                                                      showingTooltipOnSpots
                                                          .add(spotIndex);
                                                    });
                                                  }
                                                },
                                                mouseCursorResolver:
                                                    (FlTouchEvent event,
                                                        LineTouchResponse?
                                                            response) {
                                                  if (response == null ||
                                                      response.lineBarSpots ==
                                                          null) {
                                                    return SystemMouseCursors
                                                        .basic;
                                                  }
                                                  return SystemMouseCursors
                                                      .click;
                                                },
                                                getTouchedSpotIndicator:
                                                    (LineChartBarData barData,
                                                        List<int> spotIndexes) {
                                                  return spotIndexes
                                                      .map((index) {
                                                    return TouchedSpotIndicatorData(
                                                      const FlLine(
                                                        color:
                                                            Colors.transparent,
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
                                              maxY: 1000,
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
                                              const WorkoutScheduleView(),
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
                                  "Daily Workout Logs",
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
                                              const LoggedWorkoutView(),
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WorkoutScheduleView(),
                                    ),
                                  );
                                },
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
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: whatArr.length,
                              itemBuilder: (context, index) {
                                var wObj = whatArr[index] as Map? ?? {};
                                return InkWell(
                                    onTap: () async {
                                      var result =
                                          await WorkoutRecommendationService(
                                                  authProvider)
                                              .getWorkoutDetails(
                                                  id: wObj['id']);
                                      print(result);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WorkoutDetailView(
                                                    dObj: result,
                                                  )));
                                    },
                                    child: WhatTrainRow(wObj: wObj));
                              }),
                          SizedBox(
                            height: media.width * 0.1,
                          ),
                          Container(
                              alignment: Alignment.bottomRight,
                              width: media.width,
                              child: pageNumber < totalPages
                                  ? IconButton(
                                      icon: const Icon(Icons.skip_next),
                                      onPressed: () {
                                        if (pageNumber < totalPages) {
                                          setState(() {
                                            pageNumber += 1;
                                          });
                                          _loadWorkouts();
                                        }
                                      })
                                  : const SizedBox())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> _showMonthlyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: selectedYear,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue;
                    });
                  },
                  items: List.generate(10, (index) {
                    return DropdownMenuItem(
                      value: (int.parse(currentYear) - index).toString(),
                      child: Text((int.parse(currentYear) - index).toString()),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _loadLineChartDetails();
                // Handle fetching line chart details for selected year
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDailyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month and Year'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: selectedMonth,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue;
                    });
                  },
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: (index + 1).toString().padLeft(2, '0'),
                      child: Text('${index + 1}'.padLeft(2, '0')),
                    );
                  }),
                ),
                DropdownButtonFormField<String>(
                  value: selectedYear,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue;
                    });
                  },
                  items: List.generate(10, (index) {
                    return DropdownMenuItem(
                      value: (int.parse(currentYear) - index).toString(),
                      child: Text((int.parse(currentYear) - index).toString()),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _loadLineChartDetails();
                // Handle fetching line chart details for selected month and year
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
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
    doubleString = doubleString.replaceAll(".0", "");
    if (selectedType == "Monthly") {
      // Parse the integer
      int month = int.parse(doubleString);

      switch (month) {
        case 1:
          text = Text("Jan", style: style);
          break;
        case 2:
          text = Text("Feb", style: style);
          break;
        case 3:
          text = Text("Mar", style: style);
          break;
        case 4:
          text = Text("Apr", style: style);
          break;
        case 5:
          text = Text("May", style: style);
          break;
        case 6:
          text = Text("Jun", style: style);
          break;
        case 7:
          text = Text("Jul", style: style);
          break;
        case 8:
          text = Text("Aug", style: style);
          break;
        case 9:
          text = Text("Sep", style: style);
          break;
        case 10:
          text = Text("Oct", style: style);
          break;
        case 11:
          text = Text("Nov", style: style);
          break;
        case 12:
          text = Text("Dec", style: style);
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
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(doubleString, style: style),
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
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];
}
