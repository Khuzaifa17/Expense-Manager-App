import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_images.dart';
import 'package:flutter_expense_manager/AppUtils/app_strings.dart';
import 'package:flutter_expense_manager/Controllers/home_controller.dart';
import 'package:flutter_expense_manager/Presentations/Widgets/show_transaction_list_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlaceholderInfoWidget extends StatelessWidget {
  const PlaceholderInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Get.find<HomeController>().myTransactions.isEmpty
          ? Center(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.appIconImg,
                      // color: AppColors.primaryAppColor,
                    ),
                    Text(
                      AppStrings.noAdded,
                      style: TextStyle(
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      AppStrings.addNew,
                      style: TextStyle(
                        fontSize: 13.sp,
                      ),
                    )
                  ],
                ),
              ),
            )
          : ShowTransactionsListItemWidget(),
    );
  }
}
