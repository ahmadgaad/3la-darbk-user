import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/dependency_injection/di.dart';
import '../manager/login_cubit/cubit.dart';
import '../manager/login_cubit/state.dart';
import '../manager/register_cubit/cubit.dart';
import '../manager/register_cubit/state.dart';
import 'login_view.dart';
import 'register_view.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterCubit(sl()),
        ),
        BlocProvider(
          create: (context) => LoginCubit(sl()),
        ),
      ],
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, loginState) {
            return BlocBuilder<RegisterCubit, RegisterState>(
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
                      children: [
                        LoginView(),
                        RegisterView(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
