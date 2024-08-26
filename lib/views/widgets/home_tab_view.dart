import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../provider/home_provider.dart';
import 'product_item_widgets/product_item.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentUser != null) {
        if (homeProvider.state == HomeState.initial) {
          homeProvider.loadHomeData();
          favoritesProvider.subscribeToFavorites(currentUser.uid);
        }
      }
    });

    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (homeProvider.state == HomeState.loading)
              const CircularProgressIndicator.adaptive()
            else if (homeProvider.state == HomeState.error)
              Text('Error: ${homeProvider.errorMessage}')
            else ...[
              FlutterCarousel(
                options: CarouselOptions(
                  height: 200.0,
                  showIndicator: true,
                  slideIndicator: CircularWaveSlideIndicator(),
                ),
                items: homeProvider.carouselItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: item.imgUrl,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator.adaptive()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'New Arrivals',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All'),
                  )
                ],
              ),
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
                        onTap: () => Navigator.of(context, rootNavigator: true)
                            .pushNamed(
                          AppRoutes.productDetails,
                          arguments: products[index].id,
                        ),
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
          ],
        ),
      ),
    );
  }
}
