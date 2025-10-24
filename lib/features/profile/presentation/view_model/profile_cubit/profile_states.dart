import '../../../../auth/data/models/user_model.dart';

class ProfileState {
  final bool loading;
  final UserModel? currentUser;

  final bool isSuccess;
  final bool isLogedOut;
  final bool isDeleted;
  final String? currentLanguage;

  const ProfileState({
    this.isLogedOut = false,
    this.isDeleted = false,
    this.currentUser,
    this.loading = false,
    this.isSuccess = false,
    this.currentLanguage,
  });

  ProfileState copyWith({
    UserModel? currentUser,
    bool? loading,
    bool? isLogedOut,
    bool? isDeleted,
    bool? isSuccess,
    String? currentLanguage,
  }) => ProfileState(
    loading: loading ?? this.loading,
    isLogedOut: isLogedOut ?? this.isLogedOut,
    isDeleted: isDeleted ?? this.isDeleted,
    currentUser: currentUser ?? this.currentUser,
    isSuccess: isSuccess ?? this.isSuccess,
    currentLanguage: currentLanguage ?? this.currentLanguage,
  );
}
