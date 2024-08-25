import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/provider/checkout_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_widget/address_model_bottom_sheet.dart';
import 'package:e_commerce_app_flutter/views/widgets/inline_headline_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutAddressWidget extends StatelessWidget {
  const CheckoutAddressWidget({
    super.key,
    required this.checkoutProvider,
  });

  final CheckoutProvider checkoutProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        return StreamBuilder<List<AddressModel>>(
          stream: Stream.fromFuture(Future.value(addressProvider.addressItems)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                children: [
                  InlineHeadlineWidget(
                    title: 'Address',
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => const AddressModelBottomSheet(),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  InkWell(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => const AddressModelBottomSheet(),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.gray.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(child: Text('Add Address')),
                    ),
                  ),
                ],
              );
            }

            final selectedAddressId = addressProvider.selectedAddress;
            final selectedAddress = snapshot.data!.firstWhere(
              (address) => address.id == selectedAddressId,
              orElse: () => AddressModel(
                id: '',
                firstName: '',
                lastName: '',
                countryName: '',
                cityName: '',
                phoneNumber: '',
              ),
            );

            return Column(
              children: [
                InlineHeadlineWidget(
                  title: 'Address',
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => const AddressModelBottomSheet(),
                  ),
                ),
                const SizedBox(height: 8.0),
                InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => const AddressModelBottomSheet(),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.gray.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: selectedAddress.id.isEmpty
                          ? const Center(child: Text('Add Address'))
                          : Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${selectedAddress.firstName} ${selectedAddress.lastName}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                      '${selectedAddress.cityName} / ${selectedAddress.countryName}'),
                                  Text(selectedAddress.phoneNumber),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
