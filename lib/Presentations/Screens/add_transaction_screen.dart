import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/AppUtils/app_colors.dart';
import 'package:flutter_expense_manager/AppUtils/app_constants.dart';
import 'package:flutter_expense_manager/AppUtils/app_strings.dart';
import 'package:flutter_expense_manager/AppUtils/app_text_style.dart';
import 'package:flutter_expense_manager/Controllers/add_transaction_controller.dart';
import 'package:flutter_expense_manager/Controllers/theme_controllers.dart';
import 'package:flutter_expense_manager/Helper/database_provider.dart';
import 'package:flutter_expense_manager/Models/transaction_model.dart';
import 'package:flutter_expense_manager/Presentations/Widgets/text_form_field_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({Key? key}) : super(key: key);

  final AddTransactionController _addTransactionController =
      Get.put(AddTransactionController());

  final themeController = Get.find<ThemeController>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> _transactionTypes = [
    AppStrings.income,
    AppStrings.expense,
  ];

  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBarWidget(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.transactionImg,
                style: AppTextStyle.labelStyle,
              ),
              SizedBox(
                height: 8.h,
              ),
              _addTransactionController.selectedImage.isNotEmpty
                  ? GestureDetector(
                      onTap: () => _showOptionsDialog(context),
                      child: CircleAvatar(
                        radius: 30.r,
                        backgroundImage: FileImage(
                          File(_addTransactionController.selectedImage),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => _showOptionsDialog(context),
                      child: CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Get.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo,
                            color: themeController.color,
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                AppStrings.selectTransactionType,
                style: AppTextStyle.labelStyle,
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
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
                      width: 250,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                          ),
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
              SizedBox(
                height: 8.h,
              ),
              TextFormFieldWidget(
                hint: AppStrings.enterTransaction,
                label: AppStrings.transactionName,
                controller: _nameController,
              ),
              TextFormFieldWidget(
                hint: AppStrings.enterTransactionAmount,
                label: AppStrings.transactionAmount,
                controller: _amountController,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      hint: _addTransactionController.selectedDate.isNotEmpty
                          ? _addTransactionController.selectedDate
                          : DateFormat.yMd().format(now),
                      label: AppStrings.date,
                      widget: IconButton(
                        onPressed: () => _getDateFromUser(context),
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    child: TextFormFieldWidget(
                      hint: _addTransactionController.selectedTime.isNotEmpty
                          ? _addTransactionController.selectedTime
                          : DateFormat('hh:mm a').format(now),
                      label: AppStrings.time,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(context),
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormFieldWidget(
                hint: _addTransactionController.selectedCategory.isNotEmpty
                    ? _addTransactionController.selectedCategory
                    : AppConstants.categories[0],
                label: AppStrings.category,
                widget: IconButton(
                  onPressed: () => _showDialog(context, true),
                  icon: Icon(
                    Icons.keyboard_arrow_down_sharp,
                  ),
                ),
              ),
              TextFormFieldWidget(
                hint: _addTransactionController.selectedMode.isNotEmpty
                    ? _addTransactionController.selectedMode
                    : AppConstants.cashModes[0],
                isAmount: true,
                label: AppStrings.mode,
                widget: IconButton(
                  onPressed: () => _showDialog(context, false),
                  icon: Icon(
                    Icons.keyboard_arrow_down_sharp,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryAppColor,
          onPressed: () => _addTransaction(),
          child: Icon(
            Icons.add,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  _addTransaction() async {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      Get.snackbar(
        AppStrings.required,
        AppStrings.allRequired,
        backgroundColor:
            Get.isDarkMode ? Color(0xFF212121) : Colors.grey.shade100,
        colorText: AppColors.pinkColor,
      );
    } else {
      final TransactionModel transactionModel = TransactionModel(
        id: DateTime.now().toString(),
        type: _addTransactionController.transactionType.isNotEmpty
            ? _addTransactionController.transactionType
            : _transactionTypes[0],
        image: _addTransactionController.selectedImage,
        name: _nameController.text,
        amount: _amountController.text,
        date: _addTransactionController.selectedDate.isNotEmpty
            ? _addTransactionController.selectedDate
            : DateFormat.yMd().format(now),
        time: _addTransactionController.selectedTime.isNotEmpty
            ? _addTransactionController.selectedTime
            : DateFormat('hh:mm a').format(now),
        category: _addTransactionController.selectedCategory.isNotEmpty
            ? _addTransactionController.selectedCategory
            : AppConstants.categories[0],
        mode: _addTransactionController.selectedMode.isNotEmpty
            ? _addTransactionController.selectedMode
            : AppConstants.cashModes[0],
      );
      await DatabaseProvider.insertTransaction(transactionModel);
      Get.back();
    }
  }

  _showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      _addTransactionController.updateSelectedImage(image.path);
                    }
                  },
                  child: Row(children: [
                    Icon(Icons.image),
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text(
                        AppStrings.gallery,
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                    )
                  ]),
                ),
                SimpleDialogOption(
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      _addTransactionController.updateSelectedImage(image.path);
                    }
                  },
                  child: Row(children: [
                    Icon(Icons.camera),
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text(
                        AppStrings.camera,
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                    )
                  ]),
                ),
                SimpleDialogOption(
                  onPressed: () => Get.back(),
                  child: Row(children: [
                    Icon(Icons.cancel),
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text(
                        AppStrings.cancel,
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ));
  }

  _showDialog(BuildContext context, bool isCategories) {
    Get.defaultDialog(
      title: isCategories ? AppStrings.selectCategory : AppStrings.selectMode,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .7,
        height: MediaQuery.of(context).size.height * .4,
        child: ListView.builder(
          itemCount: isCategories
              ? AppConstants.categories.length
              : AppConstants.cashModes.length,
          itemBuilder: (context, i) {
            final data = isCategories
                ? AppConstants.categories[i]
                : AppConstants.cashModes[i];
            return ListTile(
              onTap: () {
                isCategories
                    ? _addTransactionController.updateSelectedCategory(data)
                    : _addTransactionController.updateSelectedMode(data);
                Get.back();
              },
              title: Text(data),
            );
          },
        ),
      ),
    );
  }

  _getTimeFromUser(
    BuildContext context,
  ) async {
    String? formatedTime;
    await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: DateTime.now().hour,
        minute: DateTime.now().minute,
      ),
    ).then((value) => formatedTime = value!.format(context));

    _addTransactionController.updateSelectedTime(formatedTime!);
  }

  _getDateFromUser(BuildContext context) async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2012),
        initialDate: DateTime.now(),
        lastDate: DateTime(2122));

    if (pickerDate != null) {
      _addTransactionController
          .updateSelectedDate(DateFormat.yMd().format(pickerDate));
    }
  }

  _appBarWidget() {
    return AppBar(
      title: Text(
        AppStrings.addTransaction,
        style: TextStyle(
          color: themeController.color,
        ),
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
