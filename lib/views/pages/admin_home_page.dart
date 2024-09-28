import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/provider/home_provider.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
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
    final AuthServices _authServices = AuthServicesImpl();

    return FutureBuilder<UserData?>(
      future: _authServices.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user found. Please log in.'));
        }

        final userId = snapshot.data!.id;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (homeProvider.state == HomeState.initial) {
            homeProvider.loadHomeData();
            homeProvider.getProductsStream();
            favoritesProvider.subscribeToFavorites(userId);
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
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
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
                StreamBuilder<List<ProductItemModel>>(
                  stream: homeProvider.productsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products available'));
                    } else {
                      final products = snapshot.data!;
                      return GridView.builder(
                        itemCount: products.length,
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
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(AppRoutes.productDetails,
                                      arguments: products[index].id),
                          child: ProductItem(
                            productId: products[index].id,
                            productItem: products[index],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
