import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String id;
  final String email;
  final String username;
  final String userRole;

  UserData({
    required this.id,
    required this.email,
    required this.username,
    this.userRole = 'customer',
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromMap(Map<String, dynamic> map) => UserData(
        id: map['id'] as String,
        email: map['email'] as String,
        username: map['username'] as String,
        userRole: map['userRole'] as String? ?? 'customer',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'username': username,
        'userRole': userRole,
      };
}
