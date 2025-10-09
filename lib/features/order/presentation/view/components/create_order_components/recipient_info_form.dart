import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/config/style/app_text_styles.dart';
import '../../../../../../core/heplers/regex_helper.dart';

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
          LocaleKeys.recipient_info.tr(),
          style: AppTextStyle.font16black500,
        ),
        TextFormField(
          controller: nameController,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (!RegexHelper.isNameValid(value)) {
              return "من فضلك أدخل الاسم كاملًا (الاسم الأول واسم العائلة)";
            }
            return null;
          },
          decoration: InputDecoration(
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
        ),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (!RegexHelper.isPhoneNumberValid(value)) {
              return "أدخل رقم سعودي صحيح يبدأ بـ 5 ويتكون من 9 أرقام";
            }
            return null;
          },
          inputFormatters: [LengthLimitingTextInputFormatter(11)],
          decoration: InputDecoration(
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
        ),
      ],
    );
  }
}
