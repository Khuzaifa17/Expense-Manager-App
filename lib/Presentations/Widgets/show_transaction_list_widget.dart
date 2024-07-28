import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_strings.dart';
import 'package:flutter_expense_manager/Controllers/home_controller.dart';
import 'package:flutter_expense_manager/Presentations/Screens/edit_transaction_screen.dart';
import 'package:flutter_expense_manager/Presentations/Widgets/transaction_list_item_widget.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowTransactionsListItemWidget extends StatelessWidget {
  ShowTransactionsListItemWidget({Key? key}) : super(key: key);
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: homeController.myTransactions.length,
      itemBuilder: (context, i) {
        final transaction = homeController.myTransactions[i];
        final bool isIncome =
            transaction.type == AppStrings.income ? true : false;
        final text =
            '${homeController.selectedCurrency.symbol}${transaction.amount}';
        final formatAmount = isIncome ? '+ $text' : '- $text';
        return transaction.date ==
                DateFormat.yMd().format(homeController.selectedDate)
            ? GestureDetector(
                onTap: () async {
                  await Get.to(() => EditTransactionScreen(tm: transaction));
                  homeController.getTransactions();
                },
                child: TransactionListItemWidget(
                    transaction: transaction,
                    formatAmount: formatAmount,
                    isIncome: isIncome),
              )
            : SizedBox();
      },
    );
  }
}
