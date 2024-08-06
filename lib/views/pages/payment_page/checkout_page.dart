import 'package:e_commerce_app_flutter/provider/cart_provider.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/provider/order_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_widget/address_model_bottom_sheet.dart';
import 'package:e_commerce_app_flutter/views/widgets/payments_widgets/payment_model_bottom_sheet.dart';
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
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.gray.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: addressProvider.selectedAddressId == null
                                ? const Center(child: Text('Add Address'))
                                : Center(
                                    child: Text(
                                        '${addressProvider.selectedAddressId}')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      buildInlineHeadline(
                        context: context,
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
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.gray.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: paymentProvider.selectedPaymentId == null
                                ? const Center(
                                    child: Text('Add Payment Method'))
                                : Center(
                                    child: Text(
                                        ' ${paymentProvider.selectedPaymentId}')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      buildTotalAmount(context, cartProvider.subtotal + 10),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (addressProvider.selectedAddressId == null ||
                                paymentProvider.selectedPaymentId == null ||
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
                              addressId: addressProvider.selectedAddressId!,
                              paymentId: paymentProvider.selectedPaymentId!,
                              totalAmount: cartProvider.subtotal + 10,
                            );

                            if (orderProvider.state == OrderState.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error: ${orderProvider.errorMessage}'),
                                ),
                              );
                            } else {
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
          if (cartProvider.state == CartState.loading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
        ],
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
