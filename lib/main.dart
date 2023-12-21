import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';

import 'views/home/on_boarding/on_boarding_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthHub Pro',
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
      ),
      home: const OnBoardingView(),
    );
  }
}
