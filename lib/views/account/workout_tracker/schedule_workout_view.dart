import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/schedule_workout_service.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common/common.dart';
import '../../../common_widget/round_button.dart';

class ScheduleWorkoutView extends StatefulWidget {
  final Map workout;
  const ScheduleWorkoutView({super.key, required this.workout});

  @override
  State<ScheduleWorkoutView> createState() => _ScheduleWorkoutViewState();
}

class _ScheduleWorkoutViewState extends State<ScheduleWorkoutView> {
  final CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  late DateTime date;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
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
                "assets/img/closed_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text(
            "Add Schedule",
            style: TextStyle(
                color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: TColor.white,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
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

              initialDate: DateTime.now(),
              calendarEventColor: TColor.primaryColor2,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 60)),

              onDateSelected: (value) {
                setState(() {
                  date = value;
                });
                print(date);
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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Image.asset(
                  "assets/img/date.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  dateToString(date, formatStr: "E, dd MMMM yyyy"),
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Time",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: media.width * 0.35,
              child: CupertinoDatePicker(
                key: UniqueKey(),
                onDateTimeChanged: (newDate) {
                  print(newDate);

                  setState(() {
                    date = newDate;
                  });
                },
                initialDateTime: date,
                use24hFormat: true,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
                title: "Save",
                onPressed: () {
                  AuthProvider authProvider =
                      Provider.of<AuthProvider>(context, listen: false);

                  var body = {
                    'workout_id': widget.workout['id'],
                    'scheduled_time': date.toIso8601String()
                  };
                  if (widget.workout['user_id'] == null) {
                    ScheduleWorkoutService(authProvider)
                        .scheduleWorkout(body: body);
                  } else {
                    ScheduleWorkoutService(authProvider)
                        .scheduleWorkout(body: body, type: 'customized');
                  }
                }),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
