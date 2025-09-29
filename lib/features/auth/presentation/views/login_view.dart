import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/heplers/regex.dart';
import 'package:ala_darbak_user/core/heplers/saudi_number_formater.dart';
import 'package:ala_darbak_user/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/widgets/logo.dart';
import '../view_model/login_cubit/cubit.dart';
import '../view_model/login_cubit/state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with AutomaticKeepAliveClientMixin {
  bool isPasswordVisible = false;
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
                CustomTextFormField(
                  controller: loginCubit.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                    SaudiNumberFormatter(),
                  ],
                  hintText: AppStrings.phoneNumber,
                  suffixIcon: Text("966+", style: AppTextStyle.font16black500),
                  prefixIcon: const Icon(Icons.phone, size: 25),
                  validator: (value) {
                    if (!Regex.isPhoneNumberValid(value)) {
                      return "أدخل رقم سعودي صحيح يبدأ بـ 5 ويتكون من 9 أرقام";
                    }
                    return null;
                  },
                ),
                25.verticalSpaceFromWidth,
                CustomTextFormField(
                  controller: loginCubit.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isPasswordVisible,
                  hintText: AppStrings.password,
                  prefixIcon: const Icon(Icons.lock, size: 25),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 25,
                    ),
                  ),
                  validator: (value) {
                    if (!Regex.isPasswordValid(value)) {
                      return "كلمة المرور يجب أن تكون 8 أحرف على الأقل وتحتوي على حرف كبير وصغير ورقم ورمز خاص";
                    }
                    return null;
                  },
                ),
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
