import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  static TextStyle get subHeadingTextStyle => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey,
      );

  static TextStyle get headingTextStyle => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get titleStyle => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get subTitleStyle => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey.shade100 : Colors.grey.shade600,
      );

  static TextStyle get labelStyle => TextStyle(
        fontSize: 13.sp,
        color: Get.isDarkMode ? Colors.grey.shade100 : Colors.grey.shade600,
      );
}
