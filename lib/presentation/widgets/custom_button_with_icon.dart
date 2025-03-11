import 'package:flutter/material.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final double height;
  final double width;
  final IconData? icon;
  final double ?iconSize;


  const CustomButtonWithIcon({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.height = 54,
    this.width = 286,
    this.icon,  this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ConstantsColors.primary),
        child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Icon(
                    icon,
                    size: iconSize,
                    color: Colors.white,
                  )),
      ),
    );
  }
}
