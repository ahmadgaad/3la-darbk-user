
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/repositories.dart';
import 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  
  final TextEditingController passwordController = TextEditingController();

  void login() async {
   
    if (formKey.currentState!.validate()) {
      emit(state.copyWith(loading: true));
     
      final result = await _authRepository.login(
          mobile: phoneController.text, password: passwordController.text);

      result.fold((l) => emit(state.copyWith(isSuccess: true, loading: false)),
          (r) => emit(state.copyWith(loading: false)));
    }
  }
}
