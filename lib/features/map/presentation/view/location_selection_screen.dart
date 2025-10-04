import 'package:ala_darbak_user/core/extensions/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/config/style/app_color.dart';
import '../../../../core/dependency_injection/di.dart';
import '../../../../core/utils/app_strings.dart';
import '../view_model/map_cubit.dart';
import '../view_model/map_states.dart';
import 'components/map_location_selector.dart';

class LocationSelectionScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final bool isDestination;
  const LocationSelectionScreen({
    super.key,
    this.initialLocation,
    required this.isDestination,
  });

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final cubit = MapCubit(sl());
        // Initialize the cubit properly (now async)
        cubit.init(widget.initialLocation);
        return cubit;
      },
      child: BlocBuilder<MapCubit, MapStates>(
        builder: (context, state) {
          final cubit = context.read<MapCubit>();

          return Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton.filled(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
              ),
            ),
            backgroundColor: Colors.black,
            body: const MapLocationSelectorWidget(),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await cubit.getCurrentPosition();
              },
              child: const Icon(Icons.my_location),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                color: AppColors.white,
              ),
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 20.w,
                bottom: 10.w,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20.w,
                  children: [
                    TextFormField(
                      onTap: () {
                        cubit.searchPlace(context);
                      },
                      controller: TextEditingController(
                        text: state.address ?? "",
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                      readOnly: true,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                      ),
                      onPressed: () {
                        Navigator.pop(context, {
                          "address": state.address,
                          "location": cubit.currentLatLng,
                        });
                      },
                      child: Text(
                        widget.isDestination
                            ? AppStrings.confirmDestinationLocation
                            : AppStrings.confirmPickupLocation,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
