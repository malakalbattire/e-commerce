import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/views/widgets/empty_favorites_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/product_item_widgets/product_item_fav_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
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
        favoriteProvider.subscribeToFavorites();
      }
    });

    return StreamBuilder<List<FavoriteModel>>(
      stream: favoriteProvider.favServices.getFavItemsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return SigninSignoutWidget();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return EmptyFavoriteWidget();
        } else {
          final favorites = snapshot.data!;
          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: GridView.builder(
              itemCount: favorites.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 18,
              ),
              itemBuilder: (context, index) => InkWell(
                onTap: () =>
                    Navigator.of(context, rootNavigator: true).pushNamed(
                  AppRoutes.productDetails,
                  arguments: favorites[index].id,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.gray1,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: FavProductItem(
                    productId: favorites[index].id,
                    productItem: favorites[index],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
