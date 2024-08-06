import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FavProductItem extends StatelessWidget {
  final String productId;
  final FavoriteModel productItem;
  const FavProductItem(
      {super.key, required this.productItem, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider()..loadFavData(),
      child: Consumer<FavoritesProvider>(
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
                        borderRadius: BorderRadius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: productItem.imgUrl,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive()),
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
                            await Provider.of<FavoritesProvider>(context,
                                    listen: false)
                                .removeFromFav(productId);

                            Fluttertoast.showToast(
                              msg: "Removed from Favorite",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black.withOpacity(0.4),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            await Provider.of<FavoritesProvider>(context,
                                    listen: false)
                                .addToFav(productId);
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
      ),
    );
  }
}
