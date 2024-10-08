import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/provider/cart_provider.dart';
import 'package:e_commerce_app_flutter/provider/checkout_provider.dart';
import 'package:e_commerce_app_flutter/provider/order_provider.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPlaceOrderButton extends StatelessWidget {
  CheckoutPlaceOrderButton({
    super.key,
    required this.context,
    required this.checkoutProvider,
  });

  final BuildContext context;
  final CheckoutProvider checkoutProvider;
  final AuthServices _authServices = AuthServicesImpl();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final paymentProvider = Provider.of<CardPaymentProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return FutureBuilder<UserData?>(
      future: _authServices.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
              child: Text('Unable to retrieve user data. Please login.'));
        }

        final userId = snapshot.data!.id;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: orderProvider.state == OrderState.loading
                ? null
                : () async {
                    if (addressProvider.selectedAddress == null ||
                        paymentProvider.selectedPaymentMethodId == null ||
                        cartProvider.cartItemCount == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please select address and payment method'),
                        ),
                      );
                      return;
                    }

                    await orderProvider.placeOrder(
                      userId: userId,
                      productIds: cartProvider.cartItems
                          .map((item) => item.product.id)
                          .toList(),
                      addressId: addressProvider.selectedAddress!,
                      paymentId: paymentProvider.selectedPaymentMethodId!,
                      firstName: addressProvider.addressItems
                          .firstWhere((address) =>
                              address.id == addressProvider.selectedAddress)
                          .firstName,
                      countryName: addressProvider.addressItems
                          .firstWhere((address) =>
                              address.id == addressProvider.selectedAddress)
                          .countryName,
                      cityName: addressProvider.addressItems
                          .firstWhere((address) =>
                              address.id == addressProvider.selectedAddress)
                          .cityName,
                      lastName: addressProvider.addressItems
                          .firstWhere((address) =>
                              address.id == addressProvider.selectedAddress)
                          .lastName,
                      phoneNumber: addressProvider.addressItems
                          .firstWhere((address) =>
                              address.id == addressProvider.selectedAddress)
                          .phoneNumber,
                      cardNumber: paymentProvider.paymentItems
                          .firstWhere((payment) =>
                              payment.id ==
                              paymentProvider.selectedPaymentMethodId)
                          .cardNumber,
                      cartProvider: cartProvider,
                      orderNumber: orderProvider.orders.length + 1,
                      totalAmount: cartProvider.subtotal,
                    );

                    if (orderProvider.state == OrderState.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${orderProvider.errorMessage}'),
                        ),
                      );
                    } else {
                      await cartProvider.clearCart();
                      Navigator.pushNamed(context, AppRoutes.myOrders);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: orderProvider.state == OrderState.loading
                  ? Colors.grey
                  : Theme.of(context).primaryColor,
              foregroundColor: AppColors.white,
            ),
            child: orderProvider.state == OrderState.loading
                ? const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  )
                : const Text('Place Order'),
          ),
        );
      },
    );
  }
}
