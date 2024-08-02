import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  final String id;
  final String firstName;
  final String lastName;
  final String countryName;
  final String cityName;
  final String phoneNumber;
  final bool isSelected;

  AddressModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.countryName,
    required this.cityName,
    required this.phoneNumber,
    this.isSelected = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  factory AddressModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AddressModel(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      countryName: map['countryName'] as String,
      cityName: map['cityName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isSelected: map['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'countryName': countryName,
      'cityName': cityName,
      'phoneNumber': phoneNumber,
      'isSelected': isSelected,
    };
  }

  AddressModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? countryName,
    String? cityName,
    String? phoneNumber,
    bool? isSelected,
  }) {
    return AddressModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      countryName: countryName ?? this.countryName,
      cityName: cityName ?? this.cityName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
