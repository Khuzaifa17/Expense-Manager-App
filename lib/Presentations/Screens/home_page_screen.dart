import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_colors.dart';
import 'package:flutter_expense_manager/AppUtils/app_font_size.dart';
import 'package:flutter_expense_manager/AppUtils/app_font_weight.dart';
import 'package:flutter_expense_manager/AppUtils/app_strings.dart';
import 'package:flutter_expense_manager/Controllers/home_controller.dart';
import 'package:flutter_expense_manager/Controllers/theme_controllers.dart';
import 'package:flutter_expense_manager/Models/currency_model.dart';
import 'package:flutter_expense_manager/Presentations/Screens/add_transaction_screen.dart';
import 'package:flutter_expense_manager/Presentations/Screens/all_transaction_screen.dart';
import 'package:flutter_expense_manager/Presentations/Screens/chart_screen.dart';
import 'package:flutter_expense_manager/Presentations/Widgets/income_expense_widget.dart';
import 'package:flutter_expense_manager/Presentations/Widgets/place_holder_info_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final HomeController homeController = Get.put(HomeController());
  final themeController = Get.find<ThemeController>();
  String? dropdownValue;
  @override
  void initState() {
    dropdownValue = homeController.selectedCurrency.currency.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: _appBarWidget(),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.h,
              ),
              selectCurrencyWidget(),
              SizedBox(
                height: 10.h,
              ),
              dropDownCurrencyWidget(),
              SizedBox(
                height: 15.h,
              ),
              yourBalanceAmountWidget(),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IncomeExpenseWidget(
                    isIncome: true,
                    symbol: homeController.selectedCurrency.symbol,
                    amount: homeController.totalIncome.value,
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  IncomeExpenseWidget(
                    isIncome: false,
                    symbol: homeController.selectedCurrency.symbol,
                    amount: homeController.totalExpense.value,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .04.h,
              ),
              homeController.myTransactions.isEmpty
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Center(
                            child: IconButton(
                              onPressed: () => _showDatePicker(context),
                              icon: Icon(
                                Icons.calendar_month,
                                color: themeController.color,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          homeController.selectedDate.day == DateTime.now().day
                              ? AppStrings.today
                              : DateFormat.yMd()
                                  .format(homeController.selectedDate),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              homeController.totalForSelectedDate < 0
                                  ? AppStrings.youSpent
                                  : AppStrings.youEarned,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              '${homeController.selectedCurrency.symbol}${homeController.totalForSelectedDate.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              PlaceholderInfoWidget(),
              homeController.myTransactions.isNotEmpty
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 10.h),
                      child: GestureDetector(
                        onTap: () => Get.to(() => AllTransactionsScreen()),
                        child: Text(AppStrings.showAllTransaction),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryAppColor,
          onPressed: () async {
            await Get.to(() => AddTransactionScreen());
            homeController.getTransactions();
          },
          child: Icon(
            Icons.add,
          ),
        ),
      );
    });
  }

  Widget dropDownCurrencyWidget() {
    return Container(
      height: 42.h,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 14.w, right: 14.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyColor,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(
          10.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            homeController.selectedCurrency.currency,
            style: TextStyle(
              fontSize: 14.sp,
              color: themeController.color,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.arrow_downward,
              ),
              elevation: 16,
              style: TextStyle(
                color: Colors.deepPurple,
              ),
              onChanged: (value) {
                setState(() {
                  homeController
                      .updateSelectedCurrency((value as CurrencyModel));
                });
              },
              items: CurrencyModel.currencies
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.currency,
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget selectCurrencyWidget() {
    return Text(
      AppStrings.selectCurrency,
      style: TextStyle(
        fontSize: AppFontSize.fontSize20,
        fontWeight: AppFontWeight.fontWeight500,
        color: AppColors.blackColor,
      ),
    );
  }

  Widget yourBalanceAmountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.yourBalance,
          style: TextStyle(
            fontSize: AppFontSize.fontSize20,
            fontWeight: AppFontWeight.fontWeight500,
            color: themeController.color,
          ),
        ),
        Text(
          '${homeController.selectedCurrency.symbol}${homeController.totalBalance.value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: AppFontSize.fontSize28,
            fontWeight: AppFontWeight.fontWeight700,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      leading: IconButton(
        onPressed: () async {
          themeController.switchTheme();
        },
        icon: Icon(
          Get.isDarkMode ? Icons.nightlight : Icons.wb_sunny,
        ),
        color: themeController.color,
      ),
      title: Text(AppStrings.appName,
          style: TextStyle(
            fontSize: AppFontSize.fontSize22,
            color: AppColors.blackColor,
          )),
      actions: [
        IconButton(
          onPressed: () => Get.to(() => ChartScreen()),
          icon: Icon(
            Icons.bar_chart,
            size: 27.sp,
            color: themeController.color,
          ),
        ),
      ],
    );
  }

  _showDatePicker(BuildContext context) async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2012),
        initialDate: DateTime.now(),
        lastDate: DateTime(2122));
    if (pickerDate != null) {
      homeController.updateSelectedDate(pickerDate);
    }
  }
}
