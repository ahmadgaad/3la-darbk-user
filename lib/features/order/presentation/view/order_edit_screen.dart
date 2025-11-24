import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_color.dart';
import '../view_model/order_cubit/order_cubit.dart';
import '../view_model/order_cubit/order_states.dart';
import 'components/create_order_components/additional_details_field.dart';
import 'components/create_order_components/recipient_info_form.dart';

class OrderEditScreen extends StatelessWidget {
  const OrderEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderStates>(
      listener: (context, state) {
        if (state.success) {
          Future.delayed(const Duration(milliseconds: 650), () {
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.orderDetails,
                arguments: state.orderModel?.id ?? 0,
                (route) => route.isFirst,
              );
            }
          });
        }
      },
      builder: (context, state) {
        final cubit = context.read<OrderCubit>();
        final isPerson = (state.orderModel?.category?.isPerson ?? false);

        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.order_edit.tr()),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isPerson)
                  Form(
                    key: state.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: RecipientInfoForm(
                      nameController: state.recipientNameController,
                      phoneController: state.recipientMobileController,
                    ),
                  ),
                25.verticalSpace,
                AdditionalDetailsField(
                  controller: state.additionalDetailsController,
                ),
              ],
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
                onPressed: () async {
                  if (state.loading) return;
                  await cubit.updateOrder();
                },
                child:
                    state.loading
                        ? const CircularProgressIndicator(
                          color: AppColors.white,
                        )
                        : Text(LocaleKeys.confirm.tr()),
              ),
            ),
          ),
        );
      },
    );
  }
}
