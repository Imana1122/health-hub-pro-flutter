import 'package:fyp_flutter/common/common.dart';
import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/views/meal_planner/food_info_details_view.dart';
import 'package:provider/provider.dart';

import '../common/color_extension.dart';
import 'package:flutter/material.dart';

class MealFoodScheduleRow extends StatelessWidget {
  final Map mObj;
  final MealType dObj;
  final int index;
  const MealFoodScheduleRow(
      {super.key, required this.mObj, required this.dObj, required this.index});
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleDelete() async {
      try {
        if (await authProvider.deleteLogMeal(
          id: mObj["id"],
        )) {
          Navigator.pushNamed(context, '/meal-planner');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Problems in deleting meal',
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
    }

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
                    color: index % 2 == 0
                        ? TColor.primaryColor2.withOpacity(0.4)
                        : TColor.secondaryColor2.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Image.network(
                  mObj["recipe"]['images'] != null &&
                          (mObj["recipe"]['images'] as List).isNotEmpty &&
                          mObj["recipe"]['images'][0]['image'] != null
                      ? 'http://10.0.2.2:8000/uploads/recipes/small/${mObj["recipe"]['images'][0]['image']}'
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
                    mObj["recipe"]["title"].toString(),
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "${getDayTitle(mObj["created_at"].toString())} | ${getStringDateToOtherFormate(mObj["created_at"].toString(), outFormatStr: "h:mm aa")}",
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
                      dObj: mObj["recipe"],
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
            IconButton(
              onPressed: () {
                handleDelete();
              },
              icon: const Icon(
                  Icons.delete), // Create an Icon widget with Icons.delete
            )
          ],
        ));
  }
}
