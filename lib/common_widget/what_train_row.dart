import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/customize_workout_service.dart';
import 'package:fyp_flutter/services/account/workout_recommendation_service.dart';
import 'package:fyp_flutter/views/account/workout_tracker/workout_detail_view.dart';
import 'package:provider/provider.dart';

import './round_button.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class WhatTrainRow extends StatelessWidget {
  final Map wObj;
  const WhatTrainRow({super.key, required this.wObj});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              TColor.primaryColor2.withOpacity(0.3),
              TColor.primaryColor1.withOpacity(0.3)
            ]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wObj["name"].toString(),
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${"${wObj["exercises"].length} exercises"} | ${"${wObj["exercises"].length} mins"}",
                      style: TextStyle(
                        color: TColor.gray,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 100,
                      height: 30,
                      child: RoundButton(
                          title: "View More",
                          fontSize: 10,
                          type: RoundButtonType.textGradient,
                          elevation: 0.05,
                          fontWeight: FontWeight.w400,
                          onPressed: () async {
                            AuthProvider authProvider =
                                Provider.of<AuthProvider>(context,
                                    listen: false);
                            var result = {};
                            if (wObj['user_id'] != null) {
                              result =
                                  await CustomizeWorkoutService(authProvider)
                                      .getWorkoutDetails(id: wObj['id']);
                            } else {
                              result = await WorkoutRecommendationService(
                                      authProvider)
                                  .getWorkoutDetails(id: wObj['id']);
                            }
                            print(result);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WorkoutDetailView(
                                          dObj: result,
                                        )));
                          }),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.54),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      'http://10.0.2.2:8000/storage/uploads/workout/${wObj['image']}',
                      width: 90,
                      height: 90,
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
                ],
              ),
            ],
          ),
        ));
  }
}
