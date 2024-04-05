import 'package:flutter/material.dart';

class BadgeView extends StatelessWidget {
  // Number of badges to display
  final int numberOfBadgesToShow;

  const BadgeView({super.key, required this.numberOfBadgesToShow});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(numberOfBadgesToShow - 1, (index) {
              // All but the last badge are marked as earned
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildBadgeWidget(isEarned: true),
              );
            }) +
            [
              // The last badge is marked as not earned
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildBadgeWidget(isEarned: false),
              ),
            ],
      ),
    );
  }

  Widget _buildBadgeWidget({required bool isEarned}) {
    return Column(
      children: [
        Container(
          width: 50, // Adjust as needed
          height: 50, // Adjust as needed
          decoration: BoxDecoration(
            color: isEarned ? Colors.green : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.star, // Replace with any icon you prefer
            color: isEarned ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 4), // Spacer between icon and separator
        const Icon(Icons.remove, size: 20), // Separator
      ],
    );
  }
}

class BadgeCustom {
  final bool isEarned;

  BadgeCustom({required this.isEarned});
}
