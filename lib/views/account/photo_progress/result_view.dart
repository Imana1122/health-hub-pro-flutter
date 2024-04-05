import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/progress_service.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../../../common/color_extension.dart';
import '../../../common/common.dart';
import '../../../common_widget/round_button.dart';

class ResultView extends StatefulWidget {
  final DateTime date1;
  final DateTime date2;
  const ResultView({super.key, required this.date1, required this.date2});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  int selectButton = 0;

  List imaArr = [];

  List statArr = [
    {
      "title": "Lose Weight",
      "diff_per": "33",
      "month_1_per": "33%",
      "month_2_per": "67%",
    },
    {
      "title": "Gain Weight",
      "diff_per": "88",
      "month_1_per": "88%",
      "month_2_per": "12%",
    },
  ];
  late AuthProvider authProvider;
  bool isLoading = false;
  List<dynamic> lineChartData = [];
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    loadDetails();
  }

  void loadDetails() async {
    setState(() {
      isLoading = true;
    });
    var result = await ProgressService(authProvider).getResult(
        month1: widget.date1.toIso8601String(),
        month2: widget.date2.toIso8601String());
    var result2 = await ProgressService(authProvider).getStat(
        month1: widget.date1.toIso8601String(),
        month2: widget.date2.toIso8601String());
    var result3 = await ProgressService(authProvider)
        .getChartData(year: widget.date2.year.toString());
    print(result3);
    setState(() {
      imaArr = result;
      statArr = result2;
      lineChartData = result3;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return AuthenticatedLayout(
      child: Scaffold(
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
            "Result",
            style: TextStyle(
                color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(30)),
                  child: Stack(alignment: Alignment.center, children: [
                    AnimatedContainer(
                      alignment: selectButton == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        width: (media.width * 0.5) - 40,
                        height: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: TColor.primaryG),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectButton = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  "Photo",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectButton == 0
                                          ? TColor.white
                                          : TColor.gray,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectButton = 1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  "Statistic",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectButton == 1
                                          ? TColor.white
                                          : TColor.gray,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Photo Tab UI
                if (selectButton == 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateToString(widget.date1, formatStr: "MMMM"),
                            style: TextStyle(
                                color: TColor.gray,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            dateToString(widget.date2, formatStr: "MMMM"),
                            style: TextStyle(
                                color: TColor.gray,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: imaArr.length,
                          itemBuilder: (context, index) {
                            var iObj = imaArr[index] as Map? ?? {};

                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    iObj["title"].toString(),
                                    style: TextStyle(
                                        color: TColor.gray,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: TColor.lightGray,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                iObj["month_1_image"]
                                                    .toString(),
                                                width: double.maxFinite,
                                                height: double.maxFinite,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: TColor.lightGray,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                iObj["month_2_image"]
                                                    .toString(),
                                                width: double.maxFinite,
                                                height: double.maxFinite,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ]);
                          }),
                      SizedBox(height: media.height * 0.1),
                      RoundButton(
                          title: "Back to Home",
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),

                // Statistic Tab UI
                if (selectButton == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: media.width * 0.8,
                        width: double.maxFinite,
                        child: LineChart(
                          LineChartData(
                            lineTouchData: LineTouchData(
                              enabled: true,
                              handleBuiltInTouches: false,
                              touchCallback: (FlTouchEvent event,
                                  LineTouchResponse? response) {
                                if (response == null ||
                                    response.lineBarSpots == null) {
                                  return;
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
                                      getDotPainter:
                                          (spot, percent, barData, index) =>
                                              FlDotCirclePainter(
                                        radius: 3,
                                        color: Colors.white,
                                        strokeWidth: 3,
                                        strokeColor: TColor.secondaryColor1,
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
                                  return lineBarsSpot.map((lineBarSpot) {
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
                            minY: 40,
                            maxY: 200,
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
                                  color: TColor.lightGray,
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
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateToString(widget.date1, formatStr: "MMMM"),
                            style: TextStyle(
                                color: TColor.gray,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            dateToString(widget.date2, formatStr: "MMMM"),
                            style: TextStyle(
                                color: TColor.gray,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: statArr.length,
                          itemBuilder: (context, index) {
                            var iObj = statArr[index] as Map? ?? {};

                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    iObj["title"].toString(),
                                    style: TextStyle(
                                        color: TColor.gray,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 35,
                                        child: Text(
                                          iObj["month_1_per"].toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: TColor.gray, fontSize: 12),
                                        ),
                                      ),
                                      SimpleAnimationProgressBar(
                                        height: 10,
                                        width: media.width - 120,
                                        backgroundColor: TColor.primaryColor1,
                                        foregrondColor: const Color(0xffFFB2B1),
                                        ratio: (double.tryParse(iObj["diff_per"]
                                                    .toString()) ??
                                                0.0) /
                                            100.0,
                                        direction: Axis.horizontal,
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        duration: const Duration(seconds: 3),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      SizedBox(
                                        width: 35,
                                        child: Text(
                                          iObj["month_2_per"].toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: TColor.gray,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ]);
                          }),
                      SizedBox(height: media.height * 0.1),
                      RoundButton(
                          title: "Back to Home",
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
      isCurved: true,
      gradient: LinearGradient(colors: TColor.primaryG),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: lineChartData.map((entry) {
        int month = int.parse(entry['month']);
        double weight = entry['weight'].toDouble();
        return FlSpot(month.toDouble(), weight);
      }).toList());

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
      isCurved: true,
      gradient: LinearGradient(colors: [
        TColor.secondaryColor2.withOpacity(0.5),
        TColor.secondaryColor1.withOpacity(0.5)
      ]),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: false,
      ),
      spots: lineChartData.map((entry) {
        int month = int.parse(entry['month']);
        double weight = entry['height'].toDouble();
        return FlSpot(month.toDouble(), weight);
      }).toList());

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text = value.toInt().toString();

    return Text(text,
        style: TextStyle(
          color: TColor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Jan', style: style);
        break;
      case 2:
        text = Text('Feb', style: style);
        break;
      case 3:
        text = Text('Mar', style: style);
        break;
      case 4:
        text = Text('Apr', style: style);
        break;
      case 5:
        text = Text('May', style: style);
        break;
      case 6:
        text = Text('Jun', style: style);
        break;
      case 7:
        text = Text('Jul', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}
