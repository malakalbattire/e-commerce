import 'package:e_commerce_app_flutter/provider/cart_provider.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/provider/order_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_widget/address_card_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_widget/address_model_bottom_sheet.dart';
import 'package:e_commerce_app_flutter/views/widgets/inline_headline_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/payments_widgets/payment_card_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/payments_widgets/payment_model_bottom_sheet.dart';
import 'package:e_commerce_app_flutter/views/widgets/total_amount_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/product_item_widgets/product_item_payment_widget.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final paymentProvider = Provider.of<CardPaymentProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cartProvider.state == CartState.initial) {
        cartProvider.loadCartData();
      }
      if (paymentProvider.state == PaymentState.initial) {
        paymentProvider.loadPaymentData();
      }
      if (addressProvider.state == AddressState.initial) {
        addressProvider.loadAddressData();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await cartProvider.loadCartData();
              await paymentProvider.loadPaymentData();
              await addressProvider.loadAddressData();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    if (cartProvider.state == CartState.error)
                      Text('Error: ${cartProvider.errorMessage}')
                    else ...[
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
                            child: addressProvider.selectedAddress == null
                                ? const Center(child: Text('Add Address'))
                                : Center(
                                    child: AddressCardWidget(
                                      address: addressProvider.addressItems
                                          .firstWhere(
                                        (address) =>
                                            address.id ==
                                            addressProvider.selectedAddress,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      InlineHeadlineWidget(
                        title: 'Products (${cartProvider.cartItemCount})',
                      ),
                      const SizedBox(height: 8.0),
                      ListView.builder(
                        itemCount: cartProvider.cartItems.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = cartProvider.cartItems[index];
                          return ProductItemPaymentWidget(item: item);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      InlineHeadlineWidget(
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
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.gray.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:
                                paymentProvider.selectedPaymentMethodId == null
                                    ? const Center(
                                        child: Text('Add Payment Method'))
                                    : Center(
                                        child: PaymentCardWidget(
                                          payment: paymentProvider.paymentItems
                                              .firstWhere(
                                            (payment) =>
                                                payment.id ==
                                                paymentProvider
                                                    .selectedPaymentMethodId,
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TotalAmountWidget(total: cartProvider.subtotal + 10),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (addressProvider.selectedAddress == null ||
                                paymentProvider.selectedPaymentMethodId ==
                                    null ||
                                cartProvider.cartItemCount == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please select address and payment method'),
                                ),
                              );
                              return;
                            }

                            await orderProvider.placeOrder(
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              productIds: cartProvider.cartItems
                                  .map((item) => item.product.id)
                                  .toList(),
                              addressId: addressProvider.selectedAddress!,
                              paymentId:
                                  paymentProvider.selectedPaymentMethodId!,
                              firstName: addressProvider.addressItems
                                  .firstWhere((address) =>
                                      address.id ==
                                      addressProvider.selectedAddress)
                                  .firstName,
                              countryName: addressProvider.addressItems
                                  .firstWhere((address) =>
                                      address.id ==
                                      addressProvider.selectedAddress)
                                  .countryName,
                              cityName: addressProvider.addressItems
                                  .firstWhere((address) =>
                                      address.id ==
                                      addressProvider.selectedAddress)
                                  .cityName,
                              lastName: addressProvider.addressItems
                                  .firstWhere((address) =>
                                      address.id ==
                                      addressProvider.selectedAddress)
                                  .lastName,
                              phoneNumber: addressProvider.addressItems
                                  .firstWhere((address) =>
                                      address.id ==
                                      addressProvider.selectedAddress)
                                  .phoneNumber,
                              cardNumber: paymentProvider.paymentItems
                                  .firstWhere((payment) =>
                                      payment.id ==
                                      paymentProvider.selectedPaymentMethodId)
                                  .cardNumber,
                              totalAmount: cartProvider.subtotal + 10,
                              cartProvider: cartProvider,
                              orderNumber: orderProvider.orders.length + 1,
                              orderStatus: 'waiting',
                            );

                            if (orderProvider.state == OrderState.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error: ${orderProvider.errorMessage}'),
                                ),
                              );
                            } else {
                              await cartProvider.clearCart();
                              Navigator.pushNamed(context, AppRoutes.myOrders);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Place Order'),
                        ),
                      ),
                      const SizedBox(height: 80.0),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (cartProvider.state == CartState.loading ||
              paymentProvider.state == PaymentState.loading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
        ],
      ),
    );
  }
}
