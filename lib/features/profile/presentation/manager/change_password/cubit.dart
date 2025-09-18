import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/repositories.dart';
import 'state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ProfileRepository _profileRepository;

  ChangePasswordCubit(this._profileRepository) : super(const ChangePasswordState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  void changePassword() async {
    if (formKey.currentState!.validate()) {
      emit(state.copyWith(loading: true));
      final result = await _profileRepository.changePassword(
          oldPassword: oldPasswordController.text,
          password: passwordController.text);
      result.fold(
          (value) => emit(state.copyWith(isSuccess: true, loading: false)),
          (r) => emit(state.copyWith(loading: false, isSuccess: false)));
    }
  }
}
