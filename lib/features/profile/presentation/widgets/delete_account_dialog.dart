import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/profile_cubit/cubit.dart';
import '../manager/profile_cubit/state.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.delete_account_title.tr()),
      content: Text(LocaleKeys.delete_account_content.tr()),
      actions: <Widget>[
        TextButton(
          child: Text(LocaleKeys.cancel.tr()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.loading) {
              return const CircularProgressIndicator();
            }
            return TextButton(
              onPressed: context.read<ProfileCubit>().delete,
              child: Text(LocaleKeys.confirm.tr()),
            );
          },
        ),
      ],
    );
  }
}
