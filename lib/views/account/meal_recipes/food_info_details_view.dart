import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../common_widget/food_step_detail_row.dart';

class FoodInfoDetailsView extends StatefulWidget {
  final MealType mObj;
  final Map dObj;
  const FoodInfoDetailsView(
      {super.key, required this.dObj, required this.mObj});

  @override
  State<FoodInfoDetailsView> createState() => _FoodInfoDetailsViewState();
}

class _FoodInfoDetailsViewState extends State<FoodInfoDetailsView> {
  List nutritionArr = [];
  late AuthProvider authProvider;
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
    initializeNutritionArr();
  }

  void initializeNutritionArr() {
    setState(() {
      nutritionArr = [
        {
          "image": "assets/img/burn.png",
          "title": "${widget.dObj["calories"]} calories"
        },
        {
          "image": "assets/img/egg.png",
          "title": "${widget.dObj["total_fat"]} fat"
        },
        {
          "image": "assets/img/proteins.png",
          "title": "${widget.dObj["protein"]} proteins"
        },
        {
          "image": "assets/img/carbo.png",
          "title": "${widget.dObj["carbohydrates"]} carbs"
        },
      ];
    });
  }

  handleMealLog() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (await authProvider.logMeal(
        recipeId: widget.dObj["id"],
      )) {
        Navigator.pushNamed(context, '/meal-planner');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Problems in logging meal',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: TColor.primaryColor1,
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    setState(() {
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
                                width: media.width * 0.8,
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    widget.dObj['images'] != null &&
                                            widget.dObj['images'] is List &&
                                            widget.dObj['images'].isNotEmpty &&
                                            widget.dObj['images'][0]['image'] !=
                                                null
                                        ? 'http://10.0.2.2:8000/uploads/recipes/large/${widget.dObj['images'][0]['image']}'
                                        : 'http://10.0.2.2:8000/admin-assets/img/default-150x150.png',
                                    fit: BoxFit.cover,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.dObj["title"],
                                            style: TextStyle(
                                                color: TColor.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Image.asset(
                                        "assets/img/fav.png",
                                        width: 15,
                                        height: 15,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Nutrition",
                                  style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: nutritionArr.length,
                                    itemBuilder: (context, index) {
                                      var nObj =
                                          nutritionArr[index] as Map? ?? {};
                                      return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 4),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  TColor.primaryColor2
                                                      .withOpacity(0.4),
                                                  TColor.primaryColor1
                                                      .withOpacity(0.4)
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                nObj["image"].toString(),
                                                width: 15,
                                                height: 15,
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  nObj["title"].toString(),
                                                  style: TextStyle(
                                                      color: TColor.black,
                                                      fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ));
                                    }),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Descriptions",
                                  style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ReadMoreText(
                                  widget.dObj["description"],
                                  trimLines: 4,
                                  colorClickableText: TColor.black,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: ' Read More ...',
                                  trimExpandedText: ' Read Less',
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 12,
                                  ),
                                  moreStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ingredients That You\nWill Need",
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "${widget.dObj["ingredient"].length} Items",
                                        style: TextStyle(
                                            color: TColor.gray, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: (media.width * 0.25) + 40,
                                child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: widget.dObj['ingredient'].length,
                                    itemBuilder: (context, index) {
                                      var nObj = widget.dObj['ingredient']
                                              [index] as Map? ??
                                          {};
                                      return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          width: media.width * 0.23,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: media.width * 0.23,
                                                height: media.width * 0.23,
                                                decoration: BoxDecoration(
                                                    color: TColor.lightGray,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                alignment: Alignment.center,
                                                child: Image.network(
                                                  widget.dObj['ingredient'] !=
                                                              null &&
                                                          widget.dObj['ingredient']
                                                                      [index]
                                                                  ['image'] !=
                                                              null
                                                      ? 'http://10.0.2.2:8000/uploads/ingredient/thumb/${widget.dObj['ingredient'][index]['image']}'
                                                      : 'http://10.0.2.2:8000/admin-assets/img/default-150x150.png',
                                                  width: media.width * 0.3,
                                                  height: media.width * 0.25,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                nObj["name"].toString(),
                                                style: TextStyle(
                                                    color: TColor.black,
                                                    fontSize: 9),
                                              ),
                                            ],
                                          ));
                                    }),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Step by Step",
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "${widget.dObj['steps'].length} Steps",
                                        style: TextStyle(
                                            color: TColor.gray, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                shrinkWrap: true,
                                itemCount: widget.dObj['steps'].length,
                                itemBuilder: ((context, index) {
                                  final stepKey = (index + 1).toString();
                                  final step = widget.dObj['steps'][stepKey];
                                  return FoodStepDetailRow(
                                    sObj: {'no': index + 1, 'detail': step},
                                    isLast: index ==
                                        widget.dObj['steps'].length - 1,
                                  );
                                }),
                              ),
                              SizedBox(
                                height: media.width * 0.25,
                              ),
                            ],
                          ),
                        ),
                        SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: RoundButton(
                                    title: "Add to ${widget.mObj.name} Meal",
                                    onPressed: () {
                                      handleMealLog();
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
