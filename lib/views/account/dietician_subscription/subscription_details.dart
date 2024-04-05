import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/dietician_booking_service.dart';
import 'package:fyp_flutter/views/account/dietician_subscription/subscribed_dietician_details.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

class SubscriptionDetails extends StatefulWidget {
  const SubscriptionDetails({super.key});

  @override
  State<SubscriptionDetails> createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  late AuthProvider authProvider;
  TextEditingController txtSearch = TextEditingController();

  List dieticians = [];
  bool isLoading = false;
  late ScrollController _scrollController;
  int currentPage = 1;
  int lastPage = 1;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loadDetails();
    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    loadMore();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void loadMore() async {
    setState(() {
      currentPage++;
    });
    if (currentPage <= lastPage) {
      setState(() {
        isLoading = true;
      });
      var result =
          await DieticianBookingService(authProvider).getBookedDieticians(
        currentPage: currentPage,
        keyword: txtSearch.text.trim(),
      );
      setState(() {
        dieticians.addAll(result['data']);
        currentPage = result['current_page'];
        lastPage = result['last_page'];
        isLoading = false;
      });
    }
  }

  Future<void> _loadDetails() async {
    setState(() {
      isLoading = true;
    });
    var result =
        await DieticianBookingService(authProvider).getBookedDieticians(
      keyword: txtSearch.text.trim(),
    );
    setState(() {
      dieticians = result['data'];
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
                  "Subscription Details",
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                offset: Offset(0, 1))
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: txtSearch,
                            decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                prefixIcon: Image.asset(
                                  "assets/img/search.png",
                                  width: 25,
                                  height: 25,
                                ),
                                hintText: "Search"),
                          )),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 1,
                            height: 25,
                            color: TColor.gray.withOpacity(0.3),
                          ),
                          InkWell(
                            onTap: () {
                              _loadDetails();
                            },
                            child: Image.asset(
                              "assets/img/Filter.png",
                              width: 25,
                              height: 25,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.height * 0.05,
                    ),
                    dieticians.isEmpty
                        ? const Center(
                            child: Text('No dieticians available'),
                          )
                        : SizedBox(
                            height: media.height * 0.2 * dieticians.length,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: dieticians.length,
                              itemBuilder: (context, index) {
                                final dietician = dieticians[index];
                                return GestureDetector(
                                  onTap: () {
                                    // Your onTap logic here
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SubscribedDieticianDetails(
                                          dietician: dietician,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          8.0), // Adjust the padding as needed
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: TColor.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1))
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              8.0), // Padding inside the container
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    'http://10.0.2.2:8000/storage/uploads/dietician/profile/${dietician['image']}',
                                                  ),
                                                ),
                                                title: Text(
                                                  '${dietician['first_name']} ${dietician['last_name']}',
                                                  style: TextStyle(
                                                      color: TColor
                                                          .secondaryColor1,
                                                      fontSize: 12),
                                                ),
                                                subtitle: Text(
                                                  dietician['email'],
                                                  style: TextStyle(
                                                      color: TColor
                                                          .secondaryColor1,
                                                      fontSize: 9),
                                                ),
                                                trailing: IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SubscribedDieticianDetails(
                                                          dietician: dietician,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: Image.asset(
                                                    "assets/img/next_go.png",
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
