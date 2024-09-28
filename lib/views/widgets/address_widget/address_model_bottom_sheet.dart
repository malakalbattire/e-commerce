import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_widget/address_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressModelBottomSheet extends StatelessWidget {
  final AuthServices _authServices = AuthServicesImpl(); // Using AuthServices

  AddressModelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: _authServices.getUser(), // Fetch the current user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user found'));
        }

        final userId = snapshot.data!.id;

        return Consumer<AddressProvider>(
          builder: (context, addressProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (addressProvider.state == AddressState.initial) {
                addressProvider
                    .loadAddressData(userId); // Use user ID from AuthServices
              }
            });

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Choose Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Expanded(
                    child: addressProvider.state == AddressState.loading
                        ? const Center(child: CircularProgressIndicator())
                        : addressProvider.state == AddressState.error
                            ? Center(
                                child: Text(
                                    'Error: ${addressProvider.errorMessage}'))
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: addressProvider.addressItems.length,
                                itemBuilder: (context, index) {
                                  final address =
                                      addressProvider.addressItems[index];
                                  return GestureDetector(
                                    onTap: () {
                                      addressProvider.chooseAddress(address.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: AddressItemWidget(address: address),
                                  );
                                },
                              ),
                  ),
                  AddressItemWidget(
                    additionOnTap: () {
                      Navigator.pushNamed(context, AppRoutes.address);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
