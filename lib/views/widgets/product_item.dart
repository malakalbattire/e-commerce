import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/product_item_model.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;
  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: productItem.imgUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 4.0,
              right: 4.0,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white60,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          productItem.name,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          productItem.category,
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: Colors.grey),
        ),
        Text(
          ' \$ ${productItem.price}',
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
