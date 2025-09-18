
class CityModel {
    final int? id;
    final String? name;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    CityModel({
        this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
    });

    CityModel copyWith({
        int? id,
        String? name,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        CityModel(
            id: id ?? this.id,
            name: name ?? this.name,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
