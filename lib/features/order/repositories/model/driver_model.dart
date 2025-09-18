
class DriverModel {
    final int? id;
    final String? name;
    final String? image;
    final String? typeCar;
    final String? categoryCar;
    final String? yearManufacture;
    final String? platesNumber;
    final String? platesString;
    final String? imageCar;
    final String? mobile;

    DriverModel({
        this.id,
        this.name,
        this.image,
        this.typeCar,
        this.categoryCar,
        this.yearManufacture,
        this.platesNumber,
        this.platesString,
        this.imageCar,
        this.mobile,
    });

    DriverModel copyWith({
        int? id,
        String? name,
        String? image,
        String? typeCar,
        String? categoryCar,
        String? yearManufacture,
        String? platesNumber,
        String? platesString,
        String? imageCar,
        String? mobile,
    }) => 
        DriverModel(
            id: id ?? this.id,
            name: name ?? this.name,
            image: image ?? this.image,
            typeCar: typeCar ?? this.typeCar,
            categoryCar: categoryCar ?? this.categoryCar,
            yearManufacture: yearManufacture ?? this.yearManufacture,
            platesNumber: platesNumber ?? this.platesNumber,
            platesString: platesString ?? this.platesString,
            imageCar: imageCar ?? this.imageCar,
            mobile: mobile ?? this.mobile,
        );

    factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        typeCar: json["type_car"],
        categoryCar: json["category_car"],
        yearManufacture: json["year_manufacture"],
        platesNumber: json["plates_number"],
        platesString: json["plates_string"],
        imageCar: json["image_car"],
        mobile: json["mobile"],
    );

   
}
