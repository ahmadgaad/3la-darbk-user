import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool loading;
  final bool isSuccess;

  const LoginState({ this.loading = false, this.isSuccess = false});

  LoginState copyWith({ bool? loading, bool? isSuccess}) =>
      LoginState(
          loading: loading ?? this.loading,
          isSuccess: isSuccess ?? this.isSuccess);
          
            @override
            List<Object?> get props => [
              loading,
              isSuccess
            ];
}
