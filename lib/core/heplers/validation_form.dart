import '../utils/app_utils/app_strings.dart';

class Regex {
  static String? saudiPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "من فضلك أدخل رقم الجوال";
    }

    final clean = value.replaceAll(RegExp(r'\D'), '');

    final regex = RegExp(r'^[5][0-9]{8}$');
    if (!regex.hasMatch(clean)) {
      return "أدخل رقم سعودي صحيح يبدأ بـ 5 ويتكون من 9 أرقام";
    }
    return null;
  }

  static String? passwordValidator(String? v) {
    if (v?.isEmpty ?? true) {
      return AppStrings.pleaseEnterPassword;
    } else if (v!.length <= 5) {
      return AppStrings.passwordNotValid;
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(String? v, String? text) {
    if (v?.isEmpty ?? true) {
      return AppStrings.passwordNotMatch;
    } else if (text != v) {
      return AppStrings.passwordNotMatch;
    } else {
      return null;
    }
  }

  static String? nameValidator(String? v) {
    if ((v?.isEmpty ?? true)) {
      return AppStrings.pleaseEnterName;
    } else {
      // Split the name by spaces and check if it has exactly four parts
      List<String> nameParts = v!.trim().split(RegExp(r'\s+'));
      if (nameParts.length != 4) {
        return AppStrings.pleaseEnterName;
      }
    }
    return null;
  }

  static String? unitsValidator(String? v) {
    if ((v?.isEmpty ?? true)) {
      return AppStrings.pleaseEnterUnits;
    }
    if ((int.tryParse(v ?? "0") ?? 0) < 1) {
      return AppStrings.unvalidUnit;
    }
    return null;
  }

  static String? codeValidator(String? v, String? code) {
    if (v?.isEmpty ?? true) {
      return AppStrings.pleaseEnterCode;
    } else if (v != code) {
      return AppStrings.invalidCode;
    } else {
      return null;
    }
  }
}
