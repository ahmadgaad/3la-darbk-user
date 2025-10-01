import 'dart:io' show File;

import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/heplers/image_picker.dart';
import '../../../../categories/repositories/models/category_model.dart';
import '../../../../map/data/models/order_location_model.dart';
import '../../../../setttings_info/presentation/manager/cubit.dart'
    show SettingsInfoCubit;
import '../../../../trips/data/model/trip_model.dart';
import '../../../repositories/model/order_model.dart';
import '../../../repositories/repositories.dart';
import 'state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  OrderCubit(this._orderRepository)
    : super(
        OrderState(
          formKey: GlobalKey<FormState>(),
          unitsController: TextEditingController(),
          recipientMobileController: TextEditingController(),
          recipientNameController: TextEditingController(),
          additionalDetailsController: TextEditingController(),
        ),
      );

  reset() {
    emit(
      OrderState(
        formKey: GlobalKey<FormState>(),

        unitsController: TextEditingController(),
        recipientMobileController: TextEditingController(),
        recipientNameController: TextEditingController(),
        additionalDetailsController: TextEditingController(),
      ),
    );
  }

  payOrder() async {
    if (state.orderModel == null) return;
    (await _orderRepository.payOrder(
      state.orderModel?.id ?? 0,
    )).fold((l) => emit(state.copyWith(orderModel: l)), (r) => emit(state));
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

  createOrder(BuildContext context) async {
    if (state.loading) return;
    emit(state.copyWith(loading: true));
    final settingsCubit = context.read<SettingsInfoCubit>();

    final averageOrderPrice =
        settingsCubit.state.settingsInfo?.averageOrderPrice;
    final averageTripPrice = settingsCubit.state.settingsInfo?.averageTripPrice;
    final result = await _orderRepository.createOrder(
      OrderModel(
        tripId: state.trip?.id,
        categoryId: state.categoryModel?.id,
        size: state.orderSize,
        recipientName: state.recipientNameController.text,
        distance:
            state.orderLocationModel.distance == null
                ? "0"
                : state.orderLocationModel.distance.toString(),
        quantity: int.tryParse(state.unitsController.text) ?? 1,
        recipientMobile: state.recipientMobileController.text,
        note: state.additionalDetailsController.text,
        pickupLat: state.orderLocationModel.pickupLocation!.latitude.toString(),
        pickupLng:
            state.orderLocationModel.pickupLocation!.longitude.toString(),
        pickupAddress: state.orderLocationModel.pickupAddress,
        deliveryLat:
            state.orderLocationModel.destinationLocation!.latitude.toString(),
        deliveryLng:
            state.orderLocationModel.destinationLocation!.longitude.toString(),
        deliveryAddress: state.orderLocationModel.destinationAddress,
        price:
            state.trip != null
                ? averageTripPrice.toString()
                : averageOrderPrice.toString(),
        imagesFiles: state.images,
      ),
    );
    result.fold(
      (order) {
        emit(state.copyWith(loading: false, success: true, orderModel: order));
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.orderDetails,
          arguments: state.orderModel?.id,
          (route) => route.isFirst,
        );
      },
      (error) {
        emit(state.copyWith(loading: false, success: false));
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

  getOrder(int orderId) async {
    final result = await _orderRepository.getOrder(orderId);
    result.fold(
      (order) => emit(
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
          additionalDetailsController: TextEditingController(text: order?.note),
          canceled: false,
        ),
      ),
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

  updateOrder() async {
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
      (order) => emit(
        state.copyWith(loading: false, success: true, orderModel: order),
      ),
      (error) => emit(state.copyWith(loading: false, success: false)),
    );
  }

  cancelOrder() async {
    if (state.orderModel == null) return;
    emit(state.copyWith(loading: true));
    final result = await _orderRepository.cancelOrder(
      state.orderModel?.id ?? 0,
    );
    result.fold(
      (order) => emit(
        state.copyWith(
          loading: false,
          success: true,
          orderModel: order,
          canceled: true,
        ),
      ),
      (error) =>
          emit(state.copyWith(loading: false, success: false, canceled: false)),
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
