import 'package:flutter/material.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../manager/profile_cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/profile_cubit/state.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.deleteAccountTitle),
      content: const Text(AppStrings.deleteAccountContent),
      actions: <Widget>[
        TextButton(
          child: const Text(AppStrings.cancel),
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
              child: const Text(AppStrings.confirm),
            );
          },
        ),
      ],
    );
  }
} 