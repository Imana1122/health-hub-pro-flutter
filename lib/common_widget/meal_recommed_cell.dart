import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/views/account/cheat_meal/food_info_details_view.dart';

import './round_button.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class MealRecommendCell extends StatelessWidget {
  final Map fObj;
  final MealType eObj;
  final int index;
  const MealRecommendCell(
      {super.key, required this.index, required this.fObj, required this.eObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    bool isEvent = index % 2 == 0;
    return Container(
      margin: const EdgeInsets.all(5),
      width: media.width * 0.5,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isEvent
                ? [
                    TColor.primaryColor2.withOpacity(0.5),
                    TColor.primaryColor1.withOpacity(0.5)
                  ]
                : [
                    TColor.secondaryColor2.withOpacity(0.5),
                    TColor.secondaryColor1.withOpacity(0.5)
                  ],
          ),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: media.width * 0.3,
            height: media.width * 0.25,
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
                fObj['images'] != null &&
                        fObj['images'] is List &&
                        (fObj['images'] as List).isNotEmpty &&
                        fObj['images'][0]['image'] != null
                    ? 'http://10.0.2.2:8000/uploads/recipes/small/${fObj['images'][0]['image']}'
                    : 'http://10.0.2.2:8000/admin-assets/img/default-150x150.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              fObj["title"],
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "${fObj["minutes"]} | ${fObj["calories"]}",
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 90,
              height: 35,
              child: RoundButton(
                  fontSize: 12,
                  type: isEvent
                      ? RoundButtonType.bgGradient
                      : RoundButtonType.bgSGradient,
                  title: "View",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodInfoDetailsView(
                          dObj: fObj,
                          mObj: eObj,
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
