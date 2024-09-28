import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/cart_item_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/empty_cart_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.state == CartState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (cartProvider.state == CartState.error) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${cartProvider.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: cartProvider.cartItems.isEmpty
                    ? const Center(child: EmptyCartWidget())
                    : ListView.builder(
                        itemCount: cartProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartProvider.cartItems[index];
                          return InkWell(
                            onTap: () {
                              if (kDebugMode) {
                                print('${cartItem.id}========');
                              }
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(
                                AppRoutes.productDetails,
                                arguments: cartItem.id,
                              );
                            },
                            child: CartItemWidget(cartItem: cartItem),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal: \$${cartProvider.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(AppRoutes.payment);
                          },
                          child: const Text('Checkout'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
