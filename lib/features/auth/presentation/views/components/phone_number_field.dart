import 'package:ala_darbak_user/core/heplers/saudi_number_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/config/style/app_text_styles.dart';
import '../../../../../core/heplers/validation_form.dart';
import '../../../../../core/utils/app_utils/app_strings.dart';

class PhoneNumberTextFornField extends StatelessWidget {
  final TextEditingController? controller;
  const PhoneNumberTextFornField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: Regex.saudiPhoneValidator,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9),
        SaudiNumberFormatter(),
      ],
      decoration: InputDecoration(
        hintText: AppStrings.phoneNumber,
        suffixIcon: Text("966+", style: AppTextStyle.font16black500),
        prefixIcon: const Icon(Icons.phone, size: 25),
      ),
    );
  }
}
