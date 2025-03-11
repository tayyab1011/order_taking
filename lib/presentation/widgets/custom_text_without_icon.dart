import 'package:flutter/material.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:provider/provider.dart';

class CustomTextWithoutIcon extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color? iconcolor;
  final int? lines;
  final String? Function(String?)? validator;

  const CustomTextWithoutIcon({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.iconcolor,
    this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChangerProvider>(
      builder: (context, provider, child) {
        bool isDarkMode = provider.themeMode == ThemeMode.dark;

        return TextFormField(
          maxLines: lines,
          controller: controller,
          validator: validator,
          cursorColor: isDarkMode
              ? Colors.white70
              : Colors.black, // Adjusted for dark mode
          decoration: InputDecoration(
            fillColor: isDarkMode
                ? const Color(0xff2F302C)
                : ConstantsColors.filledColors, // Dark gray in dark mode
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDarkMode
                  ? Colors.white60
                  : ConstantsColors.textcolor, // Adjusted for dark mode
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white70
                    : Colors.black.withOpacity(0.15), // Softer white border
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white38
                    : Colors.grey.withOpacity(0.15), // Muted white border
              ),
            ),
          ),
        );
      },
    );
  }
}
