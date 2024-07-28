import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expense_manager/AppUtils/app_strings.dart';
import 'package:flutter_expense_manager/AppUtils/app_themes.dart';
import 'package:flutter_expense_manager/Controllers/theme_controllers.dart';
import 'package:flutter_expense_manager/Presentations/Screens/home_page_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_expense_manager/Helper/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await GetStorage.init();
  await DatabaseProvider.initDb();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 1000),
          title: AppStrings.appName,
          theme: AppTheme.lightTheme(context),
          themeMode: themeController.theme,
          darkTheme: AppTheme.darkTheme(context),
          home: child,
        );
      },
      child: HomePageScreen(),
    );
  }
}
