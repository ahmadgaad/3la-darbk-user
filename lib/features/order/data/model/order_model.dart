// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:io';

import 'package:ala_darbak_user/features/trips/data/model/trip_model.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/heplers/file_utils.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../categories/repositories/models/category_model.dart';
import 'driver_model.dart';
import 'order_location_model.dart';

class OrderModel extends Equatable {
  final int? id;
  final String? numOrder;
  final int? status;
  final int? size;
  final String? paymentMethod;
  final int? isPaid;
  final String? pickupLat;
  final String? pickupLng;
  final String? pickupAddress;
  final String? deliveryLat;
  final String? deliveryLng;
  final String? deliveryAddress;
  final String distance;
  final String? price;
  final int? quantity;
  final List<String>? images;
  final List<File>? imagesFiles;
  final String? recipientName;
  final String? recipientMobile;
  final String? note;
  final int? driverId;
  final int? clientId;
  final int? categoryId;
  final dynamic tripId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DriverModel? driver;
  final UserModel? client;
  final CategoryModel? category;
  final OrderLocationModel? orderLocationModel;
  final TripModel? trip;

  const OrderModel({
    this.id,
    this.numOrder,
    this.imagesFiles,
    this.status,
    this.size,
    this.paymentMethod,
    this.orderLocationModel,
    this.isPaid,
    this.pickupLat,
    this.pickupLng,
    this.pickupAddress,
    this.deliveryLat,
    this.deliveryLng,
    this.deliveryAddress,
    required this.distance,
    this.price,
    this.quantity,
    this.images,
    this.recipientName,
    this.recipientMobile,
    this.note,
    this.driverId,
    this.clientId,
    this.categoryId,
    this.tripId,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.client,
    this.category,
    this.trip,
  });

  OrderModel copyWith({
    int? id,
    String? numOrder,
    int? status,
    int? size,
    String? paymentMethod,
    int? isPaid,
    String? pickupLat,
    String? pickupLng,
    String? pickupAddress,
    String? deliveryLat,
    String? deliveryLng,
    String? deliveryAddress,
    String? distance,
    String? price,
    int? quantity,
    List<String>? images,
    String? recipientName,
    String? recipientMobile,
    String? note,
    int? driverId,
    int? clientId,
    int? categoryId,
    dynamic tripId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DriverModel? driver,
    UserModel? client,
    CategoryModel? category,
    TripModel? trip,
    List<File>? imagesFiles,
    OrderLocationModel? orderLocationModel,
  }) => OrderModel(
    id: id ?? this.id,
    orderLocationModel: orderLocationModel ?? this.orderLocationModel,
    numOrder: numOrder ?? this.numOrder,
    status: status ?? this.status,
    size: size ?? this.size,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    isPaid: isPaid ?? this.isPaid,
    pickupLat: pickupLat ?? this.pickupLat,
    pickupLng: pickupLng ?? this.pickupLng,
    pickupAddress: pickupAddress ?? this.pickupAddress,
    deliveryLat: deliveryLat ?? this.deliveryLat,
    deliveryLng: deliveryLng ?? this.deliveryLng,
    deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    distance: distance ?? this.distance,
    price: price ?? this.price,
    quantity: quantity ?? this.quantity,
    images: images ?? this.images,
    recipientName: recipientName ?? this.recipientName,
    recipientMobile: recipientMobile ?? this.recipientMobile,
    note: note ?? this.note,
    driverId: driverId ?? this.driverId,
    clientId: clientId ?? this.clientId,
    categoryId: categoryId ?? this.categoryId,
    tripId: tripId ?? this.tripId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    driver: driver ?? this.driver,
    client: client ?? this.client,
    category: category ?? this.category,
    trip: trip ?? this.trip,
    imagesFiles: imagesFiles ?? this.imagesFiles,
  );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      numOrder: json["num_order"],
      status:
          json["status"] != null
              ? int.tryParse(json["status"].toString())
              : null,
      size: json["size"] != null ? int.tryParse(json["size"].toString()) : null,
      paymentMethod: json["payment_method"],
      isPaid: json["is_paid"],
      pickupLat: json["pickup_lat"],
      pickupLng: json["pickup_lng"],
      pickupAddress: json["pickup_address"],
      deliveryLat: json["delivery_lat"],
      deliveryLng: json["delivery_lng"],
      deliveryAddress: json["delivery_address"],
      orderLocationModel:
          json["pickup_lat"] != null &&
                  json["pickup_lng"] != null &&
                  json["delivery_lat"] != null &&
                  json["delivery_lng"] != null &&
                  json["distance"] != null
              ? OrderLocationModel(
                pickupAddress: json["pickup_address"],
                destinationAddress: json["delivery_address"],
                pickupLocation: LatLng(
                  double.parse(json["pickup_lat"]),
                  double.parse(json["pickup_lng"]),
                ),
                destinationLocation: LatLng(
                  double.parse(json["delivery_lat"]),
                  double.parse(json["delivery_lng"]),
                ),
                distance: double.parse(json["distance"]),
              )
              : null,
      distance: json["distance"] ?? "0",
      price: json["price"]?.toString(),
      quantity:
          json["quantity"] != null
              ? int.tryParse(json["quantity"].toString())
              : null,
      images:
          json["images"] == null
              ? []
              : List<String>.from(json["images"]!.map((x) => x)),
      recipientName: json["recipient_name"],
      recipientMobile: json["recipient_mobile"],
      note: json["note"],
      driverId: json["driver_id"],
      clientId: json["client_id"],
      categoryId:
          json["category_id"] != null
              ? int.tryParse(json["category_id"].toString())
              : null,
      tripId: json["trip_id"],
      createdAt:
          json["created_at"] == null
              ? null
              : DateTime.parse(json["created_at"]),
      updatedAt:
          json["updated_at"] == null
              ? null
              : DateTime.parse(json["updated_at"]),
      driver:
          json["driver"] == null ? null : DriverModel.fromJson(json["driver"]),
      client:
          json["client"] == null ? null : UserModel.fromJson(json["client"]),
      category:
          json["category"] == null
              ? null
              : CategoryModel.fromJson(json["category"]),
      trip: json["trip"] == null ? null : TripModel.fromJson(json["trip"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "size": size.toString(),
      "pickup_lat": pickupLat,
      "pickup_lng": pickupLng,
      "pickup_address": pickupAddress,
      "delivery_lat": deliveryLat,
      "delivery_lng": deliveryLng,
      "delivery_address": deliveryAddress,
      "distance": distance,
      if (price != null) "price": price,
      "quantity": quantity,
      if (imagesFiles != null)
        "images[]": List<dynamic>.from(
          imagesFiles!.map((x) => FileUtils.getMultiPartFile(x)),
        ),
      "recipient_name": recipientName,
      "recipient_mobile": recipientMobile,
      "note": note,
      "category_id": categoryId,
      "trip_id": tripId,

      // if (status != null) "status": status.toString(),
      // "payment_method": paymentMethod,
      // "is_paid": isPaid,
      // "driver_id": driverId,
      // "client_id": clientId,
    };
  }

  @override
  List<Object?> get props => [
    id,
    numOrder,
    status,
    size,
    paymentMethod,
    isPaid,
    pickupLat,
    pickupLng,
    pickupAddress,
    deliveryLat,
    deliveryLng,
    deliveryAddress,
    distance,
    price,
    quantity,
    images,
    recipientName,
    recipientMobile,
    note,
    driverId,
    clientId,
    categoryId,
    tripId,
    createdAt,
    updatedAt,
    driver,
    client,
    category,
    trip,
    imagesFiles,
    orderLocationModel,
  ];
}
