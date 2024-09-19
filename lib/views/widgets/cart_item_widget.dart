import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/views/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final AddToCartModel cartItem;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

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
                    imageUrl: cartItem.product.imgUrl,
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
                    color: Colors.red.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_outlined,
                      size: 30,
                    ),
                    color: Colors.red,
                    onPressed: () {
                      cartProvider.removeFromCart(cartItem.id);
                    },
                  ),
                ),
              ),
              PositionedDirectional(
                start: 8.0,
                bottom: 8.0,
                child: CounterWidget(
                  productId: cartItem.id,
                  value: cartItem.quantity,
                  inStock: cartItem.product.inStock,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${cartItem.color} / ${cartItem.size.name}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Text(
                '\$${cartItem.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
