import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_colors.dart';
import 'package:flutter_expense_manager/AppUtils/app_strings.dart';
import 'package:flutter_expense_manager/AppUtils/app_text_style.dart';
import 'package:flutter_expense_manager/Controllers/add_transaction_controller.dart';
import 'package:flutter_expense_manager/Controllers/home_controller.dart';
import 'package:flutter_expense_manager/Controllers/theme_controllers.dart';
import 'package:flutter_expense_manager/Presentations/Screens/edit_transaction_screen.dart';
import 'package:flutter_expense_manager/Presentations/Widgets/transaction_list_item_widget.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllTransactionsScreen extends StatelessWidget {
  AllTransactionsScreen({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();
  final AddTransactionController _addTransactionController =
      Get.put(AddTransactionController());
  final ThemeController themeController = Get.find();

  final List<String> _transactionTypes = [
    AppStrings.income,
    AppStrings.expense,
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: _appBarWidget(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
                top: 15.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.selectTransactionType,
                    style: AppTextStyle.labelStyle,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Container(
                    height: 42.h,
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
                      children: [
                        Text(
                          _addTransactionController.transactionType.isEmpty
                              ? _transactionTypes[0]
                              : _addTransactionController.transactionType,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: themeController.color,
                          ),
                        ),
                        SizedBox(
                          width: 255,
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
                                _addTransactionController
                                    .changeTransactionType((val as String));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: homeController.myTransactions.length,
                itemBuilder: (context, i) {
                  final transaction = homeController.myTransactions[i];
                  final text =
                      '${homeController.selectedCurrency.symbol}${transaction.amount}';

                  if (transaction.type ==
                      _addTransactionController.transactionType) {
                    final bool isIncome =
                        transaction.type == AppStrings.income ? true : false;
                    final formatAmount = isIncome ? '+ $text' : '- $text';
                    return GestureDetector(
                      onTap: () async {
                        await Get.to(
                            () => EditTransactionScreen(tm: transaction));
                        homeController.getTransactions();
                      },
                      child: TransactionListItemWidget(
                        transaction: transaction,
                        formatAmount: formatAmount,
                        isIncome: isIncome,
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  AppBar _appBarWidget() {
    return AppBar(
      title: Text(
        AppStrings.allTransaction,
        style: TextStyle(color: themeController.color),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back,
          color: themeController.color,
        ),
      ),
    );
  }
}
