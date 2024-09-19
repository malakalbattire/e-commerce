import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/views/widgets/empty_favorites_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/product_item_widgets/product_item_fav_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../../utils/app_routes.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoritesProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentUser != null &&
          favoriteProvider.state == FavoritesState.initial) {
        favoriteProvider.subscribeToFavorites(currentUser.uid);
      }
    });

    if (currentUser == null) {
      return const SigninSignoutWidget();
    }

    return Consumer<FavoritesProvider>(
      builder: (context, provider, child) {
        if (provider.state == FavoritesState.loading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (provider.state == FavoritesState.error) {
          return Center(child: Text('Error: ${provider.errorMessage}'));
        } else if (provider.favoritesProducts.isEmpty) {
          return const EmptyFavoriteWidget();
        }

        final favoriteIds =
            provider.favoritesProducts.map((fav) => fav.id).toList();

        return StreamBuilder<List<ProductItemModel>>(
          stream: provider.getProductStream(favoriteIds),
          builder: (context, productSnapshot) {
            if (productSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (productSnapshot.hasError) {
              print('Error fetching products: ${productSnapshot.error}');
              return Center(
                  child: Text(
                      'Error fetching products: ${productSnapshot.error}'));
            } else if (!productSnapshot.hasData ||
                productSnapshot.data!.isEmpty) {
              return const EmptyFavoriteWidget();
            } else {
              final products = productSnapshot.data!;
              print('Products fetched: $products');
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: GridView.builder(
                  itemCount: provider.favoritesProducts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 18,
                  ),
                  itemBuilder: (context, index) {
                    final favorite = provider.favoritesProducts[index];
                    final product =
                        products.firstWhereOrNull((p) => p.id == favorite.id);

                    if (product == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        provider.removeFromFav(favorite.id);
                      });
                      return const SizedBox.shrink();
                    }

                    return InkWell(
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.productDetails,
                        arguments: favorite.id,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.gray1,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: FavProductItem(
                          productId: favorite.id,
                          productItem: favorite,
                          inStockProduct: product,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        );
      },
    );
  }
}
