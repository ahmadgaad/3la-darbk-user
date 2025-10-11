import 'package:ala_darbak_user/core/config/style/app_color.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum ShipmentStatus { pending, accepted, picked, delivered, canceled }

extension ShipmentStatusX on ShipmentStatus {
  Color get color {
    switch (this) {
      case ShipmentStatus.pending:
        return AppColors.pending;
      case ShipmentStatus.accepted:
        return AppColors.accepted;
      case ShipmentStatus.picked:
        return AppColors.picked;
      case ShipmentStatus.delivered:
        return AppColors.delivered;
      case ShipmentStatus.canceled:
        return AppColors.canceled;
    }
  }

  String get label {
    switch (this) {
      case ShipmentStatus.pending:
        return LocaleKeys.pending.tr();
      case ShipmentStatus.accepted:
        return LocaleKeys.accepted.tr();
      case ShipmentStatus.picked:
        return LocaleKeys.picked.tr();
      case ShipmentStatus.delivered:
        return LocaleKeys.delivered.tr();
      case ShipmentStatus.canceled:
        return LocaleKeys.canceled.tr();
    }
  }

  static ShipmentStatus fromInt(int value) {
    switch (value) {
      case 0:
        return ShipmentStatus.pending;
      case 1:
        return ShipmentStatus.accepted;
      case 2:
        return ShipmentStatus.picked;
      case 3:
        return ShipmentStatus.delivered;
      case 4:
        return ShipmentStatus.canceled;
      default:
        return ShipmentStatus.pending;
    }
  }
}
