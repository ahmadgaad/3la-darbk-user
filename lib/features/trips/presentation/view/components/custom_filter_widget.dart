import 'package:ala_darbak_user/core/config/style/app_text_styles.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/trips/data/model/city_model.dart';
import 'package:ala_darbak_user/features/trips/presentation/view_model/cities/cubit.dart';
import 'package:ala_darbak_user/features/trips/presentation/view_model/cities/state.dart';
import 'package:ala_darbak_user/features/trips/presentation/view_model/trips/trips_cubit.dart';
import 'package:ala_darbak_user/features/trips/presentation/view_model/trips/trips_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFiltersWidget extends StatelessWidget {
  final TripsState state;
  const CustomFiltersWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            LocaleKeys.search_current_trips.tr(),
            style: AppTextStyle.font16black600,
          ),
        ),
        25.verticalSpace,
        Text(
          LocaleKeys.search_trip_route.tr(),
          style: AppTextStyle.font14black500,
        ),
        15.verticalSpace,
        BlocBuilder<CitiesCubit, CitiesState>(
          builder: (context, citiesState) {
            return Row(
              spacing: 15.w,
              children: [
                Expanded(
                  child: DropdownButtonFormField<CityModel>(
                    hint: Text(LocaleKeys.start_city.tr()),
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
                    hint: Text(LocaleKeys.destination_city.tr()),
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
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.highlight_remove_outlined),
                onPressed: () {
                  context.read<TripsCubit>().removeFilters();
                },
                label: Text(LocaleKeys.clear_selection.tr()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
