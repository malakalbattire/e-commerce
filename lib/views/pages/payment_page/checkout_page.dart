import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/provider/cart_provider.dart';
import 'package:e_commerce_app_flutter/provider/order_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/provider/checkout_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_widget/address_card_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_widget/address_model_bottom_sheet.dart';
import 'package:e_commerce_app_flutter/views/widgets/inline_headline_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/payments_widgets/payment_card_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/payments_widgets/payment_model_bottom_sheet.dart';
import 'package:e_commerce_app_flutter/views/widgets/total_amount_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/product_item_widgets/product_item_payment_widget.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final checkoutProvider =
          Provider.of<CheckoutProvider>(context, listen: false);
      checkoutProvider.loadCartItems();
      checkoutProvider.loadAddressItems();
      checkoutProvider.loadPaymentItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              checkoutProvider.loadCartItems();
              checkoutProvider.loadAddressItems();
              checkoutProvider.loadPaymentItems();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    if (checkoutProvider.state == CheckoutState.error)
                      const Text('Error: An error occurred while loading data')
                    else ...[
                      _buildAddressSection(checkoutProvider),
                      const SizedBox(height: 16.0),
                      _buildCartItemsSection(checkoutProvider),
                      const SizedBox(height: 16.0),
                      _buildPaymentSection(checkoutProvider),
                      const SizedBox(height: 16.0),
                      _buildTotalAmountSection(checkoutProvider),
                      const SizedBox(height: 16.0),
                      _buildPlaceOrderButton(checkoutProvider),
                      const SizedBox(height: 80.0),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (checkoutProvider.state == CheckoutState.loading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(CheckoutProvider checkoutProvider) {
    return StreamBuilder<List<AddressModel>>(
      stream: Stream.fromFuture(Future.value(checkoutProvider.addressItems)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final addressItems = snapshot.data ?? [];
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
                  child: addressItems.isEmpty
                      ? const Center(child: Text('Add Address'))
                      : Center(
                          child: AddressCardWidget(
                            address: addressItems.first,
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCartItemsSection(CheckoutProvider checkoutProvider) {
    return StreamBuilder<List<AddToCartModel>>(
      stream: Stream.fromFuture(Future.value(checkoutProvider.cartItems)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final cartItems = snapshot.data ?? [];
        return Column(
          children: [
            InlineHeadlineWidget(
              title: 'Products (${cartItems.length})',
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              itemCount: cartItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ProductItemPaymentWidget(item: item);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentSection(CheckoutProvider checkoutProvider) {
    return StreamBuilder<List<PaymentModel>>(
      stream: Stream.fromFuture(Future.value(checkoutProvider.paymentItems)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final paymentItems = snapshot.data ?? [];
        return Column(
          children: [
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
                  child: paymentItems.isEmpty
                      ? const Center(child: Text('Add Payment Method'))
                      : Center(
                          child: PaymentCardWidget(
                            payment: paymentItems.first,
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTotalAmountSection(CheckoutProvider checkoutProvider) {
    return StreamBuilder<List<AddToCartModel>>(
      stream: Stream.fromFuture(Future.value(checkoutProvider.cartItems)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final cartItems = snapshot.data ?? [];
        final total = cartItems.fold(
              0.0,
              (total, item) => total + item.totalPrice,
            ) +
            10;

        return TotalAmountWidget(total: total);
      },
    );
  }

  Widget _buildPlaceOrderButton(CheckoutProvider checkoutProvider) {
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final paymentProvider = Provider.of<CardPaymentProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (addressProvider.selectedAddress == null ||
              paymentProvider.selectedPaymentMethodId == null ||
              cartProvider.cartItemCount == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select address and payment method'),
              ),
            );
            return;
          }

          await orderProvider.placeOrder(
            userId: FirebaseAuth.instance.currentUser!.uid,
            productIds:
                cartProvider.cartItems.map((item) => item.product.id).toList(),
            addressId: addressProvider.selectedAddress!,
            paymentId: paymentProvider.selectedPaymentMethodId!,
            firstName: addressProvider.addressItems
                .firstWhere(
                    (address) => address.id == addressProvider.selectedAddress)
                .firstName,
            countryName: addressProvider.addressItems
                .firstWhere(
                    (address) => address.id == addressProvider.selectedAddress)
                .countryName,
            cityName: addressProvider.addressItems
                .firstWhere(
                    (address) => address.id == addressProvider.selectedAddress)
                .cityName,
            lastName: addressProvider.addressItems
                .firstWhere(
                    (address) => address.id == addressProvider.selectedAddress)
                .lastName,
            phoneNumber: addressProvider.addressItems
                .firstWhere(
                    (address) => address.id == addressProvider.selectedAddress)
                .phoneNumber,
            cardNumber: paymentProvider.paymentItems
                .firstWhere((payment) =>
                    payment.id == paymentProvider.selectedPaymentMethodId)
                .cardNumber,
            totalAmount: cartProvider.subtotal + 10,
            cartProvider: cartProvider,
            orderNumber: orderProvider.orders.length + 1,
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
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: AppColors.white,
        ),
        child: const Text('Place Order'),
      ),
    );
  }
}
