import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/checkout_widgets/checkout_cart_items_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/checkout_widgets/checkout_address_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/checkout_widgets/checkout_payment_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/checkout_widgets/checkout_place_order_button.dart';
import 'package:e_commerce_app_flutter/views/widgets/checkout_widgets/checkout_total_amount_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/checkout_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? lastUserId;
  final AuthServices _authServices = AuthServicesImpl();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final checkoutProvider =
          Provider.of<CheckoutProvider>(context, listen: false);
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      final paymentProvider =
          Provider.of<CardPaymentProvider>(context, listen: false);

      final user = await _authServices.getUser();

      if (user == null) {
        await addressProvider.clearAddresses();
        await paymentProvider.clearPaymentCards();
        Navigator.pushNamed(context, AppRoutes.login);
        return;
      } else if ((addressProvider.state == AddressState.initial &&
              paymentProvider.state == PaymentState.initial) ||
          user.id != lastUserId) {
        lastUserId = user.id;
        addressProvider.clearAddresses();
        addressProvider.loadAddressData(user.id);
        paymentProvider.clearPaymentCards();
        paymentProvider.loadPaymentData(user.id);
      }

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
                      CheckoutAddressWidget(checkoutProvider: checkoutProvider),
                      const SizedBox(height: 16.0),
                      CheckoutCartItemsWidget(
                          checkoutProvider: checkoutProvider),
                      const SizedBox(height: 16.0),
                      CheckoutPaymentWidget(checkoutProvider: checkoutProvider),
                      const SizedBox(height: 16.0),
                      CheckoutTotalAmountWidget(
                          checkoutProvider: checkoutProvider),
                      const SizedBox(height: 16.0),
                      CheckoutPlaceOrderButton(
                          context: context, checkoutProvider: checkoutProvider),
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
}
