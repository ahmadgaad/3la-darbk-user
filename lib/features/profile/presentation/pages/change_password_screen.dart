import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/dependency_injection/di.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/widgets/app_toaster.dart';
import '../../../auth/presentation/views/components/confirm_password_field.dart';
import '../../../auth/presentation/views/components/password_field.dart';
import '../manager/change_password/cubit.dart';
import '../manager/change_password/state.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(sl()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.changePassword),
          centerTitle: true,
        ),
        body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state.isSuccess) {
              AppToaster.show(AppStrings.passwordChanged, isError: false);
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
                        PasswordField(
                          controller: cubit.oldPasswordController,
                          hintText: AppStrings.oldPassword,
                        ),
                        PasswordField(controller: cubit.passwordController),
                        ConfirmPasswordField(
                          controller: cubit.confirmPasswordController,
                          password: cubit.passwordController,
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpaceFromWidth,
                  ElevatedButton(
                    onPressed: cubit.changePassword,
                    child: const Text(AppStrings.confirm),
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
