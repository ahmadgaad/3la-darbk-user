import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final EdgeInsetsGeometry? contentPadding;
  final BoxConstraints? suffixIconConstraints;
  final AutovalidateMode? autovalidateMode;
  const CustomTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.contentPadding,
    this.suffixIconConstraints,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        errorMaxLines: 2,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        contentPadding: contentPadding,
        suffixIconConstraints: suffixIconConstraints,
      ),
    );
  }
}
