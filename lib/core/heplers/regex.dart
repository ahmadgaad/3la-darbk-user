import '../utils/app_strings.dart';

class Regex {
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


    // if ((v?.isEmpty ?? true)) {
    //   return AppStrings.pleaseEnterName;
    // } else {
    //   // Split the name by spaces and check if it has exactly four parts
    //   List<String> nameParts = v!.trim().split(RegExp(r'\s+'));
    //   if (nameParts.length != 4) {
    //     return AppStrings.pleaseEnterName;
    //   }
    // }
    // return null;