import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/heplers/regex_helper.dart';
import 'package:ala_darbak_user/core/heplers/saudi_number_formater.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/core/widgets/custom_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/dependency_injection/di.dart';
import '../../../../core/widgets/logo.dart';
import '../../../../core/widgets/timer_widget.dart';
import '../view_model/forget_password_cubit/cubit.dart';
import '../view_model/forget_password_cubit/state.dart';
import 'components/custom_pin_code_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(sl()),
      child: Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.forget_password.tr())),
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
        child: CustomTextFormField(
          controller: cubit.phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
            SaudiNumberFormatter(),
          ],
          hintText: LocaleKeys.phone_number.tr(),
          suffixIcon: Text("966+", style: AppTextStyle.font16black500),
          prefixIcon: const Icon(Icons.phone, size: 25),
          validator: (value) {
            if (!RegexHelper.isPhoneNumberValid(value)) {
              return "أدخل رقم سعودي صحيح يبدأ بـ 5 ويتكون من 9 أرقام";
            }
            return null;
          },
        ),
      ),
      30.verticalSpaceFromWidth,
      ElevatedButton(
        onPressed: cubit.checkUserAndSendCode,
        child: Text(LocaleKeys.send_code.tr()),
      ),
    ],
  );

  Widget _codeForm(ForgetPasswordCubit cubit, String? code) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: cubit.formKey2,
        child: CustomPinCodeField(
          controller: cubit.codeController,
          onCompleted: cubit.checkCode,
          code: code,
        ),
      ),
      30.verticalSpaceFromWidth,
      ElevatedButton(
        onPressed: cubit.checkCode,
        child: const Text(LocaleKeys.confirm),
      ),
      15.verticalSpaceFromWidth,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${LocaleKeys.do_not_receive_code.tr()} ",
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
            CustomTextFormField(
              controller: cubit.passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: isPasswordVisible,
              hintText: LocaleKeys.password,
              prefixIcon: const Icon(Icons.lock, size: 25),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  size: 25,
                ),
              ),
              validator: (value) {
                if (!RegexHelper.isPasswordValid(value)) {
                  return "كلمة المرور يجب أن تكون 8 أحرف على الأقل وتحتوي على حرف كبير وصغير ورقم ورمز خاص";
                }
                return null;
              },
            ),

            25.verticalSpaceFromWidth,
            CustomTextFormField(
              controller: cubit.confirmPasswordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              hintText: LocaleKeys.confirm_password.tr(),
              prefixIcon: const Icon(Icons.lock, size: 25),
              validator: (value) {
                if (!RegexHelper.isConfirmPasswordValid(
                  cubit.passwordController.text,
                  value,
                )) {
                  return "كلمة المرور غير متطابقة";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      30.verticalSpaceFromWidth,
      ElevatedButton(
        onPressed: cubit.forgetPassword,
        child: const Text(LocaleKeys.confirm),
      ),
    ],
  );
}
