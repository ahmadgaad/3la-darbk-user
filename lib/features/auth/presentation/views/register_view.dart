import 'dart:io';

import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/extensions/navigation.dart';
import 'package:ala_darbak_user/core/heplers/image_picker.dart';
import 'package:ala_darbak_user/core/heplers/regex_helper.dart';
import 'package:ala_darbak_user/core/heplers/saudi_number_formater.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/auth/data/models/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/widgets/app_image_view.dart';
import '../../../../core/widgets/app_toaster.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/logo.dart';
import '../view_model/register_cubit/register_cubit.dart';
import '../view_model/register_cubit/register_states.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  File? image;
  bool isPrivacyPolicyAccepted = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

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
            key: formKey,
            child: Column(
              spacing: 22.h,
              children: [
                IconButton(
                  onPressed: () async {
                    image = await ImagePickerUtils.getImage();
                    setState(() {});
                  },
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      AppImageView(
                        shape: BoxShape.circle,
                        file: image,
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
                CustomTextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  hintText: LocaleKeys.name.tr(),
                  prefixIcon: const Icon(Icons.person, size: 25),
                  validator: (value) {
                    if (!RegexHelper.isNameValid(value)) {
                      return "من فضلك أدخل الاسم كاملًا (الاسم الأول واسم العائلة)";
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  controller: phoneController,
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
                CustomTextFormField(
                  controller: passwordController,
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
                  validator: (value) {
                    if (!RegexHelper.isPasswordValid(value)) {
                      return r"كلمة المرور يجب أن تكون 8 أحرف على الأقل وتحتوي على حرف كبير وصغير ورقم ورمز خاص (@$!%*?&=_)";
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: LocaleKeys.confirm_password.tr(),
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock, size: 25),
                  validator: (value) {
                    if (!RegexHelper.isConfirmPasswordValid(
                      passwordController.text,
                      value,
                    )) {
                      return "كلمة المرور غير متطابقة";
                    }
                    return null;
                  },
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: InkWell(
                    onTap: () {
                      context.pushNamed(AppRoutes.termsAndCondtions);
                    },
                    child: Text(
                      LocaleKeys.accept_privacy_policy.tr(),
                      style: AppTextStyle.font16black500.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  value: isPrivacyPolicyAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      isPrivacyPolicyAccepted = !isPrivacyPolicyAccepted;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
          30.verticalSpaceFromWidth,

          BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state.success) {
                AppToaster.show(
                  LocaleKeys.register_success.tr(),
                  isError: false,
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (_) => false,
                );
              }
            },
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() &&
                    isPrivacyPolicyAccepted) {
                  context.read<RegisterCubit>().register(
                    user: UserModel(
                      imageFile: image,
                      name: nameController.text,
                      password: passwordController.text,
                      mobile: phoneController.text,
                    ),
                  );
                } else if (!isPrivacyPolicyAccepted) {
                  AppToaster.show(LocaleKeys.accept_privacy_policy.tr());
                }
              },
              child: Text(LocaleKeys.sign_up.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
