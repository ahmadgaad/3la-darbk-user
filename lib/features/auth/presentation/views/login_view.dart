import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/widgets/logo.dart';
import '../view_model/login_cubit/cubit.dart';
import '../view_model/login_cubit/state.dart';
import 'components/password_field.dart';
import 'components/phone_number_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final loginCubit = context.read<LoginCubit>();

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
          );
        }
      },
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        children: [
          30.verticalSpaceFromWidth,
          const Logo(size: 100),
          25.verticalSpaceFromWidth,
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: loginCubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PhoneNumberTextFornField(
                  controller: loginCubit.phoneController,
                ),
                25.verticalSpaceFromWidth,
                PasswordField(controller: loginCubit.passwordController),
                10.verticalSpaceFromWidth,
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgePassword);
                  },
                  child: Text(
                    AppStrings.forgetPassword,
                    style: AppTextStyle.font16black500,
                  ),
                ),
              ],
            ),
          ),
          30.verticalSpaceFromWidth,
          ElevatedButton(
            onPressed: loginCubit.login,
            child: const Text(AppStrings.login),
          ),
        ],
      ),
    );
  }
}
