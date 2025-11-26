import 'dart:io' show File;

import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/heplers/location_helper.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/core/widgets/app_toaster.dart';
import 'package:ala_darbak_user/features/order/data/model/create_order_request_body.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/heplers/image_picker.dart';
import '../../../../categories/repositories/models/category_model.dart';
import '../../../../settings/presentation/manager/cubit.dart'
    show SettingsInfoCubit;
import '../../../../trips/data/model/trip_model.dart';
import '../../../data/model/order_location_model.dart';
import '../../../data/model/order_model.dart';
import '../../../data/repository/order_repository.dart';
import 'order_states.dart';

class OrderCubit extends Cubit<OrderStates> {
  final OrderRepository _orderRepository;
  OrderCubit(this._orderRepository)
    : super(
        OrderStates(
          formKey: GlobalKey<FormState>(),
          unitsController: TextEditingController(),
          recipientMobileController: TextEditingController(),
          recipientNameController: TextEditingController(),
          additionalDetailsController: TextEditingController(),
        ),
      );

  reset() {
    emit(
      OrderStates(
        formKey: GlobalKey<FormState>(),

        unitsController: TextEditingController(),
        recipientMobileController: TextEditingController(),
        recipientNameController: TextEditingController(),
        additionalDetailsController: TextEditingController(),
      ),
    );
  }

  resetOrderCreatedFlag() {
    emit(state.copyWith(orderCreated: false));
  }

  Future<void> payOrder() async {
    if (state.orderModel == null) return;
    final result = await _orderRepository.payOrder(state.orderModel?.id ?? 0);
    result.fold(
      (l) {
        emit(state.copyWith(orderModel: l));
      },
      (r) {
        AppToaster.show(r.message, isError: true);
      },
    );
  }

  setTrip(TripModel? tripModel) {
    emit(state.copyWith(trip: tripModel));
  }

  setCategory({required CategoryModel? categoryModel}) {
    emit(state.copyWith(categoryModel: categoryModel));
  }

  setOrderlocation({required OrderLocationModel orderLocationModel}) {
    emit(state.copyWith(orderLocationModel: orderLocationModel));
  }

  onSelectOrderSize(orderSize) {
    emit(state.copyWith(orderSize: orderSize));
  }

  selectPaymentMethod(selectedPaymentMethod, context) {
    emit(state.copyWith(selectedPaymentMethod: selectedPaymentMethod));
    updateOrder();
  }

  pickImages() async {
    final images = await ImagePickerUtils.getImageList();
    if (images.isNotEmpty) {
      emit(state.copyWith(images: images));
    }
  }

  removeImage(File image) {
    final updatedImages = List<File>.from(state.images)
      ..removeWhere((img) => img.path == image.path);
    emit(state.copyWith(images: updatedImages));
  }

  /// Creates an order based on the current state and navigates to the order details screen upon success.
  Future<void> createOrder(BuildContext context) async {
    if (state.loading) return;
    emit(state.copyWith(loading: true));
    final settingsCubit = context.read<SettingsInfoCubit>();

    final averageOrderPrice =
        settingsCubit.state.settingsInfo?.averageOrderPrice;
    final averageTripPrice = settingsCubit.state.settingsInfo?.averageTripPrice;
    final pickupLocation = state.orderLocationModel.pickupLocation!;
    final destinationLocation = state.orderLocationModel.destinationLocation!;
    final distance = LocationHelper.calculateDistance(
      fromLocation: pickupLocation,
      toLocation: destinationLocation,
    );
    final result = await _orderRepository.createOrder(
      body: CreateOrderRequestBody(
        tripId: state.trip?.id,
        categoryId: state.categoryModel?.id ?? 0,
        size: state.orderSize,
        recipientName:
            state.recipientNameController.text.isEmpty
                ? null
                : state.recipientNameController.text.trim(),
        distance: distance.toString(),
        quantity: int.tryParse(state.unitsController.text) ?? 1,
        recipientMobile:
            state.recipientMobileController.text.isEmpty
                ? null
                : state.recipientMobileController.text,
        note:
            state.additionalDetailsController.text.isEmpty
                ? null
                : state.additionalDetailsController.text.trim(),
        pickupLat: state.orderLocationModel.pickupLocation!.latitude.toString(),
        pickupLng:
            state.orderLocationModel.pickupLocation!.longitude.toString(),
        pickupAddress: state.orderLocationModel.pickupAddress!,
        deliveryLat:
            state.orderLocationModel.destinationLocation!.latitude.toString(),
        deliveryLng:
            state.orderLocationModel.destinationLocation!.longitude.toString(),
        deliveryAddress: state.orderLocationModel.destinationAddress!,
        price:
            state.trip != null
                ? averageTripPrice.toString()
                : averageOrderPrice.toString(),
        imagesFiles: state.images,
      ),
    );
    result.fold(
      (error) {
        emit(state.copyWith(loading: false, success: false));
      },
      (createdOrder) {
        emit(
          state.copyWith(
            loading: false,
            success: true,
            orderModel: createdOrder,
            orderCreated: true,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.orderDetails,
          arguments: createdOrder.id,
          (route) => route.isFirst,
        );
      },
    );
  }

  setOrderModel(OrderModel order) {
    emit(
      state.copyWith(
        orderModel: order,
        formKey: GlobalKey<FormState>(),
        recipientMobileController: TextEditingController(
          text: order.recipientMobile,
        ),
        recipientNameController: TextEditingController(
          text: order.recipientName,
        ),
        additionalDetailsController: TextEditingController(text: order.note),
        canceled: false,
      ),
    );
  }

  Future<void> getOrder(int orderId) async {
    final result = await _orderRepository.getOrder(orderId);
    result.fold(
      (order) {
        // Check if order just got completed (status = 3 = delivered)
        final wasNotCompleted = state.orderModel?.status != 3;
        final isNowCompleted = order?.status == 3;
        final justCompleted = wasNotCompleted && isNowCompleted;

        emit(
          state.copyWith(
            loading: false,
            success: true,
            orderModel: order,
            formKey: GlobalKey<FormState>(),
            selectedPaymentMethod: int.tryParse(order?.paymentMethod ?? "0"),
            recipientMobileController: TextEditingController(
              text: order?.recipientMobile,
            ),
            recipientNameController: TextEditingController(
              text: order?.recipientName,
            ),
            additionalDetailsController: TextEditingController(
              text: order?.note,
            ),
            canceled: false,
            completed: justCompleted,
          ),
        );
      },
      (error) =>
          emit(state.copyWith(loading: false, success: false, canceled: false)),
    );
  }

  raisePrice(String? price) async {
    if (state.orderModel == null) return;
    final result = await _orderRepository.raisePrice(
      state.orderModel!.copyWith(price: price),
    );
    result.fold(
      (order) => emit(state.copyWith(orderModel: order)),
      (error) => emit(state.copyWith()),
    );
  }

  Future<void> updateOrder() async {
    if (state.orderModel == null) return;
    if (!(state.formKey.currentState?.validate() ?? true)) return;
    emit(state.copyWith(loading: true));
    final result = await _orderRepository.updateOrder(
      state.orderModel!.copyWith(
        recipientName: state.recipientNameController.text,
        recipientMobile: state.recipientMobileController.text,
        note: state.additionalDetailsController.text,
        paymentMethod: state.selectedPaymentMethod.toString(),
      ),
    );
    result.fold(
      (order) {
        emit(state.copyWith(loading: false, success: true, orderModel: order));
        AppToaster.show(LocaleKeys.updated_successfully.tr(), isError: false);
      },
      (error) {
        emit(state.copyWith(loading: false, success: false));
        AppToaster.show(error.message, isError: true);
      },
    );
  }

  Future<void> cancelOrder() async {
    if (state.orderModel == null) return;
    emit(state.copyWith(loading: true));
    final result = await _orderRepository.cancelOrder(
      state.orderModel?.id ?? 0,
    );
    result.fold(
      (order) {
        emit(
          state.copyWith(
            loading: false,
            success: true,
            orderModel: order,
            canceled: true,
          ),
        );
      },
      (error) {
        emit(state.copyWith(loading: false, success: false, canceled: false));
      },
    );
  }

  @override
  Future<void> close() {
    state.unitsController.dispose();
    state.recipientNameController.dispose();
    state.recipientMobileController.dispose();
    state.additionalDetailsController.dispose();
    return super.close();
  }
}
