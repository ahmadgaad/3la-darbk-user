import 'package:ala_darbak_user/core/heplers/saudi_number_formater.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/core/widgets/custom_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/config/style/app_text_styles.dart';
import '../../../../../../core/heplers/regex_helper.dart';

class RecipientInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const RecipientInfoForm({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15.h,
      children: [
        Text(
          LocaleKeys.recipient_info.tr(),
          style: AppTextStyle.font16black500,
        ),
        CustomTextFormField(
          controller: nameController,
          keyboardType: TextInputType.name,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (value) {
            if (!RegexHelper.isNameValid(value)) {
              return LocaleKeys.please_enter_name.tr();
            }
            return null;
          },
          hintText: LocaleKeys.name.tr(),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          contentPadding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
        CustomTextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (value) {
            if (!RegexHelper.isPhoneNumberValid(value)) {
              return LocaleKeys.please_enter_saudi_phone_number.tr();
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
            SaudiNumberFormatter(),
          ],
          hintText: LocaleKeys.phone_number.tr(),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text("966+", style: AppTextStyle.font16black500),
          ),
          contentPadding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
      ],
    );
  }
}
