import 'package:flutter/material.dart';
import 'package:fyp_flutter/common_widget/meal_recommed_cell.dart';
import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/bookmark_service.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';
import '../../../common/color_extension.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  TextEditingController txtSearch = TextEditingController();
  late AuthProvider authProvider;
  List recommendArr = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _scrollController = ScrollController()..addListener(_scrollListener);
    _loadRecipes();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (currentPage < totalPages) {
        currentPage++;
        _loadMore();
      }
    }
  }

  Future<void> _loadRecipes() async {
    setState(() {
      isLoading = true;
    });
    var data = await BookMarkService(authProvider).getBookmarks(
      currentPage: currentPage,
      keyword: txtSearch.text.trim(),
    );
    setState(() {
      recommendArr = data['data'];
      totalPages = data['last_page']; // Assuming 10 items per page
      isLoading = false;
      currentPage = data['current_page'];
    });
    print(recommendArr.length);
  }

  Future<void> _loadMore() async {
    setState(() {
      isLoading = true;
    });
    var data = await BookMarkService(authProvider).getBookmarks(
      currentPage: currentPage,
      keyword: txtSearch.text.trim(),
    );
    setState(() {
      recommendArr.addAll(data['data']);
      totalPages = data['last_page']; // Assuming 10 items per page
      isLoading = false;
      currentPage = data['current_page'];
    });
    print(recommendArr.length);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
                  'Recipe Bookmarks',
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
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
                                hintText: "Search",
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 1,
                            height: 25,
                            color: TColor.gray.withOpacity(0.3),
                          ),
                          InkWell(
                            onTap: () {
                              _loadRecipes();
                            },
                            child: Image.asset(
                              "assets/img/Filter.png",
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: media.width * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Bookmarks",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: media.height * 0.75,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        itemCount: recommendArr.length,
                        itemBuilder: (context, index) {
                          var fObj = recommendArr[index] as Map? ?? {};
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            leading: TextButton(
                              onPressed: () async {
                                if (await BookMarkService(authProvider)
                                    .bookmark(
                                        body: {'recipe_id': fObj['id']})) {
                                  setState(() {
                                    recommendArr.removeWhere(
                                        (item) => item['id'] == fObj['id']);
                                  });
                                }
                              },
                              child: Image.asset(
                                "assets/img/not-fav.jpg",
                                width: 15,
                                height: 15,
                                fit: BoxFit.contain,
                              ),
                            ),
                            title: MealRecommendCell(
                              fObj: fObj,
                              index: index,
                              eObj: MealType.fromJson(fObj['meal_type']),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: media.width * 0.05),
                  ],
                ),
              ),
            ),
          );
  }
}
