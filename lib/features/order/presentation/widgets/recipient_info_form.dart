import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/utils/heplers/validation_form.dart';

class RecipientInfoForm extends StatelessWidget {
  final TextEditingController? nameController;
  final TextEditingController? phoneController;
  const RecipientInfoForm({
    super.key,
    this.nameController,
    this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15.h,
      children: [
        Text(
          AppStrings.recipientInfo,
          style: AppTextStyle.font16black500,
        ),
        TextFormField(
          controller: nameController,
          keyboardType: TextInputType.name,
          validator: ValidationForm.nameValidator,
          decoration: InputDecoration(
            hintText: AppStrings.name,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
            contentPadding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validator: ValidationForm.phoneValidator,
          inputFormatters: [LengthLimitingTextInputFormatter(11)],
          decoration: InputDecoration(
            hintText: AppStrings.phoneNumber,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                "966+",
                style: AppTextStyle.font16black500,
              ),
            ),
            contentPadding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
      ],
    );
  }
}
