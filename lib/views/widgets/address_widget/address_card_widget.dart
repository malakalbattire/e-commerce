import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:flutter/material.dart';

class AddressCardWidget extends StatelessWidget {
  final AddressModel address;

  const AddressCardWidget({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${address.firstName} ${address.lastName}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text('${address.cityName} / ${address.countryName}'),
        Text('${address.phoneNumber}'),
      ],
    );
  }
}
