import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/customize_workout_service.dart';
import 'package:fyp_flutter/services/account/workout_recommendation_service.dart';
import 'package:fyp_flutter/views/account/workout_tracker/workout_detail_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common/common.dart';

class LoggedWorkoutView extends StatefulWidget {
  const LoggedWorkoutView({
    super.key,
  });

  @override
  State<LoggedWorkoutView> createState() => _LoggedWorkoutViewState();
}

class _LoggedWorkoutViewState extends State<LoggedWorkoutView> {
  final CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  late DateTime _selectedDateAppBBar;

  List eventArr = [];
  List selectDayEventArr = [];
  bool isLoading = false;
  late AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _selectedDateAppBBar = DateTime.now();
    loadDetails();
  }

  loadDetails() async {
    setState(() {
      isLoading = true;
    });

    var result = await WorkoutRecommendationService(authProvider)
        .getWorkoutLogs(now: _selectedDateAppBBar.toIso8601String());
    setState(() {
      eventArr = result;
      selectDayEventArr = result;
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
                  "Workout Logs",
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

                    initialDate: _selectedDateAppBBar,
                    calendarEventColor: TColor.primaryColor2,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 60)),

                    onDateSelected: (date) {
                      setState(() {
                        _selectedDateAppBBar = date;
                      });
                      loadDetails();
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
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: media.width * 1.5,
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var availWidth = (media.width * 1.2) - (80 + 40);
                              var slotArr = selectDayEventArr.where((wObj) {
                                return (DateTime.parse(wObj["created_at"]))
                                        .hour ==
                                    index;
                              }).toList();

                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        getTime(index * 60),
                                        style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    if (slotArr.isNotEmpty)
                                      Expanded(
                                          child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: slotArr.map((sObj) {
                                          var min = (DateTime.parse(
                                                  sObj["created_at"]))
                                              .minute;
                                          //(0 to 2)
                                          var pos = (min / 60) * 2 - 1;

                                          return Align(
                                            alignment: Alignment(pos, 0),
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      content: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15,
                                                                horizontal: 20),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: TColor.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                    height: 40,
                                                                    width: 40,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration: BoxDecoration(
                                                                        color: TColor
                                                                            .lightGray,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/img/closed_btn.png",
                                                                      width: 15,
                                                                      height:
                                                                          15,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Workout Log",
                                                                  style: TextStyle(
                                                                      color: TColor
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              sObj["workout"]
                                                                      ['name']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: TColor
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Row(children: [
                                                              Image.asset(
                                                                "assets/img/time_workout.png",
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                "${getDayTitle(sObj["created_at"].toString())}|${getStringDateToOtherFormate(sObj["created_at"].toString(), outFormatStr: "h:mm aa")}",
                                                                style: TextStyle(
                                                                    color: TColor
                                                                        .gray,
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            ]),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: TColor
                                                                        .primaryColor1,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8), // Adjust the radius as needed
                                                                  ),
                                                                  width: 40,
                                                                  height: 40,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          3), // Add padding to ensure the icon is not too close to the edges
                                                                  child:
                                                                      FittedBox(
                                                                    child: IconButton(
                                                                        onPressed: () async {
                                                                          print(
                                                                              sObj['workout']);
                                                                          var result =
                                                                              {};
                                                                          if (sObj['workout']['user_id'] !=
                                                                              null) {
                                                                            result =
                                                                                await CustomizeWorkoutService(authProvider).getWorkoutDetails(id: sObj['workout']['id']);
                                                                          } else {
                                                                            result =
                                                                                await WorkoutRecommendationService(authProvider).getWorkoutDetails(id: sObj['workout']['id']);
                                                                          }
                                                                          Navigator.pop(
                                                                              context);

                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => WorkoutDetailView(
                                                                                      dObj: result,
                                                                                    )),
                                                                          );
                                                                        },
                                                                        icon: Icon(Icons.work, color: TColor.white, size: 40)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 35,
                                                width: availWidth * 0.5,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                alignment: Alignment.centerLeft,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors:
                                                          TColor.secondaryG),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          17.5),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${sObj["workout"]['name'].toString()}, ${getStringDateToOtherFormate(sObj["created_at"].toString(), outFormatStr: "h:mm aa")}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: TColor.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ))
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: TColor.gray.withOpacity(0.2),
                                height: 1,
                              );
                            },
                            itemCount: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
