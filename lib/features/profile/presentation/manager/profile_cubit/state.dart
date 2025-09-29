

import '../../../../auth/data/models/user_model.dart';

class ProfileState  {
  final bool loading;
  final UserModel? currentUser;

  final bool isSuccess;
  final bool isLogedOut;

  const ProfileState(
      {this.isLogedOut = false, this.currentUser, this.loading = false, this.isSuccess = false});

  ProfileState copyWith(
          {UserModel? currentUser,
          bool? loading,
          bool? isLogedOut,
          bool? isSuccess}) =>
      ProfileState(
          loading: loading ?? this.loading,
          isLogedOut: isLogedOut ?? this.isLogedOut,
          currentUser: currentUser ?? this.currentUser,
          isSuccess: isSuccess ?? this.isSuccess);
          
            
}
