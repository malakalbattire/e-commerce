class LocationModel {
  final String id;
  final String cityName;
  final String countryName;
  final String imgUrl;
  final bool isSelected;

  LocationModel({
    required this.id,
    required this.cityName,
    required this.countryName,
    required this.imgUrl,
    this.isSelected = false,
  });

  LocationModel copyWith({
    String? id,
    String? cityName,
    String? countryName,
    String? imgUrl,
    bool? isSelected,
  }) {
    return LocationModel(
      id: id ?? this.id,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      imgUrl: imgUrl ?? this.imgUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

List<LocationModel> listOfLocations = [
  LocationModel(
    id: '1',
    cityName: 'jerusalem',
    countryName: 'palestine',
    imgUrl:
        'https://i.pinimg.com/564x/5a/70/07/5a70070aece4a33399d9e28e79724859.jpg',
  ),
  LocationModel(
      id: '2',
      cityName: 'jordan',
      countryName: 'Amman',
      imgUrl:
          'https://i.pinimg.com/564x/99/39/12/993912e737c3a0878426b8e5b35d621f.jpg'),
];
