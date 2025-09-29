import 'package:flutter/material.dart';

import '../../../../../core/heplers/validation_form.dart';
import '../../../../../core/utils/app_utils/app_strings.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  const PasswordField({super.key, this.controller, this.hintText});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !isVisible,
      validator: Regex.passwordValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: widget.hintText ?? AppStrings.password,
        prefixIcon: const Icon(Icons.lock, size: 25),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            size: 25,
          ),
        ),
      ),
    );
  }
}
