import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/routes/app_routes.dart';
import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/widgets/app_image_view.dart';
import '../../../../core/widgets/app_toaster.dart';
import '../../../../core/widgets/logo.dart';
import '../manager/register_cubit/cubit.dart';
import '../manager/register_cubit/state.dart';
import '../widgets/confirm_password_field.dart';
import '../widgets/name_field.dart';
import '../widgets/password_field.dart';
import '../widgets/phone_number_field.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (BuildContext context, RegisterState state) {
        if (state.success) {
          AppToaster.show(AppStrings.registerSuccess, isError: false);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoute.home,
            (_) => false,
          );
        }
      },
      builder: (context, state) {
        final registerCubit = context.read<RegisterCubit>();
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          children: [
            30.verticalSpaceFromWidth,
            const Logo(size: 100),
            25.verticalSpaceFromWidth,
            Form(
              key: registerCubit.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 25.w,
                children: [
                  IconButton(
                    onPressed: () {
                      registerCubit.pickImage();
                    },
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        AppImageView(
                          shape: BoxShape.circle,
                          file: registerCubit.image,
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
                  NameField(controller: registerCubit.nameController),
                  PhoneNumberField(controller: registerCubit.phoneController),
                  PasswordField(controller: registerCubit.passwordController),
                  ConfirmPasswordField(
                    controller: registerCubit.confirmPasswordController,
                    password: registerCubit.passwordController,
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoute.termsAndCondtions,
                        );
                      },
                      child: Text(
                        AppStrings.acceptPrivacyPolicy,
                        style: AppTextStyle.font16black500.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    value: registerCubit.isPrivacyPolicyAccepted,
                    onChanged: registerCubit.checkPrivacyPolicy,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),
            30.verticalSpaceFromWidth,
            ElevatedButton(
              onPressed: registerCubit.register,
              child: const Text(AppStrings.signUp),
            ),
          ],
        );
      },
    );
  }
}
