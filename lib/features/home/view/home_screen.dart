import 'package:ala_darbak_user/features/home/components/custom_home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/style/app_theme.dart';
import '../../shipments/presentation/view/active_shipments_view.dart';
import '../../profile/presentation/manager/profile_cubit/cubit.dart';
import '../../trips/presentation/view/trips_view.dart';
import '../components/custom_drawer_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: homeTheme,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const CustomDrawerMenu(),
          appBar: CustomHomeAppBar(scaffoldKey: _scaffoldKey),
          body: const TabBarView(
            children: [ActiveShipmentsView(), TripsView()],
          ),
        ),
      ),
    );
  }
}
