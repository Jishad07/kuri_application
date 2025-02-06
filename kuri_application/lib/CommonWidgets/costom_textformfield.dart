import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.namecontroller,
    this.label,
    this.hintText,
    this.fillColor,
    this.borderRadius = 8.0,
  });

  final TextEditingController namecontroller;
  final Widget? label;
  final String? hintText;
  final Color? fillColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: namecontroller,
      decoration: InputDecoration(
        label: label,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,  // Lighter hint text color
          fontSize: 14.0,
        ),
        fillColor: fillColor ?? Colors.white,  // Default fill color is white
        filled: true,  // Makes sure the fill color is applied
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.grey.shade400, // Border color for normal state
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: AppColors.primaryVariant,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.blue.shade500,  // Focused border color
            width: 2.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0), // Padding inside the text field
      ),
    );
  }
}
