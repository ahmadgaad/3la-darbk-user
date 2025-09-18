import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/extentions/extention.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/style/app_text_styles.dart';
import '../../../../core/widgets/logo.dart';
import '../manager/login_cubit/cubit.dart';
import '../manager/login_cubit/state.dart';
import '../widgets/password_field.dart';
import '../widgets/phone_number_field.dart';
import '../../../../core/utils/app_utils/app_strings.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoute.home, (_) => false);
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
                PhoneNumberField(controller: loginCubit.phoneController),
                25.verticalSpaceFromWidth,
                PasswordField(controller: loginCubit.passwordController),
                10.verticalSpaceFromWidth,
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoute.forgePassword);
                    },
                    child: Text(
                      AppStrings.forgetPassword,
                      style: AppTextStyle.font16black500,
                    )),
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
