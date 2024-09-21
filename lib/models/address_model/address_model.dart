import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

// @JsonSerializable()
// class AddressModel {
//   final String id;
//   final String firstName;
//   final String lastName;
//   final String countryName;
//   final String cityName;
//   final String phoneNumber;
//   final bool isSelected;
//   final String userId;
//
//   AddressModel({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.countryName,
//     required this.cityName,
//     required this.phoneNumber,
//     this.isSelected = false,
//     required this.userId,
//   });
//
//   factory AddressModel.fromJson(Map<String, dynamic> json) =>
//       _$AddressModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$AddressModelToJson(this);
//
//   factory AddressModel.fromMap(Map<String, dynamic> map, String documentId) {
//     final userId = map['userId'] as String?;
//     print("userId:${userId}===========");
//     if (userId == null || userId.isEmpty) {
//       throw ArgumentError('userId cannot be empty');
//     }
//
//     return AddressModel(
//       id: map['id'] as String? ?? documentId,
//       firstName: map['firstName'] as String? ?? '',
//       lastName: map['lastName'] as String? ?? '',
//       countryName: map['countryName'] as String? ?? '',
//       cityName: map['cityName'] as String? ?? '',
//       phoneNumber: map['phoneNumber'] as String? ?? '',
//       isSelected: (map['isSelected'] is bool)
//           ? map['isSelected'] as bool
//           : (map['isSelected'] == 1),
//       userId: userId, // Ensure this is always valid
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'firstName': firstName,
//       'lastName': lastName,
//       'countryName': countryName,
//       'cityName': cityName,
//       'phoneNumber': phoneNumber,
//       'isSelected': isSelected ? 1 : 0,
//       'userId': userId,
//     };
//   }
//
//   AddressModel copyWith({
//     String? id,
//     String? firstName,
//     String? lastName,
//     String? countryName,
//     String? cityName,
//     String? phoneNumber,
//     bool? isSelected,
//     String? userId,
//   }) {
//     return AddressModel(
//       id: id ?? this.id,
//       firstName: firstName ?? this.firstName,
//       lastName: lastName ?? this.lastName,
//       countryName: countryName ?? this.countryName,
//       cityName: cityName ?? this.cityName,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       isSelected: isSelected ?? this.isSelected,
//       userId: userId ?? this.userId,
//     );
//   }
// }
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
  });

  // Factory to create AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  // Convert AddressModel to JSON
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  // Factory to create AddressModel from a map and documentId
  factory AddressModel.fromMap(Map<String, dynamic> map, String documentId) {
    final userId = map['userId'] as String?;
    print("userId in address model:${userId}===========");
    if (userId == null || userId.isEmpty) {
      throw ArgumentError('userId cannot be empty');
    }

    return AddressModel(
      id: map['id'] as String? ?? documentId,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      countryName: map['countryName'] as String? ?? '',
      cityName: map['cityName'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      isSelected: (map['isSelected'] is bool)
          ? map['isSelected'] as bool
          : (map['isSelected'] == 1),
      userId: map['userId'] as String? ?? '',
    );
  }

  // Convert AddressModel to a map
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

  // CopyWith method to allow cloning with optional overriding of fields
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
