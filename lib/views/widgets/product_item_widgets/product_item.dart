import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductItem extends StatelessWidget {
  final String productId;
  final ProductItemModel productItem;

  const ProductItem({
    super.key,
    required this.productItem,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, _) {
        bool isFavorite = provider.isFavorite(productId);
        final currentUser = FirebaseAuth.instance.currentUser;

        return StreamBuilder<int>(
          stream: productItem.stockStream,
          builder: (context, snapshot) {
            bool isOutOfStock = !snapshot.hasData || snapshot.data! <= 0;

            return Stack(
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
                if (isOutOfStock)
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Sold Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                Positioned(
                  top: 4.0,
                  right: 4.0,
                  child: isOutOfStock
                      ? Container()
                      : DecoratedBox(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white60,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              if (currentUser == null) {
                                Fluttertoast.showToast(
                                  msg:
                                      "Please log in to add items to favorites",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.4),
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                if (isFavorite) {
                                  await provider.removeFromFav(productId);
                                  Fluttertoast.showToast(
                                    msg: "Removed From Favorite",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.4),
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
                                    backgroundColor:
                                        Colors.black.withOpacity(0.4),
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                ),
                if (!isOutOfStock) ...[
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                            '\$ ${productItem.price}',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
