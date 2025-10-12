import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/style/app_color.dart';
import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/services/payment/payment_dialog.dart';
import '../../../../core/widgets/app_image_view.dart';
import '../../../../core/widgets/app_toaster.dart';
import '../../../settings/presentation/manager/cubit.dart';
import '../../data/model/driver_model.dart';
import '../view_model/order_cubit/cubit.dart';
import '../view_model/order_cubit/state.dart';
import 'components/order_images.dart';
import 'components/order_locations.dart';
import 'components/order_track.dart';
import 'components/price_raise.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final List<String> sizes = [
    LocaleKeys.small.tr(),
    LocaleKeys.medium.tr(),
    LocaleKeys.large.tr(),
  ];
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final orderCubit = context.read<OrderCubit>();
    final settingsCubit = context.read<SettingsInfoCubit>();
    final averageOrderPrice =
        settingsCubit.state.settingsInfo?.averageOrderPrice;
    final minOrderPrice = settingsCubit.state.settingsInfo?.minOrderPrice;
    final maxOrderPrice = settingsCubit.state.settingsInfo?.maxOrderPrice;
    // final averageTripPrice = settingsCubit.state.settingsInfo?.averageTripPrice;
    // final minTripPrice = settingsCubit.state.settingsInfo?.minTripPrice;
    // final maxTripPrice = settingsCubit.state.settingsInfo?.maxTripPrice;

    return BlocConsumer<OrderCubit, OrderState>(
      builder: (context, state) {
        final status = state.orderModel?.status ?? 0;
        final isPaid = state.orderModel?.isPaid == 1;
        final isPerson = (state.orderModel?.category?.isPerson ?? false);
        return state.orderModel == null
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
              appBar: AppBar(
                title: Text(
                  '${LocaleKeys.order_number.tr()} #${state.orderModel?.numOrder ?? ""}',
                ),
                centerTitle: true,
                actions:
                    status != 0
                        ? null
                        : [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.orderEdit);
                            },
                            icon: const Icon(FontAwesomeIcons.penToSquare),
                          ),
                        ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  return await orderCubit.getOrder(widget.orderId);
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20),
                  cacheExtent: 20,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: OrderTrack(status: status),
                    ),
                    10.verticalSpaceFromWidth,
                    if (state.orderModel?.driver != null) ...{
                      const Divider(),
                      10.verticalSpaceFromWidth,
                      _captainDataBuilder(state.orderModel?.driver),
                      10.verticalSpaceFromWidth,
                    },
                    const Divider(),
                    OrderLocations(
                      orderLocationModel: state.orderModel?.orderLocationModel,
                    ),
                    const Divider(),
                    if (state.orderModel?.trip != null) ...{
                      10.verticalSpaceFromWidth,
                      _textBuilder(
                        LocaleKeys.trip_number.tr(),
                        '#${state.orderModel?.trip?.numTrip ?? ""}',
                      ),
                      10.verticalSpaceFromWidth,
                      _textBuilder(
                        LocaleKeys.start_city.tr(),
                        state.orderModel?.trip?.cityFrom?.name ?? "",
                      ),
                      10.verticalSpaceFromWidth,
                      _textBuilder(
                        LocaleKeys.destination_city.tr(),
                        state.orderModel?.trip?.cityTo?.name ?? "",
                      ),
                      10.verticalSpaceFromWidth,
                      const Divider(),
                    },
                    10.verticalSpaceFromWidth,
                    _textBuilder(
                      LocaleKeys.order_category.tr(),
                      state.orderModel?.category?.name ?? "",
                    ),
                    10.verticalSpaceFromWidth,
                    if (!isPerson) ...[
                      const Divider(),
                      _textBuilder(
                        LocaleKeys.order_size.tr(),
                        sizes[state.orderModel?.size ?? 0],
                      ),
                      const Divider(),
                      _textBuilder(
                        LocaleKeys.units_number.tr(),
                        '${state.orderModel?.quantity ?? 1}',
                      ),
                    ],
                    const Divider(),
                    _textBuilder(
                      LocaleKeys.order_price.tr(),
                      '${state.orderModel?.price ?? "0"} ${LocaleKeys.sar}',
                    ),
                    const Divider(),
                    10.verticalSpaceFromWidth,
                    Row(
                      spacing: 5.w,
                      children: [
                        _textBuilder(
                          LocaleKeys.pay_method.tr(),
                          state.orderModel?.paymentMethod == "0"
                              ? LocaleKeys.cash
                              : LocaleKeys.online,
                        ),
                        Text(
                          isPaid ? LocaleKeys.paid : LocaleKeys.not_paid.tr(),
                          style: AppTextStyle.font14black500,
                        ),
                      ],
                    ),
                    if (status == 0) ...{
                      10.verticalSpaceFromWidth,
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16.sp,
                            color: AppColors.secondary,
                          ),
                          5.horizontalSpace,
                          Text(
                            LocaleKeys.you_can_pay_when_driver_accept_order
                                .tr(),
                            style: AppTextStyle.font14black500,
                          ),
                        ],
                      ),
                    },
                    10.verticalSpaceFromWidth,
                    if ((state.orderModel?.images ?? []).isNotEmpty) ...{
                      const Divider(),
                      10.verticalSpaceFromWidth,
                      OrderImages(images: state.orderModel?.images ?? []),
                      10.verticalSpaceFromWidth,
                    },
                    const Divider(),
                    10.verticalSpaceFromWidth,
                    _textBuilder(
                      LocaleKeys.additional_details.tr(),
                      state.orderModel?.note ?? "",
                    ),
                    if (!isPerson) ...{
                      10.verticalSpaceFromWidth,
                      const Divider(),
                      10.verticalSpaceFromWidth,
                      _buildRecipientInfo(state),
                    },
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20.w,
                  children: [
                    if (status == 0)
                      PriceRaise(
                        historicalAverage:
                            double.tryParse(averageOrderPrice ?? "0") ?? 0,
                        marketMin: double.tryParse(minOrderPrice ?? "0") ?? 0,
                        marketMax: double.tryParse(maxOrderPrice ?? "0") ?? 0,
                      ),
                    if (status > 0 && status < 3 && !isPaid)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<int>(
                            title: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.moneyBill1,
                                  color: Colors.lightGreen,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  LocaleKeys.cash.tr(),
                                  style: AppTextStyle.font14black600,
                                ),
                              ],
                            ),
                            value: 0,
                            groupValue: state.selectedPaymentMethod,
                            onChanged: (value) {
                              context.read<OrderCubit>().selectPaymentMethod(
                                value,
                                context,
                              );
                            },
                          ),
                          RadioListTile<int>(
                            title: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.creditCard,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    LocaleKeys.online.tr(),
                                    style: AppTextStyle.font14black600,
                                  ),
                                ),
                                if (state.selectedPaymentMethod == 1)
                                  TextButton(
                                    onPressed: () {
                                      Payment.pay(
                                        context,
                                        num.tryParse(
                                          orderCubit.state.orderModel?.price ??
                                              "0",
                                        ),
                                      ).then((value) {
                                        if (value is bool) {
                                          if (value) {
                                            print("Payment Success");
                                            orderCubit.payOrder();
                                            AppToaster.show(
                                              "Payment Success",
                                              isError: false,
                                            );
                                          } else {
                                            print("Payment Failed");
                                            AppToaster.show("Payment Failed");
                                          }
                                        }
                                      });
                                    },
                                    child: Text(LocaleKeys.pay_now.tr()),
                                  ),
                              ],
                            ),
                            value: 1,

                            groupValue: state.selectedPaymentMethod,
                            onChanged: (value) {
                              context.read<OrderCubit>().selectPaymentMethod(
                                value,
                                context,
                              );
                            },
                          ),
                        ],
                      ),
                    if (status <= 1)
                      ElevatedButton(
                        onPressed: orderCubit.cancelOrder,
                        child:
                            state.loading
                                ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                  ),
                                )
                                : Text(LocaleKeys.cancel.tr()),
                      ),

                    // // Show "Back to Home" button when order is delivered
                    // if (status == 3)
                    //   ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pushNamedAndRemoveUntil(
                    //         context,
                    //         AppRoutes.home,
                    //         (route) => false,
                    //       );
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: AppColors.primary,
                    //     ),
                    //     child: Text(
                    //       "العودة إلى ${LocaleKeys.home.tr()}",
                    //       style: const TextStyle(color: Colors.white),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            );
      },
      listener: (BuildContext context, OrderState state) {
        if (state.canceled) {
          AppToaster.show(LocaleKeys.order_canceled.tr());
        }

        // Navigate back to home when order is completed (delivered)
        if (state.completed) {
          AppToaster.show(LocaleKeys.order_delivered.tr(), isError: false);

          // Navigate back to home screen with all navigation stack cleared
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        }
      },
    );
  }

  Widget _textBuilder(String title, String value) => RichText(
    text: TextSpan(
      text: "$title :",
      style: AppTextStyle.font14black600,
      children: [
        TextSpan(
          text: '  $value',
          style: AppTextStyle.font16primary600.copyWith(height: 1.5),
        ),
      ],
    ),
  );

  Widget _buildRecipientInfo(OrderState state) {
    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${LocaleKeys.recipient_info.tr()} ",
          style: AppTextStyle.font14black600,
        ),
        RichText(
          text: TextSpan(
            text: "${LocaleKeys.name.tr()} :",
            style: AppTextStyle.font14black600,
            children: [
              TextSpan(
                text: '  ${state.orderModel?.recipientName ?? ""}',
                style: AppTextStyle.font16primary600,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            final url = "tel:+966${state.orderModel?.recipientMobile ?? "0"}";
            if (await launchUrl(Uri.parse(url))) {}
          },
          child: RichText(
            text: TextSpan(
              text: "${LocaleKeys.phone_number.tr()} :",
              style: AppTextStyle.font14black600,
              children: [
                TextSpan(
                  text: '  +966${state.orderModel?.recipientMobile ?? "0"}',
                  style: AppTextStyle.font16primary600.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _captainDataBuilder(DriverModel? driverModel) => Column(
    spacing: 15.w,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "${LocaleKeys.captain_info.tr()} :",
        style: AppTextStyle.font14black600,
      ),
      Row(
        spacing: 15.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImageView(
            width: 80.w,
            height: 80.w,
            onTap: () async {
              if (await launchUrl(Uri.parse(driverModel?.image ?? "none"))) {}
            },
            shape: BoxShape.circle,
            fit: BoxFit.cover,
            url: driverModel?.image ?? "none",
          ),
          Expanded(
            child: Column(
              spacing: 5.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverModel?.name ?? "",
                  style: AppTextStyle.font16black600,
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  itemSize: 20,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder:
                      (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {},
                ),
                InkWell(
                  onTap: () async {
                    final url = "tel:+966${driverModel?.mobile}";
                    if (await launchUrl(Uri.parse(url))) {}
                  },
                  child: Text(
                    "+966${driverModel?.mobile}",
                    // textDirection: TextDirection.ltr,
                    style: AppTextStyle.font14black600.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              spacing: 10.w,
              children: [
                AppImageView(
                  width: 60.w,
                  height: 60.w,
                  onTap: () async {
                    if (await launchUrl(
                      Uri.parse(driverModel?.imageCar ?? ""),
                    )) {}
                  },
                  shape: BoxShape.circle,
                  fit: BoxFit.contain,
                  url: driverModel?.imageCar ?? "",
                ),
                Text(
                  "${driverModel?.typeCar ?? ""}  ${driverModel?.categoryCar ?? ""}  ${driverModel?.yearManufacture ?? ""}",
                  style: AppTextStyle.font14black600.copyWith(height: 1.2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${driverModel?.platesString ?? ""} ${driverModel?.platesNumber ?? ""}',
                  style: AppTextStyle.font14primary600,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
