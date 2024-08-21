import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/provider/checkout_provider.dart';
import 'package:e_commerce_app_flutter/views/widgets/total_amount_widget.dart';
import 'package:flutter/material.dart';

class CheckoutTotalAmountWidget extends StatelessWidget {
  const CheckoutTotalAmountWidget({
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
        final total = cartItems.fold(
              0.0,
              (total, item) => total + item.totalPrice,
            ) +
            10;

        return TotalAmountWidget(total: total);
      },
    );
  }
}
