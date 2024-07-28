import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_colors.dart';
import 'package:flutter_expense_manager/AppUtils/app_strings.dart';
import 'package:flutter_expense_manager/Controllers/chart_controller.dart';
import 'package:flutter_expense_manager/Controllers/home_controller.dart';
import 'package:flutter_expense_manager/Controllers/theme_controllers.dart';
import 'package:flutter_expense_manager/Presentations/Screens/add_transaction_screen.dart';
import 'package:flutter_expense_manager/Presentations/Screens/all_transaction_screen.dart';
import 'package:flutter_expense_manager/Presentations/Widgets/chart_item_widget.dart';
import 'package:flutter_expense_manager/Presentations/Widgets/place_holder_info_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ChartScreen extends StatelessWidget {
  final List<String> _transactionTypes = [
    AppStrings.income,
    AppStrings.expense,
  ];
  ChartScreen({Key? key}) : super(key: key);
  final ChartController chartController = Get.put(ChartController());
  final themeController = Get.find<ThemeController>();
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: _appBar(),
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
              ChartItemWidget(
                isExpense: chartController.isExpense.value,
                myTransactions: homeController.myTransactions,
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
                                  ))),
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
                        onTap: () {
                          Get.to(() => AllTransactionsScreen());
                        },
                        child: Text(
                          AppStrings.allTransaction,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () async {
            await Get.to(() => AddTransactionScreen());
            homeController.getTransactions();
          },
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        AppStrings.chart,
        style: TextStyle(color: themeController.color),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back, color: themeController.color),
      ),
      actions: homeController.myTransactions.isEmpty
          ? []
          : [
              Row(
                children: [
                  Text(
                    chartController.transactionType.isEmpty
                        ? _transactionTypes[0]
                        : chartController.transactionType,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: themeController.color,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: _transactionTypes
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          chartController
                              .changeTransactionType((val as String));
                        },
                      ),
                    ),
                  ),
                ],
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
