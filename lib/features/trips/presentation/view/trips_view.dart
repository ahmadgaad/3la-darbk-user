import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../data/model/city_model.dart';
import '../view_model/cities/cubit.dart';
import '../view_model/cities/state.dart';
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
            state.activeTrips
                .where(
                  (element) =>
                      state.startCity?.id == null &&
                              state.destenationCity?.id == null
                          ? true
                          : state.startCity?.id != null &&
                              state.destenationCity?.id != null
                          ? (element.cityFromId == state.startCity?.id &&
                              element.cityToId == state.destenationCity?.id)
                          : (element.cityFromId == state.startCity?.id ||
                              element.cityToId == state.destenationCity?.id),
                )
                .toList();
        return RefreshIndicator(
          onRefresh: () async {
            return await context.read<TripsCubit>().getActiveTrips();
          },
          child: CustomScrollView(
            slivers: [
              if (state.activeTrips.isEmpty)
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  sliver: const SliverToBoxAdapter(
                    child: Center(child: Text(AppStrings.noTrips)),
                  ),
                )
              else ...{
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildFilters(context, state),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  sliver: SliverList.separated(
                    itemBuilder:
                        (BuildContext context, int index) =>
                            TripItem(trip: trips[index]),
                    separatorBuilder:
                        (BuildContext context, int index) =>
                            15.verticalSpaceFromWidth,
                    itemCount: trips.length,
                  ),
                ),
              },
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters(BuildContext context, TripsState state) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          AppStrings.searchCurrentTrips,
          style: AppTextStyle.font16black600,
        ),
      ),
      25.verticalSpaceFromWidth,
      Text(AppStrings.searchTripRoute, style: AppTextStyle.font14black500),
      15.verticalSpaceFromWidth,
      BlocBuilder<CitiesCubit, CitiesState>(
        builder: (context, citiesState) {
          return Row(
            spacing: 15.w,
            children: [
              Expanded(
                child: DropdownButtonFormField<CityModel>(
                  hint: const Text(AppStrings.startCity),
                  items:
                      citiesState.cities
                          .map<DropdownMenuItem<CityModel>>(
                            (e) => DropdownMenuItem<CityModel>(
                              value: e,
                              child: Text(e.name ?? ""),
                            ),
                          )
                          .toList(),
                  onChanged: (city) {
                    context.read<TripsCubit>().applyFilter(startCity: city);
                  },
                  initialValue: state.startCity,
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<CityModel>(
                  hint: const Text(AppStrings.destenationCity),
                  items:
                      citiesState.cities
                          .map<DropdownMenuItem<CityModel>>(
                            (e) => DropdownMenuItem<CityModel>(
                              value: e,
                              child: Text(e.name ?? ""),
                            ),
                          )
                          .toList(),
                  onChanged: (city) {
                    context.read<TripsCubit>().applyFilter(
                      destenationCity: city,
                    );
                  },
                  initialValue: state.destenationCity,
                ),
              ),
            ],
          );
        },
      ),
      15.verticalSpaceFromWidth,
      Row(
        spacing: 15.w,
        children: [
          // Expanded(
          //   child: DropdownButtonFormField<String>(
          //     hint: const Text(AppStrings.chooseDate),
          //     items: state.dates
          //         .map<DropdownMenuItem<String>>(
          //             (e) => DropdownMenuItem<String>(
          //                   value: e,
          //                   child: Text(e),
          //                 ))
          //         .toList(),
          //     onChanged: (date) {
          //       context.read<TripsCubit>().applyFilter(date: date);
          //     },
          //     value: state.date,
          //   ),
          // ),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.highlight_remove_outlined),
              onPressed: () {
                context.read<TripsCubit>().removeFilters();
              },
              label: const Text(AppStrings.clearSelection),
            ),
          ),
        ],
      ),
    ],
  );
}
