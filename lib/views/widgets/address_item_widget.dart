import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/address_model.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:flutter/material.dart';
import '../../../models/payment_method_model.dart';
import '../../../provider/payment_provider.dart';
import '../../../utils/app_colors.dart';
import 'package:provider/provider.dart';

class AddressItemWidget extends StatelessWidget {
  final AddressModel? address;
  final VoidCallback? additionOnTap;
  const AddressItemWidget({
    super.key,
    this.address,
    this.additionOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Consumer<AddressProvider>(builder: (context, provider, child) {
            return ListTile(
              onTap: additionOnTap != null
                  ? additionOnTap
                  : () {
                      provider.chooseAddress(address!.id);
                    },
              leading: address == null ? const Icon(Icons.add) : null,
              title: Text(
                address != null
                    ? "${address!.firstName} ${address!.lastName}"
                    : 'Add Address',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: address != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${address!.cityName} / ${address!.countryName}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.gray),
                        ),
                        Text(
                          address!.phoneNumber,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.gray),
                        ),
                      ],
                    )
                  : null,
              trailing: address != null
                  ? Radio<String>(
                      value: address!.id,
                      groupValue: provider.selectedAddressId,
                      onChanged: (value) => provider.chooseAddress(value!),
                    )
                  : null,
            );
          }),
        ),
      ),
    );
  }
}
