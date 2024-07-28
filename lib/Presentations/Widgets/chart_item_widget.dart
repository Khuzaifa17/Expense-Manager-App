import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_strings.dart';
import 'package:flutter_expense_manager/Models/transaction_model.dart';
import 'package:flutter_expense_manager/Presentations/Widgets/chart_bar_item_widget.dart';
import 'package:intl/intl.dart';

class ChartItemWidget extends StatelessWidget {
  final List<TransactionModel> myTransactions;
  final bool isExpense;
  ChartItemWidget({
    Key? key,
    required this.isExpense,
    required this.myTransactions,
  }) : super(key: key);

  List<String> get weekDays {
    return List.generate(7, (i) {
      final weekDay = DateTime.now().subtract(Duration(days: i));
      return DateFormat.E().format(weekDay)[0];
    }).reversed.toList();
  }

  List<Map<String, dynamic>> get groupedExpenseTx {
    return List.generate(7, (i) {
      final weekDay = DateTime.now().subtract(Duration(days: i));

      double totalSum = 0;
      for (var tm in myTransactions) {
        if (tm.date == DateFormat.yMd().format(weekDay)) {
          if (tm.type == AppStrings.expense) {
            totalSum += double.parse(tm.amount!);
          }
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  List<Map<String, dynamic>> get groupedIncomeTx {
    return List.generate(7, (i) {
      final weekDay = DateTime.now().subtract(Duration(days: i));

      double totalSum = 0;
      for (var tm in myTransactions) {
        if (tm.date == DateFormat.yMd().format(weekDay)) {
          if (tm.type == AppStrings.income) {
            totalSum += double.parse(tm.amount!);
          }
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalExpense {
    return groupedExpenseTx.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  double get totalIncome {
    return groupedIncomeTx.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _displayChart(),
    );
  }

  List<ChartBarItemWidget> _displayChart() {
    if (isExpense) {
      if (myTransactions.any((element) => element.type == 'Expense')) {
        return groupedExpenseTx.map((data) {
          return ChartBarItemWidget(
              isExpense: isExpense,
              label: data['day'],
              totalAmount: data['amount'],
              percentage: data['amount'] / totalExpense);
        }).toList();
      } else {
        return weekDays
            .map((day) => ChartBarItemWidget(
                isExpense: true, label: day, totalAmount: 0, percentage: 0))
            .toList();
      }
    } else {
      if (myTransactions.any((element) => element.type == 'Income')) {
        groupedIncomeTx.map((data) {
          return ChartBarItemWidget(
              isExpense: isExpense,
              label: data['day'],
              totalAmount: data['amount'],
              percentage: data['amount'] / totalExpense);
        }).toList();
      } else {
        return weekDays
            .map((day) => ChartBarItemWidget(
                isExpense: true, label: day, totalAmount: 0, percentage: 0))
            .toList();
      }
    }
    return weekDays
        .map((day) => ChartBarItemWidget(
            isExpense: true, label: day, totalAmount: 0, percentage: 0))
        .toList();
  }
}
