import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';

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
                child: _buildBadgeWidget(
                    isEarned: true, label: (index + 1).toString()),
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

  Widget _buildBadgeWidget({required bool isEarned, String label = ''}) {
    return Row(
      children: [
        Stack(
          children: [
            Icon(
              Icons.emoji_events,
              size: 100,
              color: isEarned ? Colors.amberAccent : Colors.grey[200],
              semanticLabel: label,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: TColor.secondaryColor1,
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4), // Spacer between icon and separator
        isEarned
            ? const Icon(Icons.remove, size: 20)
            : const SizedBox(), // Separator
      ],
    );
  }
}

class BadgeCustom {
  final bool isEarned;

  BadgeCustom({required this.isEarned});
}
