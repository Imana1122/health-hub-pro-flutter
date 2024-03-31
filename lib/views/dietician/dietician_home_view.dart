import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/common_widget/round_textfield.dart';
import 'package:fyp_flutter/models/dietician.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/providers/dietician_notification_provider.dart';
import 'package:fyp_flutter/services/dietician/dietician_home_service.dart';
import 'package:fyp_flutter/views/dietician/dietician_notification_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_dietician_layout.dart';
import 'package:provider/provider.dart';

class DieticianHomeView extends StatefulWidget {
  const DieticianHomeView({super.key});

  @override
  State<DieticianHomeView> createState() => _DieticianHomeViewState();
}

class _DieticianHomeViewState extends State<DieticianHomeView> {
  late DieticianAuthProvider authProvider;
  late Dietician user;
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
  bool isLoading = false;
  late DieticianNotificationProvider notiProvider;

  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  int currentPage = 1;
  int lastPage = 1;
  List<dynamic> chatMessages = [];
  Map paymentDetails = {};

  @override
  void initState() {
    super.initState();

    // Access the authentication provider
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    user = authProvider.getAuthenticatedDietician();
    // Check if the user is already logged in
    if (!authProvider.isLoggedIn) {
      // Navigate to DieticianProfilePage and replace the current route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context,
            '/'); // Replace '/dietician-profile' with the route of DieticianProfilePage
      });
    }
    notiProvider =
        Provider.of<DieticianNotificationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notiProvider.getNotifications(
          token: authProvider.getAuthenticatedToken());
    });
    yearController.text = DateTime.now().year.toString();
    monthController.text = DateTime.now().month.toString();
    _loadLineChartDetails();

    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      isLoading = true;
    });
    var result = await DieticianHomeService(authProvider).getPaymentDetails(
        year: yearController.text.trim(),
        month: monthController.text.trim(), // Convert type to lowercase
        page: currentPage);
    if (result != null) {
      setState(() {
        currentPage = result['dieticianBookings']['current_page'];
        chatMessages = result['dieticianBookings']['data'];
        if (result['dietician_payment'] != null) {
          paymentDetails = result['dietician_payment'];
        } else {
          paymentDetails = {};
        }
        lastPage = result['dieticianBookings']['last_page'];
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadLineChartDetails() async {
    setState(() {
      isLoading = true;
    });
    var chartData = await DieticianHomeService(authProvider)
        .getHomeDetails(); // Convert type to lowercase
    setState(() {
      lineChartData = chartData;
      if (lineChartData.isNotEmpty) {
        parsedList = lineChartData.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
        spots = parsedList.map((e) {
          double x;
          if (e['x'] is String) {
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
          if (data['x'] is String) {
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
        : AuthenticatedDieticianLayout(
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
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      actions: [
                        Consumer<DieticianNotificationProvider>(
                          builder: (context, notiProvider, _) {
                            // Count the number of unread notifications
                            int unreadNotificationCount = notiProvider
                                .notifications
                                .where((notification) => notification.read == 0)
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
                                            const DieticianNotificationView(),
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
                                        borderRadius: BorderRadius.circular(8),
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
                        ),
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
                              lineChartData.isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                          height: media.height *
                                              0.5, // Set a fixed height for the chart container
                                          width:
                                              media.width * 0.5 * spots.length,
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
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Payment",
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
                          SizedBox(height: media.height * 0.05),
                          RoundTextField(
                            hitText: 'Year',
                            icon: const Icon(Icons.access_time),
                            controller: yearController,
                          ),
                          SizedBox(height: media.height * 0.02),
                          RoundTextField(
                            hitText: 'Month',
                            icon: const Icon(Icons.filter_9_outlined),
                            controller: monthController,
                          ),
                          SizedBox(height: media.height * 0.02),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 100, // Adjust width as needed
                              child: RoundButton(
                                title: 'Get',
                                onPressed: _loadDetails,
                              ),
                            ),
                          ),
                          SizedBox(height: media.height * 0.02),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.maxFinite,
                            height: 100,
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
                                    "Salary",
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
                                      paymentDetails.isNotEmpty
                                          ? 'NRs. ${paymentDetails['amount']}'
                                          : 'Not Paid',
                                      style: TextStyle(
                                          color: TColor.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(height: media.height * 0.02),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 2)
                                ]),
                            height: media.height * 0.15 * chatMessages.length,
                            child: ListView.builder(
                                itemCount: chatMessages.length,
                                itemBuilder: (context, index) {
                                  final item = chatMessages[index];
                                  final user = item['user'];
                                  final userName = user['name'];
                                  final userImage = user['image'];
                                  final receivedMessages =
                                      item['received_messages'];
                                  final sentMessages = item['sent_messages'];

                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          '${dotenv.env['BASE_URL']}/uploads/users/' +
                                              userImage),
                                    ),
                                    title: Text(userName),
                                    subtitle: Text(
                                        'Received: $receivedMessages, Sent: $sentMessages'),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
    // Remove the dot from doubleString
    doubleString = doubleString.replaceAll(".0", "");
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
  }

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 10000,
        reservedSize: 50,
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
