import 'package:fyp_flutter/common_widget/icon_title_next_row.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/views/layouts/authenticated_dietician_layout.dart';
import 'shared_result_view.dart';
import 'package:flutter/material.dart';

import '../../../common/color_extension.dart';

class SharedComparisonView extends StatefulWidget {
  final String id;
  const SharedComparisonView({super.key, required this.id});

  @override
  State<SharedComparisonView> createState() => _SharedComparisonViewState();
}

class _SharedComparisonViewState extends State<SharedComparisonView> {
  int? selectedYear1;
  int? selectedMonth1;
  int? selectedYear2;
  int? selectedMonth2;
  @override
  Widget build(BuildContext context) {
    return AuthenticatedDieticianLayout(
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
            "Comparison",
            style: TextStyle(
                color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              IconTitleNextRow(
                icon: "assets/img/date.png",
                title: "Select Month 1",
                time: selectedYear1 != null && selectedMonth1 != null
                    ? '$selectedYear1-$selectedMonth1'
                    : 'Select',
                onPressed: () {
                  _showMonthSelectorModal(1);
                },
                color: TColor.lightGray,
              ),
              const SizedBox(
                height: 15,
              ),
              IconTitleNextRow(
                icon: "assets/img/date.png",
                title: "Select Month 2",
                time: selectedYear2 != null && selectedMonth2 != null
                    ? '$selectedYear2-$selectedMonth2'
                    : 'Select',
                onPressed: () {
                  _showMonthSelectorModal(2);
                },
                color: TColor.lightGray,
              ),
              const Spacer(),
              RoundButton(
                  title: "Compare",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SharedResultView(
                            date1: DateTime(selectedYear1!, selectedMonth1!, 3),
                            date2: DateTime(selectedYear2!, selectedMonth2!, 3),
                            id: widget.id),
                      ),
                    );
                  }),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the month selector modal
  Future<void> _showMonthSelectorModal(int index) async {
    int? selectedYear;
    int? selectedMonth;

    // Show modal bottom sheet
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Year dropdown
              DropdownButtonFormField<int>(
                value: selectedYear,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                  });
                },
                items: List.generate(
                  10, // Generate years as per your requirement
                  (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  },
                ),
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              // Month dropdown
              DropdownButtonFormField<int>(
                value: selectedMonth,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedMonth = newValue!;
                  });
                },
                items: List.generate(
                  12, // Generate months from 1 to 12
                  (index) {
                    int month = index + 1;
                    return DropdownMenuItem<int>(
                      value: month,
                      child: Text(month.toString()),
                    );
                  },
                ),
                decoration: const InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Confirm button
              ElevatedButton(
                onPressed: () {
                  // Update selected year and month
                  setState(() {
                    if (index == 1) {
                      selectedYear1 = selectedYear!;
                      selectedMonth1 = selectedMonth!;
                    } else {
                      selectedYear2 = selectedYear!;
                      selectedMonth2 = selectedMonth!;
                    }
                  });
                  Navigator.pop(context); // Close the modal
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
  }
}
