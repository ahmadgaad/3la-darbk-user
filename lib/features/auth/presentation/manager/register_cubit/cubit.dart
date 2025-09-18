import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_utils/app_strings.dart';
import '../../../../../core/utils/heplers/image_picker.dart';
import '../../../../../core/widgets/app_toaster.dart';
import '../../../repositories/models/user_model.dart';
import '../../../repositories/repositories.dart';
import 'state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(const RegisterState());


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPrivacyPolicyAccepted = false;
  File? image;
  
  pickImage() async {
    image = await ImagePickerUtils.getImage();
    emit(state.copyWith());
  }

  checkPrivacyPolicy(bool? v) {
    isPrivacyPolicyAccepted = !isPrivacyPolicyAccepted;
    emit(state.copyWith());
  }

  void checkUser() async {
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

  void register() async {
    if (formKey.currentState!.validate()&&isPrivacyPolicyAccepted) {
      emit(state.copyWith(loading: true));

      final result = await _authRepository.register(UserModel.register(
        imageFile: image,
        name: nameController.text,
        password: passwordController.text,
        mobile: phoneController.text,
      ));
      result.fold((l) => emit(state.copyWith(success: true, loading: false)),
          (r) => emit(state.copyWith(loading: false)));
    }
    else if(!isPrivacyPolicyAccepted){
      AppToaster.show(AppStrings.acceptPrivacyPolicy);
    }
  }
}
