import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/views/account/meal_planner/meal_plan_details.dart';

class MealPlanCard extends StatelessWidget {
  final Map mObj;
  const MealPlanCard({super.key, required this.mObj});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                "assets/img/f_1.png",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
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
                    mObj['name'].toString(),
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
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
                    builder: (context) => MealPlanDetails(mealPlan: mObj),
                  ),
                );
              },
              icon: Image.asset(
                "assets/img/next_icon.png",
                width: 25,
                height: 25,
              ),
            )
          ],
        ));
  }
}
