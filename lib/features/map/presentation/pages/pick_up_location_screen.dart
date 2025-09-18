import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../config/style/app_color.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../db_injection.dart';
import '../manager/cubit.dart';
import '../manager/state.dart';
import '../widgets/pick_location_map.dart';

class PickLocationScreen extends StatelessWidget {
  final LatLng? initialLocation;
  final bool isDestination;
  const PickLocationScreen({super.key, this.initialLocation, required this.isDestination});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PickLocationCubit(sl())..init(initialLocation),
      child: BlocBuilder<PickLocationCubit, PickLocationState>(
        builder: (context, state) {
          final cubit= PickLocationCubit.get(context);
          return Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton.filled(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
              ),
            ),
            backgroundColor: Colors.black,
            body: const PickLocationMap(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                PickLocationCubit.get(context).getCurrentPosition();
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
                  left: 16.w, right: 16.w, top: 20.w, bottom: 10.w),
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
                      controller:
                          TextEditingController(text: state.address ?? ""),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded)),
                      readOnly: true,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary),
                        onPressed: () {
                          Navigator.pop(context,{"address":state.address,"location":cubit.currentPosition});
                        },
                        child: Text(isDestination?AppStrings.confirmDestinationLocation:AppStrings.confirmPickupLocation)),
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
