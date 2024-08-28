import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/views/widgets/cart_total_subtotal_item_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/empty_cart_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '../../provider/cart_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../widgets/cart_item_widget.dart';
import 'package:collection/collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentUser != null && cartProvider.state == CartState.initial) {
        cartProvider.subscribeToCart(currentUser.uid);
      }
    });

    if (currentUser == null) {
      return const SigninSignoutWidget();
    }

    Stream<List<ProductItemModel>> getProductStream(List<String> cartIds) {
      return FirebaseFirestore.instance
          .collection('products')
          .where('id', whereIn: cartIds)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ProductItemModel.fromMap(doc.data(), doc.id))
              .toList());
    }

    return StreamBuilder<List<AddToCartModel>>(
      stream: cartProvider.cartServices.getCartItemsStream(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyCartWidget();
        } else {
          final cartItems = snapshot.data!;
          final cartIds = cartItems.map((item) => item.id).toList();

          return StreamBuilder<List<ProductItemModel>>(
            stream: getProductStream(cartIds),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (productSnapshot.hasError) {
                return const Center(child: Text('An error occurred'));
              } else if (!productSnapshot.hasData ||
                  productSnapshot.data!.isEmpty) {
                return const EmptyCartWidget();
              } else {
                final products = productSnapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final product =
                              products.firstWhereOrNull((p) => p.id == item.id);

                          if (product == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              cartProvider.removeFromCart(item.id);
                            });
                            return const SizedBox.shrink();
                          }

                          return InkWell(
                            onTap: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(
                              AppRoutes.productDetails,
                              arguments: item.id,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.gray1,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: CartItemWidget(
                                productItem: item,
                              ),
                            ),
                          );
                        },
                      ),
                      CartTotalAndSubtotalItemWidget(
                          context: context,
                          title: 'Subtotal',
                          amount: cartProvider.subtotal),
                      const SizedBox(height: 8),
                      CartTotalAndSubtotalItemWidget(
                          context: context, title: 'Shipping', amount: 10),
                      const SizedBox(height: 16),
                      Dash(
                        length: MediaQuery.of(context).size.width - 32,
                        dashLength: 12,
                        dashColor: AppColors.gray,
                      ),
                      const SizedBox(height: 16),
                      CartTotalAndSubtotalItemWidget(
                          context: context,
                          title: 'Total Amount',
                          amount: cartProvider.subtotal + 10),
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
                );
              }
            },
          );
        }
      },
    );
  }
}
