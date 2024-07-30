import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/views/widgets/product_item_widgets/product_item_fav_widget.dart';
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
                        child: FavProductItem(
                          productId:
                              favoriteProvider.favoritesProducts[index].id,
                          productItem:
                              favoriteProvider.favoritesProducts[index],
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
