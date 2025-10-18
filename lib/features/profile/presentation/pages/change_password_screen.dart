import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/heplers/regex_helper.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/core/widgets/custom_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/dependency_injection/di.dart';
import '../../../../core/widgets/app_toaster.dart';
import '../manager/change_password/cubit.dart';
import '../manager/change_password/state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(sl()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.change_password.tr()),
          centerTitle: true,
        ),
        body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state.isSuccess) {
              AppToaster.show(LocaleKeys.password_changed.tr(), isError: false);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (_) => false,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ChangePasswordCubit>();
            return LoadingOverlay(
              isLoading: state.loading,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                children: [
                  50.verticalSpaceFromWidth,
                  Form(
                    key: cubit.formKey,
                    child: Column(
                      spacing: 20.w,
                      children: [
                        CustomTextFormField(
                          controller: cubit.oldPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isOldPasswordVisible,
                          hintText: LocaleKeys.old_password.tr(),
                          prefixIcon: const Icon(Icons.lock, size: 25),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isOldPasswordVisible = !isOldPasswordVisible;
                              });
                            },
                            icon: Icon(
                              isOldPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 25,
                            ),
                          ),
                          validator: (value) {
                            if (!RegexHelper.isPasswordValid(value)) {
                              return r"كلمة المرور يجب أن تكون 8 أحرف على الأقل وتحتوي على حرف كبير وصغير ورقم ورمز خاص (@$!%*?&=_)";
                            }
                            return null;
                          },
                        ),

                        CustomTextFormField(
                          controller: cubit.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isNewPasswordVisible,
                          hintText: LocaleKeys.password.tr(),
                          prefixIcon: const Icon(Icons.lock, size: 25),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isNewPasswordVisible = !isNewPasswordVisible;
                              });
                            },
                            icon: Icon(
                              isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 25,
                            ),
                          ),
                          validator: (value) {
                            if (!RegexHelper.isPasswordValid(value)) {
                              return r"كلمة المرور يجب أن تكون 8 أحرف على الأقل وتحتوي على حرف كبير وصغير ورقم ورمز خاص (@$!%*?&=_)";
                            }
                            return null;
                          },
                        ),
                        CustomTextFormField(
                          controller: cubit.confirmPasswordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: LocaleKeys.confirm_password.tr(),
                          prefixIcon: const Icon(Icons.lock, size: 25),
                          validator: (confirmationPassword) {
                            if (!RegexHelper.isConfirmPasswordValid(
                              cubit.passwordController.text,
                              confirmationPassword,
                            )) {
                              return "كلمة المرور غير متطابقة";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpaceFromWidth,
                  ElevatedButton(
                    onPressed: cubit.changePassword,
                    child: const Text(LocaleKeys.confirm),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
