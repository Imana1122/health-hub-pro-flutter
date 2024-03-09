import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/views/account/meal_recipes/food_info_details_view.dart';

import '../../common/color_extension.dart';
import 'package:flutter/material.dart';

class MealPlanDetailsRow extends StatelessWidget {
  final Map mObj;
  final MealType dObj;
  const MealPlanDetailsRow({super.key, required this.mObj, required this.dObj});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                    color: TColor.primaryColor2.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Image.network(
                  mObj['images'] != null &&
                          (mObj['images'] as List).isNotEmpty &&
                          mObj['images'][0]['image'] != null
                      ? 'http://10.0.2.2:8000/uploads/recipes/small/${mObj['images'][0]['image']}'
                      : 'http://10.0.2.2:8000/admin-assets/img/default-150x150.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mObj["title"].toString(),
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "${mObj["calories"].toString()} calories | ${mObj["protein"].toString()} protein",
                    style: TextStyle(
                      color: TColor.gray,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodInfoDetailsView(
                      dObj: mObj,
                      mObj: dObj,
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
          ],
        ));
  }
}
