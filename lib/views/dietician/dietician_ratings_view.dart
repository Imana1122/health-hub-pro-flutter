import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/dietician_subscription/star_rating.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/services/dietician/dietician_home_service.dart';
import 'package:fyp_flutter/views/layouts/authenticated_dietician_layout.dart';
import 'package:provider/provider.dart';

class DieticianSelectView extends StatefulWidget {
  const DieticianSelectView({super.key});

  @override
  State<DieticianSelectView> createState() => _DieticianSelectViewState();
}

class _DieticianSelectViewState extends State<DieticianSelectView> {
  bool isLoading = false;
  List ratings = [];
  int currentPage = 1;

  int lastPage = 1;
  late DieticianAuthProvider authProvider;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    _loadDetails();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        currentPage++;
      });
      if (currentPage <= lastPage) {
        print(currentPage);
        _loadDetails();
      }
    }
  }

  Future<void> _loadDetails() async {
    setState(() {
      isLoading = true;
    });
    var result = await DieticianHomeService(authProvider).getRatings(
      page: currentPage,
    );
    setState(() {
      ratings = result['data'];
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
                  "Ratings",
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
                      height: media.height * 0.1 * ratings.length,
                      child: ListView.builder(
                        itemCount: ratings.length,
                        itemBuilder: (context, index) {
                          var rating = ratings[index];
                          return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rating['user']['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  StarRating(
                                      rating: rating['rating'].toDouble()),
                                  Text(rating['comment']),
                                  const Divider(),
                                ],
                              ));
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
