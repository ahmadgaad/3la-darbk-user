import 'dart:io';

import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/extensions/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/app_toaster.dart';
import 'components/additional_details_field.dart';
import 'components/order_images_add.dart';
import 'components/order_size_select.dart';
import 'components/recipient_info_form.dart';
import 'components/units_field.dart';
import '../view_model/order_cubit/cubit.dart';
import '../view_model/order_cubit/state.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      /// The first time a map is shown,
      /// the Google Maps SDK may briefly block the main thread,
      /// which could cause UI jank.
      /// If you prefer to control when this happens,
      GoogleMapsFlutterAndroid().warmup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        final cubit = context.read<OrderCubit>();
        // final categoryModel = state.categoryModel;
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.orderDescripetion),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Form(
              key: state.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderSizeSelect(
                    onSizeTap: (int selectedSize) {
                      cubit.onSelectOrderSize(selectedSize);
                    },
                    selectedSize: state.orderSize,
                  ),
                  25.verticalSpaceFromWidth,
                  UnitsField(controller: state.unitsController),
                  25.verticalSpaceFromWidth,
                  OrderImagesAdd(
                    onAddTap: () {
                      cubit.pickImages();
                    },
                    images: state.images,
                    onImageRemoveTap: (image) {
                      cubit.removeImage(image);
                    },
                  ),
                  25.verticalSpaceFromWidth,
                  RecipientInfoForm(
                    nameController: state.recipientNameController,
                    phoneController: state.recipientMobileController,
                  ),
                  25.verticalSpaceFromWidth,
                  AdditionalDetailsField(
                    controller: state.additionalDetailsController,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 16.h,
              bottom: 30.h,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final imagesValid =
                      state.images.length >= 3 && state.images.length <= 5;

                  if ((state.formKey.currentState?.validate() ?? false) &&
                      imagesValid) {
                    context.pushNamed(AppRoutes.pickLocation);
                  } else if (!imagesValid) {
                    AppToaster.show(AppStrings.mustEnterImagesBeteween3And5);
                    return;
                  }
                },
                child: const Text(AppStrings.confirm),
              ),
            ),
          ),
        );
      },
    );
  }
}
