import 'package:flutter/material.dart';

import '../../../../../core/utils/app_utils/app_strings.dart';
import '../../../../../core/heplers/validation_form.dart';

class NameField extends StatelessWidget {
  final TextEditingController? controller;
  const NameField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: Regex.nameValidator, 
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        hintText: AppStrings.name,
        prefixIcon: Icon(Icons.person, size: 25),
      ),
    );
  }
}
