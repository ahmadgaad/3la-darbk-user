import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/app_toaster.dart';
import '../../../data/repository/repository.dart';
import 'state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepository _authRepository;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ForgetPasswordCubit(this._authRepository) : super( const ForgetPasswordState());


  void checkUserAndSendCode() async {
    if (formKey.currentState!.validate()) {
      emit(state.copyWith(loading: true));
      final result = await _authRepository.checkUserExists(
        mobile: phoneController.text,
      );
      result.fold((userExist) {
        if (userExist) {
          emit(state.copyWith(success: true, userExist: userExist));
          sendCode();
        } else {
          AppToaster.show(AppStrings.userNotExist,);
          emit(state.copyWith(loading: false, success: true));
        }
      }, (r) => emit(state.copyWith(loading: false, success: false)));
    }
  }

  void sendCode() async {
    emit(state.copyWith(loading: true));
    final result = await _authRepository.sendCode(
      mobile: phoneController.text,
    );
    result.fold((code) {
      AppToaster.show("${AppStrings.codeSent} $code", isError: false);
      emit(state.copyWith(success: true, loading: false, code: code));
    }, (r) => emit(state.copyWith(loading: false, success: false)));
  }

  checkCode(){
    if (formKey2.currentState!.validate()) {
      emit(state.copyWith(codeValid: true));
    }
  }

  void forgetPassword() async {
    if (formKey3.currentState!.validate()) {
      emit(state.copyWith(loading: true));
      final result = await _authRepository.forgetPassword(
          mobile: phoneController.text,
          password: passwordController.text,
          code: codeController.text);
      result.fold((l) => emit(state.copyWith(success: true,passwordChanged: true, loading: false)),
          (r) => emit(state.copyWith(loading: false, success: false)));
    }
  }
}
