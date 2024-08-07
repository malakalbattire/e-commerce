import 'package:e_commerce_app_flutter/views/widgets/empty_cart_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '../../provider/cart_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final size = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cartProvider.state == CartState.initial) {
        cartProvider.loadCartData();
      }
    });

    return RefreshIndicator(
      onRefresh: () async {
        await cartProvider.loadCartData();
      },
      child: Stack(
        children: [
          if (cartProvider.state == CartState.loading)
            const Center(child: CircularProgressIndicator())
          else if (cartProvider.state == CartState.error)
            SigninSignoutWidget()
          else if (cartProvider.cartItems.isEmpty)
            EmptyCartWidget()
          else ...[
            SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                        productItem: cartProvider.cartItems[index],
                      );
                    },
                  ),
                  buildCartTotalAndSubtotalItem(
                      context, 'Subtotal', cartProvider.subtotal),
                  const SizedBox(height: 8),
                  buildCartTotalAndSubtotalItem(context, 'Shipping', 10),
                  const SizedBox(height: 16),
                  Dash(
                    length: size.width - 32,
                    dashLength: 12,
                    dashColor: AppColors.gray,
                  ),
                  const SizedBox(height: 16),
                  buildCartTotalAndSubtotalItem(
                      context, 'Total Amount', cartProvider.subtotal + 10),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          '\$ ${cartProvider.subtotal + 10}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(AppRoutes.payment);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: AppColors.white),
                              child: Text(
                                'Checkout (${cartProvider.cartItemCount})',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
          if (cartProvider.pageLoading)
            const Center(child: CircularProgressIndicator.adaptive()),
        ],
      ),
    );
  }

  Widget buildCartTotalAndSubtotalItem(
    BuildContext context,
    String title,
    double value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: AppColors.gray),
          ),
          Text(
            '\$ $value',
            style: Theme.of(context).textTheme.labelLarge,
          )
        ],
      ),
    );
  }
}
