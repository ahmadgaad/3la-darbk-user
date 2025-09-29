import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/dependency_injection/di.dart';
import 'package:ala_darbak_user/core/extensions/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/widgets/app_image_view.dart';
import '../../../../core/widgets/app_toaster.dart';
import '../../../../core/widgets/logo.dart';
import '../view_model/register_cubit/register_cubit.dart';
import '../view_model/register_cubit/register_states.dart';
import 'components/confirm_password_field.dart';
import 'components/name_field.dart';
import 'components/password_field.dart';
import 'components/phone_number_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          15.verticalSpace,
          const Logo(size: 100),
          15.verticalSpace,
          Form(
            key: sl<RegisterCubit>().formKey,
            child: Column(
              spacing: 22.h,
              children: [
                IconButton(
                  onPressed: () {
                    sl<RegisterCubit>().pickImage();
                  },
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      AppImageView(
                        shape: BoxShape.circle,
                        file: sl<RegisterCubit>().image,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        foregroundDecoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Icon(Icons.camera_alt, color: Colors.white),
                    ],
                  ),
                ),
                NameField(controller: sl<RegisterCubit>().nameController),
                PhoneNumberTextFornField(
                  controller: sl<RegisterCubit>().phoneController,
                ),
                PasswordField(
                  controller: sl<RegisterCubit>().passwordController,
                ),
                ConfirmPasswordField(
                  controller: sl<RegisterCubit>().confirmPasswordController,
                  password: sl<RegisterCubit>().passwordController,
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: InkWell(
                    onTap: () {
                      context.pushNamed(AppRoutes.termsAndCondtions);
                    },
                    child: Text(
                      AppStrings.acceptPrivacyPolicy,
                      style: AppTextStyle.font16black500.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  value: sl<RegisterCubit>().isPrivacyPolicyAccepted,
                  onChanged: sl<RegisterCubit>().checkPrivacyPolicy,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
          30.verticalSpaceFromWidth,
          BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state.success) {
                AppToaster.show(AppStrings.registerSuccess, isError: false);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (_) => false,
                );
              }
            },
            child: ElevatedButton(
              onPressed: sl<RegisterCubit>().register,
              child: const Text(AppStrings.signUp),
            ),
          ),
        ],
      ),
    );
  }
}
