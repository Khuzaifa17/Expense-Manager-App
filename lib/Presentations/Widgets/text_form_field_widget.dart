import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_colors.dart';
import 'package:flutter_expense_manager/AppUtils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String label;
  final String hint;
  final bool? isAmount;
  final TextEditingController? controller;
  final Widget? widget;
  const TextFormFieldWidget({
    Key? key,
    required this.hint,
    required this.label,
    this.isAmount = false,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 14.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.labelStyle,
          ),
          Container(
            height: 48.h,
            margin: EdgeInsets.only(
              top: 6.h,
            ),
            padding: EdgeInsets.only(
              left: 14.w,
            ),
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
                Expanded(
                  child: TextFormField(
                    keyboardType:
                        isAmount! ? TextInputType.number : TextInputType.text,
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode
                        ? Colors.grey.shade100
                        : Colors.grey.shade700,
                    controller: controller,
                    style: AppTextStyle.labelStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: AppTextStyle.labelStyle,
                    ),
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
