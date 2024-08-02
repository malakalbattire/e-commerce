import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class AddressModelBottomSheet extends StatelessWidget {
//   const AddressModelBottomSheet({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AddressProvider>(
//       builder: (context, addressProvider, child) {
//         if (addressProvider.state == AddressState.initial) {
//           addressProvider.loadAddressData();
//         }
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 8.0,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 24),
//               Center(
//                 child: Text(
//                   'Choose Address',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ),
//               const SizedBox(height: 24.0),
//               Expanded(
//                 child: addressProvider.state == AddressState.loading
//                     ? const Center(child: CircularProgressIndicator())
//                     : addressProvider.state == AddressState.error
//                         ? Center(
//                             child:
//                                 Text('Error: ${addressProvider.errorMessage}'))
//                         : ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: addressProvider.addressItems.length,
//                             itemBuilder: (context, index) {
//                               final address =
//                                   addressProvider.addressItems[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   print(addressProvider.addressItems.length);
//                                   addressProvider.chooseAddress(address.id);
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: AddressItemWidget(address: address),
//                               );
//                             },
//                           ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
class AddressModelBottomSheet extends StatelessWidget {
  const AddressModelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        // Schedule loadAddressData to run after the widget build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (addressProvider.state == AddressState.initial) {
            addressProvider.loadAddressData();
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
                            child:
                                Text('Error: ${addressProvider.errorMessage}'))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: addressProvider.addressItems.length,
                            itemBuilder: (context, index) {
                              final address =
                                  addressProvider.addressItems[index];
                              return GestureDetector(
                                onTap: () {
                                  print(addressProvider.addressItems.length);
                                  addressProvider.chooseAddress(address.id);
                                  Navigator.of(context).pop();
                                },
                                child: AddressItemWidget(address: address),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}
