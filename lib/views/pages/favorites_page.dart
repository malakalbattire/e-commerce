import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/views/widgets/product_item_widgets/product_item_fav_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: Builder(
        builder: (context) {
          switch (favoritesProvider.state) {
            case FavoritesState.loading:
              return Center(child: CircularProgressIndicator());
            case FavoritesState.error:
              return Center(child: Text(favoritesProvider.errorMessage));
            case FavoritesState.loaded:
              if (favoritesProvider.favoritesProducts.isEmpty) {
                return Center(child: Text('No favorites found.'));
              }
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
                      future: favoritesProvider
                          .getInStockProduct(favoriteProduct.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return Center(child: Text('Product not found'));
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
            default:
              return Container();
          }
        },
      ),
    );
  }
}
