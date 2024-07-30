// import 'package:e_commerce_app_flutter/utils/api_path.dart';
// import 'package:e_commerce_app_flutter/utils/app_colors.dart';
// import 'package:e_commerce_app_flutter/utils/app_routes.dart';
// import 'package:e_commerce_app_flutter/views/widgets/address_model_bottom_sheet.dart';
// import 'package:e_commerce_app_flutter/views/widgets/payments_widgets/payment_model_bottom_sheet.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../provider/payment_provider.dart';
// import '../widgets/product_item_widgets/product_item_payment_widget.dart';
//
// class PaymentPage extends StatelessWidget {
//   const PaymentPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final paymentProvider = Provider.of<PaymentProvider>(context);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (paymentProvider.state == PaymentState.initial) {
//         paymentProvider.loadPaymentData();
//       }
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Column(
//             children: [
//               if (paymentProvider.state == PaymentState.loading)
//                 const CircularProgressIndicator.adaptive()
//               else if (paymentProvider.state == PaymentState.error)
//                 Text('Error: ${paymentProvider.errorMessage}')
//               else ...[
//                 buildInlineHeadline(
//                   context: context,
//                   title: 'Address',
//                   onTap: () {},
//                 ),
//                 const SizedBox(height: 8.0),
//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                     width: double.infinity,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: AppColors.gray.withOpacity(0.4),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: InkWell(
//                       onTap: () => showModalBottomSheet(
//                         context: context,
//                         builder: (context) => const AddressModelBottomSheet(),
//                       ),
//                       child: const Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: Center(
//                           child: Text('Add Address'),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 buildInlineHeadline(
//                   context: context,
//                   title: 'Products',
//                   productsNumbers: paymentProvider.cartItems.length.toDouble(),
//                 ),
//                 const SizedBox(height: 8.0),
//                 ListView.builder(
//                   itemCount: paymentProvider.cartItems.length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     final item = paymentProvider.cartItems[index];
//                     return ProductItemPaymentWidget(item: item);
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 buildInlineHeadline(
//                   context: context,
//                   title: 'Payment Method',
//                 ),
//                 const SizedBox(height: 8.0),
//                 InkWell(
//                   onTap: () => showModalBottomSheet(
//                     context: context,
//                     builder: (context) => const PaymentModelBottomSheet(),
//                   ),
//                   child: Container(
//                     width: double.infinity,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: AppColors.gray.withOpacity(0.4),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Center(
//                         child: Text('Add Payment Method'),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 buildTotalAmount(context, paymentProvider.total),
//                 const SizedBox(height: 16.0),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).primaryColor,
//                         foregroundColor: AppColors.white),
//                     child: const Text('Checkout Now'),
//                   ),
//                 ),
//                 const SizedBox(height: 80.0),
//               ]
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildInlineHeadline({
//     required BuildContext context,
//     required String title,
//     double? productsNumbers,
//     VoidCallback? onTap,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             if (productsNumbers != null)
//               Text(
//                 ' ($productsNumbers)',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//           ],
//         ),
//         if (onTap != null)
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamed(context, AppRoutes.address);
//             },
//             child: Text(
//               'Edit',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium!
//                   .copyWith(color: Theme.of(context).primaryColor),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget buildTotalAmount(BuildContext context, double total) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Total Amount',
//             style: Theme.of(context)
//                 .textTheme
//                 .labelLarge!
//                 .copyWith(color: AppColors.gray),
//           ),
//           Text(
//             '\$ $total',
//             style: Theme.of(context).textTheme.labelLarge,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_model_bottom_sheet.dart';
import 'package:e_commerce_app_flutter/views/widgets/payments_widgets/payment_model_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/address_provider.dart';
import '../../provider/payment_provider.dart';
import '../widgets/product_item_widgets/product_item_payment_widget.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (paymentProvider.state == PaymentState.initial) {
        paymentProvider.loadPaymentData();
      }
      if (addressProvider.state == AddressState.initial) {
        addressProvider.loadAddressData();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              if (paymentProvider.state == PaymentState.loading ||
                  addressProvider.state == AddressState.loading)
                const CircularProgressIndicator.adaptive()
              else if (paymentProvider.state == PaymentState.error ||
                  addressProvider.state == AddressState.error)
                Text(
                    'Error: ${paymentProvider.errorMessage} ${addressProvider.errorMessage}')
              else ...[
                buildInlineHeadline(
                  context: context,
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
                    decoration: BoxDecoration(
                      color: AppColors.gray.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: addressProvider.selectedAddressId == null
                            ? const Text('Add Address')
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${addressProvider.addressItems.firstWhere((address) => address.id == addressProvider.selectedAddressId).firstName} ${addressProvider.addressItems.firstWhere((address) => address.id == addressProvider.selectedAddressId).lastName}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    "${addressProvider.addressItems.firstWhere((address) => address.id == addressProvider.selectedAddressId).cityName} / ${addressProvider.addressItems.firstWhere((address) => address.id == addressProvider.selectedAddressId).countryName}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    addressProvider.addressItems
                                        .firstWhere((address) =>
                                            address.id ==
                                            addressProvider.selectedAddressId)
                                        .phoneNumber,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                buildInlineHeadline(
                  context: context,
                  title: 'Products',
                  productsNumbers: paymentProvider.cartItems.length.toDouble(),
                ),
                const SizedBox(height: 8.0),
                ListView.builder(
                  itemCount: paymentProvider.cartItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = paymentProvider.cartItems[index];
                    return ProductItemPaymentWidget(item: item);
                  },
                ),
                const SizedBox(height: 16.0),
                buildInlineHeadline(
                  context: context,
                  title: 'Payment Method',
                ),
                const SizedBox(height: 8.0),
                InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => const PaymentModelBottomSheet(),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.gray.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('Add Payment Method'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                buildTotalAmount(context, paymentProvider.total),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: AppColors.white),
                    child: const Text('Checkout Now'),
                  ),
                ),
                const SizedBox(height: 80.0),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInlineHeadline({
    required BuildContext context,
    required String title,
    double? productsNumbers,
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (productsNumbers != null)
              Text(
                ' ($productsNumbers)',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
          ],
        ),
        if (onTap != null)
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.address);
            },
            child: Text(
              'Edit',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
      ],
    );
  }

  Widget buildTotalAmount(BuildContext context, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: AppColors.gray),
          ),
          Text(
            '\$ $total',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
