import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String id;
  final String email;
  final String username;

  UserData({
    required this.id,
    required this.email,
    required this.username,
  });

  // Factory constructor for creating a new UserData instance from a map
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  // Method for converting a UserData instance to a map
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  // Factory constructor for creating a new UserData instance from a map
  factory UserData.fromMap(Map<String, dynamic> map) => UserData(
        id: map['id'] as String,
        email: map['email'] as String,
        username: map['username'] as String,
      );

  // Method for converting a UserData instance to a map
  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'username': username,
      };
}
