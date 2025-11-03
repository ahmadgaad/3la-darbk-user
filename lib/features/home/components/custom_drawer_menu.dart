import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/extensions/navigation.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/home/components/custom_drawer_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/style/app_color.dart';
import '../../profile/presentation/view/components/delete_account_dialog.dart';
import '../../profile/presentation/view_model/profile_cubit/profile_cubit.dart';
import '../../profile/presentation/view_model/profile_cubit/profile_states.dart';
import '../../settings/presentation/manager/cubit.dart';
import '../../shipments/presentation/view_model/shipments_cubit.dart';

class CustomDrawerMenu extends StatelessWidget {
  const CustomDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustonDrawerHeader(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.editProfile);
                  },
                  leading: const Icon(Icons.person_pin_rounded),
                  title: Text(LocaleKeys.profile.tr()),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.changePassword);
                  },
                  leading: const Icon(Icons.lock_outline),
                  title: Text(LocaleKeys.change_password.tr()),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.historyOrders,
                      arguments: context.read<ShipmentsCubit>(),
                    );
                    Scaffold.of(context).closeDrawer();
                  },
                  leading: const Icon(Icons.history_rounded),
                  title: Text(LocaleKeys.orders_history.tr()),
                ),
                ListTile(
                  onTap: () async {
                    final url =
                        "tel:${context.read<SettingsInfoCubit>().state.settingsInfo?.callUs ?? "0"}";
                    if (await launchUrl(Uri.parse(url))) {}
                  },
                  leading: const Icon(Icons.support_agent),
                  title: Text(LocaleKeys.call_support.tr()),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.aboutUs);
                  },
                  leading: const Icon(Icons.info_outline),
                  title: Text(LocaleKeys.about_app.tr()),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.termsAndCondtions);
                  },
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(LocaleKeys.terms_and_conditions.tr()),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.policy);
                  },
                  leading: const Icon(Icons.policy_outlined),
                  title: Text(LocaleKeys.app_policy.tr()),
                ),
                BlocListener<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state.isLogedOut) {
                      context.pushNamedAndRemoveUntil(
                        AppRoutes.auth,
                        (_) => false,
                      );
                    }
                  },
                  child: ListTile(
                    onTap: () async {
                      await context.read<ProfileCubit>().logout();
                    },
                    leading: const Icon(Icons.logout),
                    title: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return state.loading
                            ? const CircularProgressIndicator.adaptive()
                            : Text(LocaleKeys.logout.tr());
                      },
                    ),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    final currentCode = context.locale.languageCode;
                    final nextCode = currentCode == 'ar' ? 'en' : 'ar';
                    await context.read<ProfileCubit>().changeLanguage(
                      nextCode,
                      context,
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  leading: const Icon(Icons.language),
                  title: Text(LocaleKeys.language.tr()),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.locale.languageCode == 'ar' ? '🇸🇦' : '🇬🇧',
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        6.horizontalSpace,
                        Text(
                          context.locale.languageCode == 'ar'
                              ? 'العربية'
                              : 'English',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocListener<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state.isDeleted) {
                      context.pushNamedAndRemoveUntil(
                        AppRoutes.auth,
                        (_) => false,
                      );
                    }
                  },
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const DeleteAccountDialog();
                        },
                      );
                    },
                    leading: const Icon(
                      Icons.delete_forever_outlined,
                      color: AppColors.red,
                    ),
                    title: Text(
                      LocaleKeys.delete_account.tr(),
                      style: const TextStyle(color: AppColors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
