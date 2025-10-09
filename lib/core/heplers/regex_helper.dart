import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RegexHelper {
  static bool isNameValid(String? name) {
    if (name == null || name.trim().isEmpty) return false;

    // Split by whitespace
    List<String> nameParts = name.trim().split(RegExp(r'\s+'));

    // Require at least first + last name
    if (nameParts.length < 2) return false;

    // Allow only letters, apostrophes, and hyphens
    final validPattern = RegExp(r"^[a-zA-Z\u0600-\u06FF'-]+$");

    // Check each part
    for (final part in nameParts) {
      if (!validPattern.hasMatch(part)) {
        return false;
      }
    }

    return true;
  }

  static bool isPhoneNumberValid(String? number) {
    if (number == null || number.isEmpty) return false;

    final clean = number.replaceAll(RegExp(r'\D'), '');
    final regex = RegExp(r'^[5][0-9]{8}$');

    return regex.hasMatch(clean);
  }

  static bool isPasswordValid(String? password) {
    if (password == null || password.isEmpty) return false;

    return RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
    ).hasMatch(password);
  }

  static bool isConfirmPasswordValid(
    String? password,
    String? confirmPassword,
  ) {
    if (password == null || confirmPassword == null) return false;
    if (password.isEmpty || confirmPassword.isEmpty) return false;

    return password == confirmPassword;
  }

  static String? unitsValidator(String? v) {
    if ((v?.isEmpty ?? true)) {
      return LocaleKeys.please_enter_units.tr();
    }
    if ((int.tryParse(v ?? "0") ?? 0) < 1) {
      return LocaleKeys.invalid_unit.tr();
    }
    return null;
  }

  static String? codeValidator(String? v, String? code) {
    if (v?.isEmpty ?? true) {
      return LocaleKeys.please_enter_code.tr();
    } else if (v != code) {
      return LocaleKeys.invalid_code.tr();
    } else {
      return null;
    }
  }
}
