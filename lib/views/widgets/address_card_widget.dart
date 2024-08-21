import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressCardWidget extends StatelessWidget {
  const AddressCardWidget({
    super.key,
    required this.context,
    required this.address,
  });

  final BuildContext context;
  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${address.firstName} ${address.lastName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${address.cityName}, ${address.countryName}',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              address.phoneNumber,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<AddressProvider>(context, listen: false)
                        .removeAddress(address.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
