import 'package:flutter/material.dart';

import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/utils/heplers/validation_form.dart';

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final TextEditingController? password;
  const ConfirmPasswordField({super.key, this.controller, this.password});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (v) {
        return ValidationForm.confirmPasswordValidator(v, password?.text);
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: const InputDecoration(
        hintText: AppStrings.confirmPassword,
        prefixIcon: Icon(Icons.lock, size: 25),
      ),
    );
  }
}
