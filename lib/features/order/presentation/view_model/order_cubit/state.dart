import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../categories/repositories/models/category_model.dart';
import '../../../../map/data/models/order_location_model.dart';
import '../../../../trips/data/model/trip_model.dart';
import '../../../data/model/order_model.dart';

class OrderState extends Equatable {
  final int orderSize;
  final TripModel? trip;

  final int selectedPaymentMethod;
  final CategoryModel? categoryModel;
  final OrderLocationModel orderLocationModel;
  final List<File> images;
  final TextEditingController unitsController;
  final TextEditingController recipientNameController;
  final TextEditingController recipientMobileController;
  final TextEditingController additionalDetailsController;
  final GlobalKey<FormState> formKey;
  final OrderModel? orderModel;
  final bool loading;
  final bool success;
  final bool canceled;
  final bool completed;

  const OrderState({
    this.trip,
    this.orderSize = 0,
    this.selectedPaymentMethod = 0,
    this.orderModel,
    this.categoryModel,
    this.orderLocationModel = const OrderLocationModel(),
    this.images = const [],
    required this.unitsController,
    required this.recipientNameController,
    required this.recipientMobileController,
    required this.additionalDetailsController,
    this.loading = false,
    this.success = false,
    this.canceled = false,
    this.completed = false,
    required this.formKey,
  });

  OrderState copyWith({
    int? orderSize,
    TripModel? trip,
    int? selectedPaymentMethod,
    CategoryModel? categoryModel,
    OrderLocationModel? orderLocationModel,
    List<File>? images,
    OrderModel? orderModel,
    bool? loading,
    TextEditingController? unitsController,
    TextEditingController? recipientNameController,
    TextEditingController? recipientMobileController,
    TextEditingController? additionalDetailsController,
    GlobalKey<FormState>? formKey,
    bool? success,
    bool? canceled,
    bool? completed,
  }) {
    return OrderState(
      formKey: formKey ?? this.formKey,
      trip: trip ?? this.trip,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      orderModel: orderModel ?? this.orderModel,
      orderSize: orderSize ?? this.orderSize,
      categoryModel: categoryModel ?? this.categoryModel,
      orderLocationModel: orderLocationModel ?? this.orderLocationModel,
      images: images ?? this.images,
      unitsController: unitsController ?? this.unitsController,
      recipientNameController:
          recipientNameController ?? this.recipientNameController,
      recipientMobileController:
          recipientMobileController ?? this.recipientMobileController,
      additionalDetailsController:
          additionalDetailsController ?? this.additionalDetailsController,
      loading: loading ?? this.loading,
      success: success ?? this.success,
      canceled: canceled ?? this.canceled,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [
    orderSize,
    selectedPaymentMethod,
    categoryModel,
    trip,
    orderLocationModel,
    images,
    unitsController,
    recipientNameController,
    recipientMobileController,
    additionalDetailsController,
    loading,
    orderModel,
    success,
    canceled,
    completed,
  ];
}
