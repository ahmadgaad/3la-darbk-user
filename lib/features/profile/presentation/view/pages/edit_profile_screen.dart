import 'package:ala_darbak_user/core/config/style/app_text_styles.dart';
import 'package:ala_darbak_user/core/heplers/regex_helper.dart';
import 'package:ala_darbak_user/core/heplers/saudi_number_formater.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../../core/widgets/app_image_view.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../view_model/profile_cubit/profile_cubit.dart';
import '../../view_model/profile_cubit/profile_states.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.profile.tr()), centerTitle: true),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          return LoadingOverlay(
            isLoading: state.loading,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              children: [
                Center(
                  child: IconButton(
                    onPressed: () {
                      cubit.pickImage();
                    },
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        AppImageView(
                          shape: BoxShape.circle,
                          url: state.currentUser?.image ?? "no-image",
                          file: cubit.image,
                          width: 80.w,
                          height: 80.h,
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
                ),
                25.verticalSpaceFromWidth,
                Form(
                  key: cubit.formKey,
                  child: Column(
                    spacing: 10.h,
                    children: [
                      CustomTextFormField(controller: cubit.nameController),
                      CustomTextFormField(
                        controller: cubit.phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                          SaudiNumberFormatter(),
                        ],
                        hintText: LocaleKeys.phone_number.tr(),
                        suffixIcon: Text(
                          "966+",
                          style: AppTextStyle.font16black500,
                        ),
                        prefixIcon: const Icon(Icons.phone, size: 25),
                        validator: (value) {
                          if (!RegexHelper.isPhoneNumberValid(value)) {
                            return "أدخل رقم سعودي صحيح يبدأ بـ 5 ويتكون من 9 أرقام";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                20.verticalSpaceFromWidth,
                ElevatedButton(
                  onPressed: cubit.updateData,
                  child: Text(LocaleKeys.confirm.tr()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
