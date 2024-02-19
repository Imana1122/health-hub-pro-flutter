import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/views/chat/size_config.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  const PrimaryButton({
    super.key,
    required this.child,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 6),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 6,
            vertical: SizeConfig.blockSizeHorizontal * 4),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: TColor.primaryG,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(25)),
        child: child,
      ),
    );
  }
}
