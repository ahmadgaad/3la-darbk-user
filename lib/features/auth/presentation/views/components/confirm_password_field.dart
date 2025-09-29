import 'package:flutter/material.dart';

import '../../../../../core/heplers/validation_form.dart';
import '../../../../../core/utils/app_utils/app_strings.dart';

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final TextEditingController? password;
  const ConfirmPasswordField({super.key, this.controller, this.password});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true,
      validator: (v) {
        return Regex.confirmPasswordValidator(v, password?.text);
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: const InputDecoration(
        hintText: AppStrings.confirmPassword,
        prefixIcon: Icon(Icons.lock, size: 25),
      ),
    );
  }
}
