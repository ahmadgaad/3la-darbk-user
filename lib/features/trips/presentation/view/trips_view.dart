import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/shipments/presentation/view/components/shipment_card_shimmer.dart';
import 'package:ala_darbak_user/features/trips/presentation/view/components/custom_filter_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view_model/trips/trips_cubit.dart';
import '../view_model/trips/trips_states.dart';
import 'components/trip_item.dart';

class TripsView extends StatelessWidget {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsCubit, TripsState>(
      builder: (context, state) {
        final trips =
            state.activeTrips.where((element) {
              return state.startCity?.id == null &&
                      state.destenationCity?.id == null
                  ? true
                  : state.startCity?.id != null &&
                      state.destenationCity?.id != null
                  ? (element.cityFromId == state.startCity?.id &&
                      element.cityToId == state.destenationCity?.id)
                  : (element.cityFromId == state.startCity?.id ||
                      element.cityToId == state.destenationCity?.id);
            }).toList();
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<TripsCubit>().getActiveTrips();
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                sliver: SliverToBoxAdapter(
                  child: CustomFiltersWidget(state: state),
                ),
              ),
              if (trips.isEmpty && !state.loading && !state.error)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      LocaleKeys.no_trips.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              if (state.loading)
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  sliver: SliverList.separated(
                    itemBuilder: (_, __) => const ShipmentCardShimmer(),
                    separatorBuilder: (_, __) => 15.verticalSpaceFromWidth,
                    itemCount: 10,
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  sliver: SliverList.separated(
                    itemBuilder:
                        (context, index) => TripItem(trip: trips[index]),
                    separatorBuilder:
                        (context, index) => 15.verticalSpaceFromWidth,
                    itemCount: trips.length,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
