
import 'package:equatable/equatable.dart';

import '../../../../auth/repositories/models/user_model.dart';

class ChangePasswordState extends Equatable {
  final bool loading;
  final bool isSuccess;

  const ChangePasswordState({this.loading = false, this.isSuccess = false});

  ChangePasswordState copyWith(
          {UserModel? userModel,
          bool? loading,
          bool? isLogedOut,
          bool? isSuccess}) =>
      ChangePasswordState(
          loading: loading ?? this.loading,
          isSuccess: isSuccess ?? this.isSuccess);
          
            @override
            List<Object?> get props => [
              loading,
              isSuccess,
            ];
}
