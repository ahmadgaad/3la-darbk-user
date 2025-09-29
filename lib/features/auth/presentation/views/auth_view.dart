import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/utils/app_utils/app_strings.dart';
import '../view_model/login_cubit/cubit.dart';
import '../view_model/login_cubit/state.dart';
import '../view_model/register_cubit/register_cubit.dart';
import '../view_model/register_cubit/register_states.dart';
import 'login_view.dart';
import 'register_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, loginState) {
          return BlocBuilder<RegisterCubit, RegisterState>(
            buildWhen:
                (previous, current) => previous.loading != current.loading,
            builder: (context, registerState) {
              return LoadingOverlay(
                isLoading: loginState.loading || registerState.loading,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 10,
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: AppStrings.login),
                        Tab(text: AppStrings.signUp),
                      ],
                    ),
                  ),
                  body: const TabBarView(
                    children: [LoginView(), RegisterView()],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
