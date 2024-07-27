import 'package:json_annotation/json_annotation.dart';

part 'home_carousel_model.g.dart';

@JsonSerializable()
class HomeCarouselModel {
  final String id;
  final String imgUrl;

  const HomeCarouselModel({required this.id, required this.imgUrl});

  factory HomeCarouselModel.fromJson(Map<String, dynamic> json) =>
      _$HomeCarouselModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCarouselModelToJson(this);

  factory HomeCarouselModel.fromMap(
      Map<String, dynamic> data, String documentId) {
    return HomeCarouselModel(
      id: documentId,
      imgUrl: data['imgUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgUrl': imgUrl,
    };
  }

  HomeCarouselModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
  }) {
    return HomeCarouselModel(id: id ?? this.id, imgUrl: imgUrl ?? this.imgUrl);
  }
}
