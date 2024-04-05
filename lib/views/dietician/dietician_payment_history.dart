import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/services/dietician/dietician_home_service.dart';
import 'package:fyp_flutter/views/layouts/authenticated_dietician_layout.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DieticianSalaryPaymentHistory extends StatefulWidget {
  const DieticianSalaryPaymentHistory({super.key});

  @override
  State<DieticianSalaryPaymentHistory> createState() =>
      _DieticianSalaryPaymentHistoryState();
}

class _DieticianSalaryPaymentHistoryState
    extends State<DieticianSalaryPaymentHistory> {
  late DieticianAuthProvider authProvider;
  TextEditingController txtSearch = TextEditingController();

  List payments = [];
  bool isLoading = false;
  int currentPage = 1;
  int lastPage = 1;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      isLoading = true;
    });
    var result = await DieticianHomeService(authProvider).getPayments(
      page: currentPage,
    );
    setState(() {
      payments = result['data'];
      currentPage = result['current_page'];
      lastPage = result['last_page'];
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
                  "Payment History",
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
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: media.height * 0.2 * payments.length,
                      child: ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          var payment = payments[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: const CircleAvatar(
                                child: Icon(Icons.monetization_on),
                              ),
                              title: Text(
                                'Amount: ${payment['amount']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text('Year: ${payment['year']}'),
                                  const SizedBox(height: 4),
                                  Text(
                                      'Month: ${_getMonthName(payment['month'])}'),
                                  const SizedBox(height: 4),
                                  Text(
                                      'Paid At: ${_formatDateTime(payment['created_at'])}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    lastPage > currentPage
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: media.width * 0.05,
                            child: Row(
                              children: [
                                const Spacer(), // Add Spacer to fill the remaining space
                                InkWell(
                                  child: const Text('more'),
                                  onTap: () {
                                    if (lastPage > currentPage) {
                                      setState(() {
                                        currentPage += 1;
                                      });
                                      _loadDetails();
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          );
  }

  String _getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Unknown';
    }
  }

  String _formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('MMMM dd, yyyy hh:mm a').format(dateTime);
    return formattedDate;
  }
}
