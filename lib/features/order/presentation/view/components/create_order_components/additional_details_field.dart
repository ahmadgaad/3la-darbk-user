import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/config/style/app_text_styles.dart';

class AdditionalDetailsField extends StatelessWidget {
  final TextEditingController? controller;
  const AdditionalDetailsField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.additional_details.tr(),
          style: AppTextStyle.font16black500,
        ),
        SizedBox(
          height: 100.w,
          child: TextFormField(
            maxLines: null,
            controller: controller,
            expands: true,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
              contentPadding: EdgeInsets.only(
                top: 10.h,
                left: 10.w,
                right: 10.w,
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
