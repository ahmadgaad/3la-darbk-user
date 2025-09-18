
class SettingsInfoModel {
    final int? id;
    final String? termsCondition;
    final String? privacyPolicy;
    final String? aboutUs;
    final String? callUs;
    final String? averageOrderPrice;
    final String? minOrderPrice;
    final String? maxOrderPrice;
    final String? averageTripPrice;
    final String? minTripPrice;
    final String? maxTripPrice;
    final String? tripPriceKilo;
    final String? orderPriceKilo;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    SettingsInfoModel({
        this.id,
        this.termsCondition,
        this.privacyPolicy,
        this.aboutUs,
        this.callUs,
        this.averageOrderPrice,
        this.minOrderPrice,
        this.maxOrderPrice,
        this.averageTripPrice,
        this.minTripPrice,
        this.maxTripPrice,
        this.tripPriceKilo,
        this.orderPriceKilo,
        this.createdAt,
        this.updatedAt,
    });

    SettingsInfoModel copyWith({
        int? id,
        String? termsCondition,
        String? privacyPolicy,
        String? aboutUs,
        String? callUs,
        String? averageOrderPrice,
        String? minOrderPrice,
        String? maxOrderPrice,
        String? averageTripPrice,
        String? minTripPrice,
        String? maxTripPrice,
        String? tripPriceKilo,
        String? orderPriceKilo,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        SettingsInfoModel(
            id: id ?? this.id,
            termsCondition: termsCondition ?? this.termsCondition,
            privacyPolicy: privacyPolicy ?? this.privacyPolicy,
            aboutUs: aboutUs ?? this.aboutUs,
            callUs: callUs ?? this.callUs,
            averageOrderPrice: averageOrderPrice ?? this.averageOrderPrice,
            minOrderPrice: minOrderPrice ?? this.minOrderPrice,
            maxOrderPrice: maxOrderPrice ?? this.maxOrderPrice,
            averageTripPrice: averageTripPrice ?? this.averageTripPrice,
            minTripPrice: minTripPrice ?? this.minTripPrice,
            maxTripPrice: maxTripPrice ?? this.maxTripPrice,
            tripPriceKilo: tripPriceKilo ?? this.tripPriceKilo,
            orderPriceKilo: orderPriceKilo ?? this.orderPriceKilo,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory SettingsInfoModel.fromJson(Map<String, dynamic> json) => SettingsInfoModel(
        id: json["id"],
        termsCondition: json["terms_condition"],
        privacyPolicy: json["privacy_policy"],
        aboutUs: json["about_us"],
        callUs: json["call_us"],
        averageOrderPrice: json["average_order_price"],
        minOrderPrice: json["min_order_price"],
        maxOrderPrice: json["max_order_price"],
        averageTripPrice: json["average_trip_price"],
        minTripPrice: json["min_trip_price"],
        maxTripPrice: json["max_trip_price"],
        tripPriceKilo: json["trip_price_kilo"],
        orderPriceKilo: json["order_price_kilo"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "terms_condition": termsCondition,
        "privacy_policy": privacyPolicy,
        "about_us": aboutUs,
        "call_us": callUs,
        "average_order_price": averageOrderPrice,
        "min_order_price": minOrderPrice,
        "max_order_price": maxOrderPrice,
        "average_trip_price": averageTripPrice,
        "min_trip_price": minTripPrice,
        "max_trip_price": maxTripPrice,
        "trip_price_kilo": tripPriceKilo,
        "order_price_kilo": orderPriceKilo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
