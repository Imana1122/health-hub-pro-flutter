import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/dietician_subscription/reviews_content.dart';
import 'package:fyp_flutter/common_widget/dietician_subscription/star_rating.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/dietician_booking_service.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

class SubscribedDieticianDetails extends StatefulWidget {
  final Map dietician;
  const SubscribedDieticianDetails({super.key, required this.dietician});

  @override
  State<SubscribedDieticianDetails> createState() =>
      _SubscribedDieticianDetailsState();
}

class _SubscribedDieticianDetailsState
    extends State<SubscribedDieticianDetails> {
  String avgRating = '0';
  late AuthProvider authProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    loadAvgRating();
  }

  loadAvgRating() async {
    setState(() {
      isLoading = true;
    });
    var result = await DieticianBookingService(authProvider)
        .getAvgRating(id: widget.dietician['id']);
    setState(() {
      avgRating = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return AuthenticatedLayout(
      child: Container(
        decoration:
            BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG)),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.transparent,
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
              ),
              SliverAppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                leadingWidth: 0,
                leading: Container(),
                expandedHeight: media.width * 0.5,
                flexibleSpace: ClipRect(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Image
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: media.width * 0.6,
                          height: media.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'http://10.0.2.2:8000/storage/uploads/dietician/profile/${widget.dietician['image']}',
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                // This function is called when the image fails to load
                                // You can return a fallback image here
                                return Image.asset(
                                  'assets/img/non.png', // Path to your placeholder image asset
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Container(
            decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: TColor.gray.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(3)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.dietician["first_name"]} ${widget.dietician['last_name']}",
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              const SizedBox(height: 14),
                              StarRating(
                                rating: double.parse(avgRating),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: media.width,
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              'Amount:',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              'NRs ${widget.dietician['booking_amount']}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              'Bio:',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              widget.dietician['bio'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              'Phone Number:',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              '${widget.dietician['phone_number']}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              DefaultTabController(
                                length: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TabBar(
                                      tabs: [
                                        Tab(text: 'Description'),
                                        Tab(text: 'Speciality'),
                                        Tab(text: 'Reviews'),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 300, // Height of the Tab content
                                      child: TabBarView(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              "${widget.dietician['description']}",
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              "${widget.dietician['speciality']}",
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          ReviewsContent(
                                            id: widget.dietician['id'],
                                            avgRating: avgRating,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.25,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
