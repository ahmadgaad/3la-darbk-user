import 'package:ala_darbak_user/core/config/style/app_color.dart';
import 'package:ala_darbak_user/core/config/style/app_text_styles.dart';
import 'package:ala_darbak_user/core/heplers/location_helper.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/order/presentation/view_model/order_cubit/cubit.dart';
import 'package:ala_darbak_user/features/order/presentation/view_model/order_cubit/state.dart';
import 'package:ala_darbak_user/features/settings/presentation/manager/cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderConfirmationSheet extends StatefulWidget {
  final OrderState state;
  final ScrollController scrollController;
  const OrderConfirmationSheet(this.state, this.scrollController, {super.key});

  @override
  State<OrderConfirmationSheet> createState() => _OrderConfirmationSheetState();
}

class _OrderConfirmationSheetState extends State<OrderConfirmationSheet> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsInfoCubit>();
    final averageOrderPrice = cubit.state.settingsInfo?.averageOrderPrice;
    final averageTripPrice = cubit.state.settingsInfo?.averageTripPrice;

    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 10.w,
        bottom: 10.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20.w,
        children: [
          Center(
            child: Container(
              width: 50.w,
              height: 3,
              decoration: const BoxDecoration(color: AppColors.black),
            ),
          ),
          Text(
            LocaleKeys.order_price.tr(),
            style: AppTextStyle.font16black600,
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
              text:
                  widget.state.trip != null
                      ? averageTripPrice.toString()
                      : averageOrderPrice.toString(),
              style: AppTextStyle.font24primary600,
              children: <TextSpan>[
                TextSpan(
                  text: ' ${LocaleKeys.sar}',
                  style: AppTextStyle.font14black500,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            spacing: 15.w,
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                  ),
                  onPressed: () {
                    if (widget.state.loading) return;
                    context.read<OrderCubit>().createOrder(context);
                  },
                  child:
                      widget.state.loading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          )
                          : Text(LocaleKeys.confirm_order_and_search.tr()),
                ),
              ),
              IconButton(
                onPressed: () {
                  LocationHelper.launchDirections(
                    fromLocation:
                        widget.state.orderLocationModel.pickupLocation!,
                    toLocation:
                        widget.state.orderLocationModel.destinationLocation!,
                  );
                },
                icon: const Icon(
                  FontAwesomeIcons.mapLocationDot,
                  color: AppColors.primary,
                  size: 35,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(LocaleKeys.cancel),
          ),
        ],
      ),
    );
  }
}
