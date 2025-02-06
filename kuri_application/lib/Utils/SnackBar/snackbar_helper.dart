import 'package:flutter/material.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';

class SnackbarHelper {

  static void showCustomSnackbar(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? AppColors.primaryColor, // Default background color if not provided
      ),
    );
  }
}
