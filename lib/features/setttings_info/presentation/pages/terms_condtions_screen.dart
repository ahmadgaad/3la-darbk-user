import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../manager/cubit.dart';

class TermsCondtionsScreen extends StatelessWidget {
  const TermsCondtionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInfo = context.watch<SettingsInfoCubit>().state.settingsInfo;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.termsAndCondtions),
      ),
      body: settingsInfo == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
            onRefresh: () async{ 
              return await context.read<SettingsInfoCubit>().getSettingInfo();
             },
            child: ListView(
              padding: const EdgeInsets.all(10),
               physics: const AlwaysScrollableScrollPhysics(),
                children: [
                   Text(
                  settingsInfo.termsCondition ?? "",
                  style: AppTextStyle.font18black600.copyWith(height: 1.5),
                )
                ],
              ),
          ),
    );
  }
}
