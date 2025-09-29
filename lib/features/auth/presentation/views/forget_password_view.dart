import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/dependency_injection/di.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/widgets/logo.dart';
import '../../../../core/widgets/timer_widget.dart';
import '../view_model/forget_password_cubit/cubit.dart';
import '../view_model/forget_password_cubit/state.dart';
import 'components/code_field.dart';
import 'components/confirm_password_field.dart';
import 'components/password_field.dart';
import 'components/phone_number_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(sl()),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.forgetPassword)),
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state.passwordChanged) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.auth,
                (_) => false,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ForgetPasswordCubit>();

            return LoadingOverlay(
              isLoading: state.loading,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                children: [
                  30.verticalSpaceFromWidth,
                  const Logo(size: 100),
                  35.verticalSpaceFromWidth,
                  state.codeValid
                      ? _changePasswordForm(cubit)
                      : state.userExist
                      ? _codeForm(cubit, state.code)
                      : _phoneForm(cubit),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _phoneForm(ForgetPasswordCubit cubit) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: cubit.formKey,
        child: PhoneNumberTextFornField(controller: cubit.phoneController),
      ),
      30.verticalSpaceFromWidth,
      ElevatedButton(
        onPressed: cubit.checkUserAndSendCode,
        child: const Text(AppStrings.sendCode),
      ),
    ],
  );

  Widget _codeForm(ForgetPasswordCubit cubit, String? code) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: cubit.formKey2,
        child: CodeField(
          controller: cubit.codeController,
          onCompleted: cubit.checkCode,
          code: code,
        ),
      ),
      30.verticalSpaceFromWidth,
      ElevatedButton(
        onPressed: cubit.checkCode,
        child: const Text(AppStrings.confirm),
      ),
      15.verticalSpaceFromWidth,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${AppStrings.doNotReceiveCode} ",
            style: AppTextStyle.font16black500,
          ),
          TimerWidget(
            onReset: cubit.sendCode,
            textStyle: AppTextStyle.font16secondary600,
          ),
        ],
      ),
    ],
  );
  Widget _changePasswordForm(ForgetPasswordCubit cubit) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: cubit.formKey3,
        child: Column(
          children: [
            PasswordField(controller: cubit.passwordController),
            25.verticalSpaceFromWidth,
            ConfirmPasswordField(
              controller: cubit.confirmPasswordController,
              password: cubit.passwordController,
            ),
          ],
        ),
      ),
      30.verticalSpaceFromWidth,
      ElevatedButton(
        onPressed: cubit.forgetPassword,
        child: const Text(AppStrings.confirm),
      ),
    ],
  );
}
