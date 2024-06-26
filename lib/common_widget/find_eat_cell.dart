import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/views/account/meal_recipes/meal_food_details_view.dart';
import 'round_button.dart';
import '../common/color_extension.dart';

class FindEatCell extends StatelessWidget {
  final MealType mealType;
  final int index;

  const FindEatCell({super.key, required this.index, required this.mealType});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    bool isEvent = index % 2 == 0;
    return Container(
      margin: const EdgeInsets.all(8),
      width: media.width * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEvent
              ? [
                  TColor.primaryColor2.withOpacity(0.5),
                  TColor.primaryColor1.withOpacity(0.5),
                ]
              : [
                  TColor.secondaryColor2.withOpacity(0.5),
                  TColor.secondaryColor1.withOpacity(0.5),
                ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(75),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.network(
                '${dotenv.env['BASE_URL']}/storage/uploads/mealType/thumb/${mealType.image}',
                width: media.width * 0.2,
                height: media.width * 0.15,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // This function is called when the image fails to load
                  // You can return a fallback image here
                  return Image.asset(
                    'assets/img/non.png', // Path to your placeholder image asset
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  );
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              mealType.name,
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              mealType.recipesCount.toString(),
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
              height: 25,
              child: RoundButton(
                fontSize: 12,
                type: isEvent
                    ? RoundButtonType.bgGradient
                    : RoundButtonType.bgSGradient,
                title: "Select",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MealFoodDetailsView(eObj: mealType)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
