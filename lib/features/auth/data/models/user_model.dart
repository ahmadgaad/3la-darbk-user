import 'dart:io';

import '../../../../core/heplers/file_utils.dart';

class UserModel {
  final String? name;
  final String? password;
  final String? mobile;
  final String? image;
  final File? imageFile;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    this.name,
    this.password,
    this.mobile,
    this.image,
    this.imageFile,
    this.createdAt,
    this.updatedAt,
  });


  const UserModel.register({
    required this.imageFile,
    required this.name,
    required this.password,
    required this.mobile,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  UserModel copyWith({
    String? name,
    String? password,
    String? mobile,
    String? image,
    File? imageFile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    name: name ?? this.name,
    password: password ?? this.password,
    mobile: mobile ?? this.mobile,
    image: image ?? this.image,
    imageFile: imageFile ?? this.imageFile,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"],
    password: json["password"],
    mobile: json["mobile"],
    image: json["image"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    if (name != null) "name": name,
    if (password != null) "password": password,
    if (mobile != null) "mobile": mobile,
    if (imageFile != null)
      "image": imageFile != null ? FileUtils.getMultiPartFile(imageFile) : null,
  };
}
