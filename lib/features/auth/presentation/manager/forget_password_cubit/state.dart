import 'package:equatable/equatable.dart';

class ForgetPasswordState extends Equatable {
  final bool loading;
  final bool success;
  final bool userExist;
  final bool codeValid;
  final bool passwordChanged;
  final String? code;

  const ForgetPasswordState(
      {this.loading = false,
      this.success = false,
      this.code,
      this.userExist = false,
      this.codeValid = false,
      this.passwordChanged = false});

  ForgetPasswordState copyWith(
          {bool? loading,
          bool? success,
          String? code,
          bool? userExist,
          bool? codeValid,
          bool? passwordChanged}) =>
      ForgetPasswordState(
          userExist: userExist ?? this.userExist,
          codeValid: codeValid ?? this.codeValid,
          passwordChanged: passwordChanged ?? this.passwordChanged,
          code: code ?? this.code,
          loading: loading ?? this.loading,
          success: success ?? this.success);
          
            @override
            List<Object?> get props => [
              loading,
              success,
              userExist,
              codeValid,
              passwordChanged,
              code
            ];
}
