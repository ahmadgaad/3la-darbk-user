import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/extensions/navigation.dart';
import 'package:ala_darbak_user/core/heplers/regex_helper.dart';
import 'package:ala_darbak_user/core/heplers/saudi_number_formater.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/core/widgets/custom_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_text_styles.dart';
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
          context.pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
        }
      },
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        children: [
          15.verticalSpace,
          const Logo(size: 100),
          25.verticalSpace,
          Form(
            key: loginCubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  controller: loginCubit.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                    SaudiNumberFormatter(),
                  ],
                  hintText: LocaleKeys.phone_number.tr(),
                  suffixIcon: Text("966+", style: AppTextStyle.font16black500),
                  prefixIcon: const Icon(Icons.phone, size: 25),
                  validator: (phoneNumber) {
                    if (phoneNumber == null || phoneNumber.isEmpty) {
                      return LocaleKeys.please_enter_phone_number.tr();
                    } else if (!RegexHelper.isPhoneNumberValid(phoneNumber)) {
                      return LocaleKeys.please_enter_valid_phone_number.tr();
                    }
                    return null;
                  },
                ),
                25.verticalSpaceFromWidth,
                CustomTextFormField(
                  controller: loginCubit.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !isPasswordVisible,
                  hintText: LocaleKeys.password.tr(),
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
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return LocaleKeys.please_enter_password.tr();
                    }
                    return null;
                  },
                ),
                10.verticalSpaceFromWidth,
                TextButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.forgePassword);
                  },
                  child: Text(
                    LocaleKeys.forget_password.tr(),
                    style: AppTextStyle.font16black500,
                  ),
                ),
              ],
            ),
          ),
          30.verticalSpaceFromWidth,
          ElevatedButton(
            onPressed: loginCubit.login,
            child: Text(LocaleKeys.login.tr()),
          ),
        ],
      ),
    );
  }
}
