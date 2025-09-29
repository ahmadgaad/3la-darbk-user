class RegisterState {
  final int step;
  final bool userExist;
  final bool loading;
  final bool success;

  const RegisterState({
    this.step = 0,
    this.loading = false,
    this.success = false,
    this.userExist = false,
  });

  RegisterState copyWith({
    int? step,
    bool? loading,
    bool? success,
    bool? userExist,
  }) => RegisterState(
    userExist: userExist ?? this.userExist,
    step: step ?? this.step,
    loading: loading ?? this.loading,
    success: success ?? this.success,
  );
}
