import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.whiteColor,
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.blackColor,
      );
}
