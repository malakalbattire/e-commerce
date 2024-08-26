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
      'name': name,
      'imgUrl': imgUrl,
    };
  }
}
