import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/favorite_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_routes.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoritesProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (favoriteProvider.state == FavoritesState.initial) {
        favoriteProvider.loadFavData();
      }
    });

    return RefreshIndicator(
      onRefresh: () async {
        await favoriteProvider.loadFavData();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await favoriteProvider.loadFavData();
            },
            child: Column(
              children: [
                if (favoriteProvider.state == FavoritesState.loading)
                  const Center(child: CircularProgressIndicator.adaptive())
                else if (favoriteProvider.state == FavoritesState.error)
                  Text('Error: ${favoriteProvider.errorMessage}')
                else ...[
                  GridView.builder(
                    itemCount: favoriteProvider.favoritesProducts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 18,
                    ),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.productDetails,
                        arguments: favoriteProvider.favoritesProducts[index].id,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.gray1,
                            borderRadius: BorderRadius.circular(16)),
                        child: ProductItem(
                          productId:
                              favoriteProvider.favoritesProducts[index].id,
                          productItem:
                              favoriteProvider.favoritesProducts[index],
                        ),
                      ),
                    ),
                  ),
                ]

                //ProductItem(productItem: favoriteProvider.favoriteProducts[index])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String productId;
  final FavoriteModel productItem;
  const ProductItem(
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                'Removed from favorites',
                              )),
                            );
                          } else {
                            await Provider.of<FavoritesProvider>(context,
                                    listen: false)
                                .addToFav(productId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                'Added to favorites',
                              )),
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
