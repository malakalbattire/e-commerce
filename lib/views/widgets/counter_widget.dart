import 'package:e_commerce_app_flutter/provider/cart_provider.dart';
import 'package:e_commerce_app_flutter/provider/product_details_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterWidget extends StatelessWidget {
  final String productId;
  final int value;
  final int inStock;

  const CounterWidget({
    Key? key,
    required this.productId,
    required this.value,
    required this.inStock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productDetailsProvider = Provider.of<ProductDetailsProvider>(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: value > 1
                ? () {
                    cartProvider.decrementQuantity(productId);
                  }
                : null,
            icon: const Icon(Icons.remove),
          ),
          Text(value.toString()),
          IconButton(
            onPressed: (value < inStock && inStock > 0)
                ? () async {
                    await cartProvider.incrementQuantity(productId);
                  }
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
