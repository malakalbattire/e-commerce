import 'package:e_commerce_app_flutter/provider/cart_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterWidget extends StatelessWidget {
  final String productId;
  final int value;
  const CounterWidget(
      {super.key, required this.productId, required this.value});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              cartProvider.decrementQuantity(productId);
            },
            icon: const Icon(Icons.remove),
          ),
          Text(
            value.toString(),
          ),
          IconButton(
            onPressed: () async {
              await cartProvider.incrementQuantity(productId);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
