class CategoryModel {
  final int? id;
  final String? name;
  final dynamic description;
  final String? image;
  final int? status;
  final bool? isPerson;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isPerson,
  });

  CategoryModel copyWith({
    int? id,
    String? name,
    dynamic description,
    String? image,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPerson,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isPerson: isPerson ?? this.isPerson,
      );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isPerson: json["is_person"]==1,
        image: json["image"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
