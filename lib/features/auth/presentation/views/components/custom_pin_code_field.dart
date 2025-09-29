import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/config/style/app_color.dart';
import '../../../../../core/config/style/app_text_styles.dart';
import '../../../../../core/heplers/regex.dart';

class CustomPinCodeField extends StatelessWidget {
  final TextEditingController? controller;
  final String? code;
  final VoidCallback onCompleted;

  const CustomPinCodeField({
    super.key,
    this.controller,
    this.code,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
      length: 4,
      animationType: AnimationType.fade,
      validator: (v) => Regex.codeValidator(v, code),
      mainAxisAlignment: MainAxisAlignment.center,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        fieldHeight: 55.w,
        fieldWidth: 55.w,
        borderWidth: 1,
        activeBorderWidth: 1,
        inactiveBorderWidth: 1,
        selectedBorderWidth: 1,
        borderRadius: BorderRadius.zero,
        fieldOuterPadding: EdgeInsets.zero,
        inactiveFillColor: Colors.transparent,
        inactiveColor: AppColors.primary,
        selectedFillColor: Colors.transparent,
        selectedColor: AppColors.primary,
        activeFillColor: Colors.transparent,
        activeColor: AppColors.primary,
      ),
      separatorBuilder: (context, index) => 15.horizontalSpace,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      cursorColor: AppColors.primary,
      textStyle: AppTextStyle.font16black500,
      controller: controller,
      errorTextSpace: 25.w,
      errorTextDirection: TextDirection.rtl,
      keyboardType: TextInputType.number,
      onCompleted: (v) {
        onCompleted.call();
      },
      onChanged: (value) {},
      beforeTextPaste: (text) {
        return true;
      },
    );
  }
}
