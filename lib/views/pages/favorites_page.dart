import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/views/widgets/empty_favorites_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/product_item_widgets/product_item_fav_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_routes.dart';
import 'package:collection/collection.dart';

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

    return StreamBuilder<List<FavoriteModel>>(
      stream: favoriteProvider.favServices.getFavItemsStream(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyFavoriteWidget();
        } else {
          final favorites = snapshot.data!;
          final favoriteIds = favorites.map((fav) => fav.id).toList();

          return StreamBuilder<List<ProductItemModel>>(
            stream: favoriteProvider.getProductStream(favoriteIds),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (productSnapshot.hasError) {
                return const Center(child: Text('An error occurred'));
              } else if (!productSnapshot.hasData ||
                  productSnapshot.data!.isEmpty) {
                return const EmptyFavoriteWidget();
              } else {
                final products = productSnapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: GridView.builder(
                    itemCount: favorites.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 18,
                    ),
                    itemBuilder: (context, index) {
                      final favorite = favorites[index];
                      final product =
                          products.firstWhereOrNull((p) => p.id == favorite.id);

                      if (product == null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          favoriteProvider.removeFromFav(favorite.id);
                        });
                        return const SizedBox.shrink();
                      }

                      return InkWell(
                        onTap: () => Navigator.of(context, rootNavigator: true)
                            .pushNamed(
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
        }
      },
    );
  }
}
