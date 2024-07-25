import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../widgets/product_item.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoritesProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (favoriteProvider.state == FavoritesState.initial) {
        favoriteProvider.loadHomeData();
      }
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 18,
                  ),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.of(
                      context,
                      // rootNavigator: true,
                    ).pushNamed(AppRoutes.productDetails),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.gray1,
                          borderRadius: BorderRadius.circular(16)),
                      child: ProductItem(
                        productItem: favoriteProvider.favoritesProducts[index],
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
    );
  }
}
