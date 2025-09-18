import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/utils/app_utils/app_strings.dart';
import '../../../../../core/utils/heplers/image_picker.dart';
import '../../../../../core/widgets/app_toaster.dart';
import '../../../repositories/repositories.dart';
import 'state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(const ProfileState());


  void getProfile() async {
    final result = await _profileRepository.getClientData();
    result.fold((l) {
      emit(state.copyWith(isSuccess: true, currentUser: l, loading: false));
      _initFormField();
    }, (r) {
      if (r.message.contains('Unauthenticated')) {
        logout();
      }

      emit(state.copyWith(loading: false, isSuccess: false));
    });
  }

  void logout() async {
    final result = await _profileRepository.logout();
    result.fold((l) {
      AppRoute.pushNamedAndRemoveUntil(AppRoute.auth);
      emit(state.copyWith(isSuccess: true, isLogedOut: true, loading: false));
    }, (r) => emit(state.copyWith(loading: false, isSuccess: false)));
  }

  void delete() async {
    emit(state.copyWith(loading: true));
    final result = await _profileRepository.delete();
    result.fold((value) {
      AppToaster.show(AppStrings.deletedSuccessfully, isError: false);
      AppRoute.pushNamedAndRemoveUntil(AppRoute.auth);
      emit(state.copyWith(isSuccess: true, loading: false));
    }, (r) => emit(state.copyWith(loading: false, isSuccess: false)));
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  File? image;
  pickImage() async {
    image = await ImagePickerUtils.getImage();
    emit(state.copyWith());
  }


  void _initFormField() {
    phoneController.text = state.currentUser?.mobile ?? "";
    nameController.text = state.currentUser?.name ?? "";
  }

  void updateData() async {
    if (state.currentUser == null) return;
    if (!formKey.currentState!.validate()) return;
    emit(state.copyWith(loading: true));
    final result = await _profileRepository.updateData(state.currentUser!
        .copyWith(
            imageFile: image,
            name: nameController.text,
            mobile: phoneController.text));
    result.fold((value) {
      AppToaster.show(AppStrings.updatedSuccessfully, isError: false);
      emit(state.copyWith(isSuccess: true, currentUser: value, loading: false));
      _initFormField();
    }, (r) => emit(state.copyWith(loading: false, isSuccess: false)));
  }
}
