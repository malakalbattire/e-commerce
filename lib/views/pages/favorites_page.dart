import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/provider/home_provider.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/views/widgets/product_item_widgets/product_item_fav_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final authServices = Provider.of<AuthServicesImpl>(context);

    return Scaffold(
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          if (favoritesProvider.state == FavoritesState.loading ||
              homeProvider.state == HomeState.loading) {
            print('loading');
            return const Center(child: CircularProgressIndicator());
          } else if (favoritesProvider.state == FavoritesState.error) {
            print('error');
            return Center(child: Text(favoritesProvider.errorMessage));
          } else if (favoritesProvider.state == FavoritesState.loaded) {
            if (favoritesProvider.favoritesProducts.isEmpty) {
              print('no favorites');
              return const Center(child: Text('No favorites found.'));
            }
            print('loaded');
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: favoritesProvider.favoritesProducts.length,
                itemBuilder: (context, index) {
                  final favoriteProduct =
                      favoritesProvider.favoritesProducts[index];
                  return FutureBuilder<ProductItemModel>(
                    future:
                        favoritesProvider.getInStockProduct(favoriteProduct.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('Product not found'));
                      }
                      final inStockProduct = snapshot.data!;
                      return FavProductItem(
                        productId: favoriteProduct.id,
                        productItem: favoriteProduct,
                        inStockProduct: inStockProduct,
                      );
                    },
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
