import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/config/style/app_color.dart';
import '../../../../core/utils/app_strings.dart';
import '../manager/order_cubit/cubit.dart';
import '../manager/order_cubit/state.dart';
import '../components/additional_details_field.dart';
import '../components/recipient_info_form.dart';

class OrderEditScreen extends StatelessWidget {
  const OrderEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        final cubit = context.read<OrderCubit>();
        final isPerson = (state.orderModel?.category?.isPerson ?? false);

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.orderEdit),
            centerTitle: true,
          ),
          body: ListView(
            cacheExtent: 20,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            children: [
              // OrderSizeSelect(
              //   onSizeTap: (int selectedSize) {
              //     cubit.selectOrderSize(selectedSize);
              //   },
              //   selectedSize: cubit.orderSize,
              // ),
              // 25.verticalSpaceFromWidth,
              // UnitsField(),
              // 25.verticalSpaceFromWidth,
              // OrderImagesAdd(
              //   onAddTap: () {
              //     cubit.pickImages();
              //   },
              //   images: state.images,
              //   onImageRemoveTap: (int index) {
              //     cubit.removeImage(index);
              //   },
              // ),
              // 25.verticalSpaceFromWidth,
              if(!isPerson)
              Form(
                key: state.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: RecipientInfoForm(
                  nameController: state.recipientNameController,
                  phoneController: state.recipientMobileController,
                ),
              ),
              25.verticalSpaceFromWidth,
              AdditionalDetailsField(
                controller: state.additionalDetailsController,
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, top: 16.h, bottom: 30.h),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed:state.loading? null: cubit.updateOrder,
                    child:state.loading? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    ): const Text(AppStrings.confirm))),
          ),
        );
      },
    );
  }
}
