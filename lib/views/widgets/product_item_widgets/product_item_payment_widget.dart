import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProductItemPaymentWidget extends StatelessWidget {
  final AddToCartModel item;

  const ProductItemPaymentWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.gray.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CachedNetworkImage(
              imageUrl: item.imgUrl,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Size: ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: item.size.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                  Text('\$ ${item.price}'),
                ],
              ),
              Text('QTY: ${item.quantity}'),
            ],
          ),
        ),
      ],
    );
  }
}
