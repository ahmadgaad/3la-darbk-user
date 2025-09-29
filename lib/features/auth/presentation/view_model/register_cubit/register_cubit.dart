import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_utils/app_strings.dart';
import '../../../../../core/widgets/app_toaster.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repository/repository.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(const RegisterState());

  // pickImage() async {
  //   image = await ImagePickerUtils.getImage();
  //   emit(state.copyWith());
  // }

  void checkUser({required TextEditingController phoneController}) async {
    emit(state.copyWith(loading: true));
    final result = await _authRepository.checkUserExists(
      mobile: phoneController.text,
    );
    result.fold((userExist) {
      if (userExist) {
        AppToaster.show(AppStrings.userExist);
        emit(state.copyWith(loading: false, userExist: userExist));
      } else {
        emit(state.copyWith(loading: false, userExist: userExist, step: 1));
      }
    }, (r) => emit(state.copyWith(loading: false, success: false)));
  }

  void register({
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
    File? image,
  }) async {
    emit(state.copyWith(loading: true));
    final result = await _authRepository.register(
      UserModel.register(
        imageFile: image,
        name: nameController.text,
        password: passwordController.text,
        mobile: phoneController.text,
      ),
    );
    result.fold(
      (l) => emit(state.copyWith(success: true, loading: false)),
      (r) => emit(state.copyWith(loading: false)),
    );
  }
}
