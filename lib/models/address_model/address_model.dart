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
  final String userId;

  AddressModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.countryName,
    required this.cityName,
    required this.phoneNumber,
    this.isSelected = false,
    required this.userId,
  }) {
    if (id.isEmpty) throw ArgumentError('id cannot be empty');
    if (firstName.isEmpty) throw ArgumentError('firstName cannot be empty');
    if (lastName.isEmpty) throw ArgumentError('lastName cannot be empty');
    if (countryName.isEmpty) throw ArgumentError('countryName cannot be empty');
    if (cityName.isEmpty) throw ArgumentError('cityName cannot be empty');
    if (phoneNumber.isEmpty) throw ArgumentError('phoneNumber cannot be empty');
    if (userId.isEmpty) throw ArgumentError('userId cannot be empty');
  }

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
      isSelected: (map['isSelected'] as int?) == 1,
      userId: map['userId'] as String,
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
      'isSelected': isSelected ? 1 : 0,
      'userId': userId,
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
    String? userId,
  }) {
    return AddressModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      countryName: countryName ?? this.countryName,
      cityName: cityName ?? this.cityName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSelected: isSelected ?? this.isSelected,
      userId: userId ?? this.userId,
    );
  }
}
