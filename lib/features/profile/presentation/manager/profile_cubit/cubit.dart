import 'dart:io';

import 'package:ala_darbak_user/core/dependency_injection/di.dart';
import 'package:ala_darbak_user/core/heplers/shared_preferences_helper.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/heplers/image_picker.dart';
import '../../../../../core/widgets/app_toaster.dart';
import '../../../data/repositories.dart';
import 'state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(const ProfileState());

  void getProfile() async {
    final result = await _profileRepository.getClientData();
    result.fold(
      (l) {
        emit(state.copyWith(isSuccess: true, currentUser: l, loading: false));
        _initFormField();
      },
      (r) {
        if (r.message.contains('Unauthenticated')) {
          logout();
        }

        emit(state.copyWith(loading: false, isSuccess: false));
      },
    );
  }

  void logout() async {
    final result = await _profileRepository.logout();
    result.fold(
      (l) {
        emit(state.copyWith(isSuccess: true, isLogedOut: true, loading: false));
      },
      (r) {
        emit(state.copyWith(loading: false, isSuccess: false));
      },
    );
  }

  void delete() async {
    emit(state.copyWith(loading: true));
    final result = await _profileRepository.delete();
    result.fold((value) {
      AppToaster.show(LocaleKeys.deleted_successfully.tr(), isError: false);
      emit(state.copyWith(isSuccess: true, isDeleted: true, loading: false));
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
    final result = await _profileRepository.updateData(
      state.currentUser!.copyWith(
        imageFile: image,
        name: nameController.text,
        mobile: phoneController.text,
      ),
    );
    result.fold((value) {
      AppToaster.show(LocaleKeys.updated_successfully.tr(), isError: false);
      emit(state.copyWith(isSuccess: true, currentUser: value, loading: false));
      _initFormField();
    }, (r) => emit(state.copyWith(loading: false, isSuccess: false)));
  }

  // Language management
  Future<void> toggleLanguage(BuildContext context) async {
    final currentLocale = context.locale;
    final newLocale =
        currentLocale.languageCode == 'ar'
            ? const Locale('en')
            : const Locale('ar');

    // Save to cache
    await sl<SharedPreferencesHelper>().saveData(
      key: 'locale',
      value: newLocale.languageCode,
    );

    if (context.mounted) {
      // Apply the new locale
      await context.setLocale(newLocale);
    }
  }
}
