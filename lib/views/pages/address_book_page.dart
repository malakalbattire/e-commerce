import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      if (addressProvider.state == AddressState.initial) {
        addressProvider.loadAddressData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Address Book'),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await addressProvider.loadAddressData();
              },
              child: addressProvider.state == AddressState.loading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : addressProvider.state == AddressState.error
                      ? Center(
                          child: Text('Error: ${addressProvider.errorMessage}'))
                      : addressProvider.addressItems.isEmpty
                          ? const Center(child: Text('No addresses available.'))
                          : SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: Column(
                                children: [
                                  ...addressProvider.addressItems.map(
                                    (address) => _buildAddressCard(address),
                                  ),
                                ],
                              ),
                            ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(AddressModel address) {
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

  // void _showAddAddressDialog(BuildContext context) {
  //
  // }
}
