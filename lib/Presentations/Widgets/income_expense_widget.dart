import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_colors.dart';
import 'package:flutter_expense_manager/AppUtils/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IncomeExpenseWidget extends StatelessWidget {
  final bool isIncome;
  final String symbol;
  final double amount;
  const IncomeExpenseWidget({
    Key? key,
    required this.isIncome,
    required this.symbol,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: isIncome
              ? AppColors.greenColor.withOpacity(0.3)
              : AppColors.redColor.withOpacity(0.3),
          child: Icon(
            isIncome
                ? Icons.keyboard_double_arrow_up
                : Icons.keyboard_double_arrow_down,
            color: isIncome ? AppColors.greenColor : AppColors.redColor,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isIncome ? AppStrings.income : AppStrings.expense,
              // style: AppTheme().subHeadingTextStyle.copyWith(
              //       color: isIncome ? AppColors.greenColor : AppColors.redColor,
              //     ),
            ),
            SizedBox(
              height: 3,
            ),
            Text('$symbol ${amount.toStringAsFixed(2)}')
          ],
        ),
      ],
    );
  }
}
