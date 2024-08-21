import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/provider/checkout_provider.dart';
import 'package:e_commerce_app_flutter/views/widgets/inline_headline_widget.dart';
import 'package:flutter/material.dart';

import '../product_item_widgets/product_item_payment_widget.dart';

class CheckoutCartItemsWidget extends StatelessWidget {
  const CheckoutCartItemsWidget({
    super.key,
    required this.checkoutProvider,
  });

  final CheckoutProvider checkoutProvider;

  @override
  Widget build(BuildContext context) {
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
}
