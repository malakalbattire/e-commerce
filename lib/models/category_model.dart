import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  final String imgUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imgUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  factory CategoryModel.fromMap(Map<String, dynamic> data, String documentId) {
    return CategoryModel(
      id: documentId,
      name: data['name'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  bool get hasValidImageUrl => imgUrl.isNotEmpty;
  bool get hasValidName => name.isNotEmpty;
}
