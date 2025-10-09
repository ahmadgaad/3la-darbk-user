import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/style/app_text_styles.dart';
import '../manager/cubit.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInfo = context.watch<SettingsInfoCubit>().state.settingsInfo;
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.app_policy.tr())),
      body:
          settingsInfo == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  return await context
                      .read<SettingsInfoCubit>()
                      .getSettingInfo();
                },
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Text(
                      settingsInfo.privacyPolicy ?? "",
                      style: AppTextStyle.font18black600.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
    );
  }
}
