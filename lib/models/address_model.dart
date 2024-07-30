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

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      countryName: json['countryName'],
      cityName: json['cityName'],
      phoneNumber: json['phoneNumber'],
      isSelected: json['isSelected'],
    );
  }

  Map<String, dynamic> toJson() {
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

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      countryName: map['countryName'] as String,
      cityName: map['cityName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isSelected: map['isSelected'] as bool,
    );
  }
}
