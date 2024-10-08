import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FavProductItem extends StatelessWidget {
  final String productId;
  final FavoriteModel productItem;
  final ProductItemModel inStockProduct;
  const FavProductItem({
    super.key,
    required this.productItem,
    required this.productId,
    required this.inStockProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, _) {
        bool isFavorite = provider.isFavorite(productId);

        return Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: productItem.imgUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
                      onPressed: () async {
                        if (isFavorite) {
                          await provider.removeFromFav(productId);
                          Fluttertoast.showToast(
                            msg: "Removed From Favorite",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black.withOpacity(0.4),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else {
                          await provider.addToFav(productId);
                          Fluttertoast.showToast(
                            msg: "Added to Favorite",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black.withOpacity(0.4),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4.0,
                  left: 4.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: inStockProduct.inStock > 0
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      inStockProduct.inStock > 0
                          ? 'In Stock ${inStockProduct.inStock}'
                          : 'Sold Out',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
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
      },
    );
  }
}
