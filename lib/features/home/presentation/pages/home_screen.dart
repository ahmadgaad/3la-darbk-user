import 'package:ala_darbak_user/features/notifications/presentation/manager/notifications_cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/style/app_theme.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../notifications/presentation/manager/notifications_cubit/state.dart';
import '../../../profile/presentation/manager/profile_cubit/cubit.dart';
import '../widgets/drawer_widget.dart';
import '../../../orders/presentation/pages/active_orders_view.dart';
import '../../../trips/presentation/pages/trips_view.dart';

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
          drawer: const DrawerWidget(),
          appBar: _buildAppBar(),
          body: const TabBarView(children: [ActiveOrdersView(), TripsView()]),
        ),
      ),
    );
  }

  _buildAppBar() => AppBar(
    leading: IconButton(
      onPressed: () {
        _scaffoldKey.currentState!.openDrawer();
      },
      icon: const Icon(Icons.menu),
    ),
    title: Row(
      spacing: 20.w,
      children: [
        IconButton(
          icon: BlocBuilder<NotificationsCubit, NotificationsState>(
           
            builder: (context, state) {
              return Badge.count(
                count: state.notifications.where((x) => x.isRead==0).length,
                child: const Icon(Icons.notifications),
              );
            },
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.notifications, arguments: context.read<NotificationsCubit>());
          },
        ),
        const Text(AppStrings.home),
      ],
    ),
    bottom: const TabBar(
      tabs: [Tab(text: AppStrings.myOrders), Tab(text: AppStrings.trips)],
    ),
  );
}
