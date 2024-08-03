import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/views/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final AddToCartModel productItem;

  const CartItemWidget({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    //  final productDetailsProvider = Provider.of<ProductDetailsProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: productItem.product.imgUrl,
                    height: 150.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              PositionedDirectional(
                end: 8.0,
                top: 8.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.3),
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_outlined,
                      size: 30,
                    ),
                    color: AppColors.red,
                    onPressed: () {
                      final cartProvider =
                          Provider.of<CartProvider>(context, listen: false);
                      cartProvider.removeFromCart(productItem.id);
                    },
                  ),
                ),
              ),
              PositionedDirectional(
                start: 8.0,
                bottom: 8.0,
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    final quantity = cartProvider.cartItems
                        .firstWhere((item) => item.id == productItem.id,
                            orElse: () => productItem)
                        .quantity;
                    return CounterWidget(
                      productId: productItem.id,
                      value: quantity,
                      inStock: productItem.product.inStock,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productItem.product.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Size:',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.gray,
                          ),
                      children: [
                        TextSpan(
                          text: '/${productItem.size.name}',
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '\$${productItem.product.price}',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
