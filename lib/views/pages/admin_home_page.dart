import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/provider/home_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/product_item_widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeProvider.state == HomeState.initial) {
        homeProvider.loadHomeData();
        homeProvider.getProductsStream();
        favoritesProvider.subscribeToFavorites();
      }
    });
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Products',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                IconButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(AppRoutes.addProduct);
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            const SizedBox(height: 8.0),
            GridView.builder(
              itemCount: homeProvider.products.length,
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
                  arguments: homeProvider.products[index].id,
                ),
                child: ProductItem(
                  productId: homeProvider.products[index].id,
                  productItem: homeProvider.products[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
