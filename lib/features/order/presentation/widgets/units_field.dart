import 'package:ala_darbak_user/core/utils/heplers/validation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';

class UnitsField extends StatelessWidget {
  final TextEditingController? controller;
  const UnitsField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.w,
      children: [
        Text(
          AppStrings.unitsNumber,
          style: AppTextStyle.font16black500,
        ),
        Flexible(
          child: TextFormField(
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,validator: ValidationForm.unitsValidator,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomMinValueFormatter extends TextInputFormatter {
  final int minValue;

  _CustomMinValueFormatter({required this.minValue});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return TextEditingValue(text: minValue.toString());
    }
    final int? newNumber = int.tryParse(newValue.text);
    if (newNumber == null || newNumber < minValue) {
      return oldValue; // Revert to the old value if invalid
    }
    return newValue; // Accept the new value if valid
  }
}
