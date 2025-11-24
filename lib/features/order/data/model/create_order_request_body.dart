import 'dart:io';

import 'package:ala_darbak_user/core/heplers/file_utils.dart';
import 'package:equatable/equatable.dart';

class CreateOrderRequestBody extends Equatable {
  final int? tripId;
  final int size;
  final String pickupLat;
  final String pickupLng;
  final String pickupAddress;
  final String deliveryLat;
  final String deliveryLng;
  final String deliveryAddress;
  final String? distance;
  final String price;
  final int quantity;
  final List<File>? imagesFiles;
  final String? recipientName;
  final String? recipientMobile;
  final String? note;
  final int categoryId;

  const CreateOrderRequestBody({
    required this.tripId,
    required this.size,
    required this.pickupLat,
    required this.pickupLng,
    required this.pickupAddress,
    required this.deliveryLat,
    required this.deliveryLng,
    required this.deliveryAddress,
    required this.distance,
    required this.price,
    required this.quantity,
    required this.imagesFiles,
    required this.recipientName,
    required this.recipientMobile,
    required this.note,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (tripId != null) "trip_id": tripId,
      "size": size,
      "pickup_lat": pickupLat,
      "pickup_lng": pickupLng,
      "pickup_address": pickupAddress,
      "delivery_lat": deliveryLat,
      "delivery_lng": deliveryLng,
      "delivery_address": deliveryAddress,
      if (distance != null) "distance": distance,
      "price": price,
      "quantity": quantity,
      if (imagesFiles != null)
        "images[]": List<dynamic>.from(
          imagesFiles!.map((image) => FileUtils.getMultiPartFile(image)),
        ),
      if (recipientName != null) "recipient_name": recipientName,
      if (recipientMobile != null) "recipient_mobile": recipientMobile,
      if (note != null) "note": note,
      "category_id": categoryId,
    };
  }

  @override
  List<Object?> get props => [
    tripId,
    size,
    pickupLat,
    pickupLng,
    pickupAddress,
    deliveryLat,
    deliveryLng,
    deliveryAddress,
    distance,
    price,
    quantity,
    imagesFiles,
    recipientName,
    recipientMobile,
    note,
    categoryId,
  ];
}
