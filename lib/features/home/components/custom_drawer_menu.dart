import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/extensions/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/style/app_color.dart';
import '../../../core/config/style/app_text_styles.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/app_image_view.dart';
import '../../profile/presentation/manager/profile_cubit/cubit.dart';
import '../../profile/presentation/manager/profile_cubit/state.dart';
import '../../profile/presentation/widgets/delete_account_dialog.dart';
import '../../setttings_info/presentation/manager/cubit.dart';
import '../../shipments/presentation/view_model/shipments_cubit.dart';

class CustomDrawerMenu extends StatelessWidget {
  const CustomDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300.w,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _drawerHeader(),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
            leading: const Icon(Icons.person_pin_rounded),
            title: const Text(AppStrings.profile2),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.changePassword);
            },
            leading: const Icon(Icons.lock_outline),
            title: const Text(AppStrings.changePassword),
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
            title: const Text(AppStrings.ordersHistory),
          ),
          ListTile(
            onTap: () async {
              final url =
                  "tel:${context.read<SettingsInfoCubit>().state.settingsInfo?.callUs ?? "0"}";
              if (await launchUrl(Uri.parse(url))) {}
            },
            leading: const Icon(Icons.support_agent),
            title: const Text(AppStrings.callSupport),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.aboutUs);
            },
            leading: const Icon(Icons.info_outline),
            title: const Text(AppStrings.aboutApp),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.termsAndCondtions);
            },
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text(AppStrings.termsAndCondtions),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.policy);
            },
            leading: const Icon(Icons.policy_outlined),
            title: const Text(AppStrings.appPolicy),
          ),
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state.isLogedOut) {
                context.pushNamedAndRemoveUntil(AppRoutes.auth, (_) => false);
              }
            },
            child: ListTile(
              onTap: () {
                context.read<ProfileCubit>().logout();
              },
              leading: const Icon(Icons.logout),
              title: const Text(AppStrings.logout),
            ),
          ),
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state.isDeleted) {
                context.pushNamedAndRemoveUntil(AppRoutes.auth, (_) => false);
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
              title: const Text(
                AppStrings.deleteAccount,
                style: TextStyle(color: AppColors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerHeader() => SizedBox(
    height: 175.w,
    child: DrawerHeader(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final user = state.currentUser;
          return Row(
            spacing: 10.w,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppImageView(
                width: 60.w,
                height: 60.w,
                fit: BoxFit.cover,
                shape: BoxShape.circle,
                url: user?.image ?? "asd",
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10.w,
                  children: [
                    Text(
                      user?.name ?? "user name",
                      style: AppTextStyle.font16white600,
                    ),
                    Text(
                      user?.mobile ?? "+966",
                      style: AppTextStyle.font14white600,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
