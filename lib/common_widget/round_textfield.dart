import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hitText;
  final Widget icon;
  final Widget? rigtIcon;
  final bool obscureText;
  final EdgeInsets? margin;
  const RoundTextField(
      {super.key,
      required this.hitText,
      required this.icon,
      this.controller,
      this.margin,
      this.keyboardType,
      this.obscureText = false,
      this.rigtIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          color: TColor.lightGray, borderRadius: BorderRadius.circular(5)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hitText,
            border: const OutlineInputBorder(),
            labelText: hitText,
            suffixIcon: rigtIcon,
            prefixIcon: Container(
              width: 50, // Adjust width as needed
              height: 52,
              margin: const EdgeInsets.only(right: 3),
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle, // Makes the container circular
                color: Color.fromARGB(255, 182, 208,
                    229), // Change the background color as desired
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: icon,
            ),
            hintStyle: TextStyle(color: TColor.gray, fontSize: 12)),
      ),
    );
  }
}
