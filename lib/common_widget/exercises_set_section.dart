import 'package:flutter/material.dart';

import '../common/color_extension.dart';
import 'exercises_row.dart';

class ExercisesSetSection extends StatelessWidget {
  final Map sObj;
  final Function(Map obj) onPressed;
  final String set;
  const ExercisesSetSection(
      {super.key,
      required this.sObj,
      required this.onPressed,
      required this.set});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Set $set",
          style: TextStyle(
              color: TColor.black, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 8,
        ),
        sObj != null
            ? ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: sObj.keys.length,
                itemBuilder: (context, index) {
                  final key = sObj.keys.elementAt(index);
                  final exercise = sObj[key] as Map? ?? {};
                  // var eObj = exercisesArr[index] as Map? ?? {};
                  return ExercisesRow(
                    eObj: exercise,
                    onPressed: () {
                      onPressed(exercise);
                    },
                  );
                })
            : const Center(
                child: Text('No exercises found.'),
              ),
      ],
    );
  }
}
