import 'package:flutter/material.dart';
import '../common/color_extension.dart';
import '../models/recipe_category.dart';

class MealCategoryCell extends StatelessWidget {
  final RecipeCategory cObj;
  final int index;
  final bool isSelected; // New property to indicate if the cell is selected
  final Function() onSelect; // Callback function for when the cell is selected

  const MealCategoryCell({
    super.key,
    required this.cObj,
    required this.index,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    bool isEvent = index % 2 == 0;
    return GestureDetector(
      onTap: onSelect, // Call the onSelect callback when tapped
      child: Container(
        margin: const EdgeInsets.all(4),
        width: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isSelected // Use different colors for selected and unselected cells
                    ? [
                        TColor.primaryColor2.withOpacity(0.5),
                        TColor.primaryColor1.withOpacity(0.5)
                      ]
                    : [
                        TColor.secondaryColor2.withOpacity(0.5),
                        TColor.secondaryColor1.withOpacity(0.5)
                      ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(17.5),
              child: Container(
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(17.5),
                ),
                child: Image.network(
                  'http://10.0.2.2:8000/storage/uploads/recipeCategory/thumb/${cObj.image}',
                  width: 35,
                  height: 35,
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                cObj.name,
                maxLines: 1,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
