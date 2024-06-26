import 'package:fyp_flutter/common_widget/meal_recommed_cell.dart';
import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/models/recipe_category.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/recipe_recommendation_service.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/meal_category_cell.dart';

class MealFoodDetailsView extends StatefulWidget {
  final MealType eObj;
  const MealFoodDetailsView({super.key, required this.eObj});

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  TextEditingController txtSearch = TextEditingController();
  List<RecipeCategory> categoryArr = [];
  late AuthProvider authProvider;
  List recommendArr = [];
  int currentPage = 1;
  String selectedCategoryId = '';
  int totalPages = 1;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if the user is already logged in
    if (!authProvider.isLoggedIn) {
      // Navigate to DieticianProfilePage and replace the current route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context,
            '/'); // Replace '/dietician-profile' with the route of DieticianProfilePage
      });
    }
    _loadCategories();

    _loadRecipes();
  }

  Future<void> _loadCategories() async {
    setState(() {
      isLoading = true;
    });
    var categories =
        await RecipeRecommendationService(authProvider).getRecipeCategories();
    setState(() {
      categoryArr = categories;
    });
  }

  Future<void> _loadRecipes() async {
    setState(() {
      isLoading = true;
    });
    var data = await RecipeRecommendationService(authProvider)
        .getRecipeRecommendations(
            mealTypeId: widget.eObj.id,
            currentPage: currentPage,
            keyword: txtSearch.text.trim(),
            category: selectedCategoryId);
    setState(() {
      recommendArr = data['data'];
      totalPages = data['last_page']; // Assuming 10 items per page
      isLoading = false;
      currentPage = data['current_page'];
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
                  widget.eObj.name.toString(),
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
                              _loadRecipes();
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
                      height: media.width * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Category",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedCategoryId = '';
                              });
                              _loadRecipes();
                            },
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                color: TColor
                                    .primaryColor2, // Adjust color as needed
                                fontSize: 14, // Adjust font size as needed
                                fontWeight: FontWeight
                                    .bold, // Adjust font weight as needed
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryArr.length,
                        itemBuilder: (context, index) {
                          var cObj = categoryArr[index];
                          return MealCategoryCell(
                            cObj: cObj,
                            index: index,
                            isSelected: selectedCategoryId == cObj.id,
                            onSelect: () {
                              setState(() {
                                selectedCategoryId = cObj.id;
                              });
                              _loadRecipes();
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Recommendation\nfor Diet",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.6,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendArr.length,
                          itemBuilder: (context, index) {
                            var fObj = recommendArr[index] as Map? ?? {};
                            return MealRecommendCell(
                                fObj: fObj, index: index, eObj: widget.eObj);
                          }),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: TColor.secondaryColor1,
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust the radius as needed
                            ),
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(
                                3), // Add padding to ensure the icon is not too close to the edges
                            child: FittedBox(
                              child: IconButton(
                                onPressed: () {
                                  if (currentPage > 1) {
                                    setState(() {
                                      currentPage--;
                                    });
                                    _loadRecipes();
                                  }
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Page $currentPage of $totalPages',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: TColor.secondaryColor1,
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust the radius as needed
                            ),
                            width: 40,
                            height: 40,
                            child: FittedBox(
                              child: IconButton(
                                onPressed: () {
                                  if (currentPage < totalPages) {
                                    setState(() {
                                      currentPage++;
                                    });
                                    _loadRecipes();
                                  }
                                },
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ),
                          ),
                        ],
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
