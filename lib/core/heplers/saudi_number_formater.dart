import 'package:flutter/services.dart';

class SaudiNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), ''); // remove spaces
    String formatted = '';

    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];
      // add space after every 3 digits, but not at the end
      if ((i + 1) % 3 == 0 && i + 1 != digits.length) {
        formatted += ' ';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
