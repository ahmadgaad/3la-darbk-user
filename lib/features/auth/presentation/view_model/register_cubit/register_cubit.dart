import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repository/repository.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(const RegisterState());

  Future<void> register({required UserModel user}) async {
    emit(state.copyWith(loading: true));
    final result = await _authRepository.register(user);
    result.fold(
      (l) => emit(state.copyWith(success: true, loading: false)),
      (r) => emit(state.copyWith(loading: false)),
    );
  }
}
