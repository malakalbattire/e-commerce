import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/product_providers/product_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/product_item_widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryName = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Products'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ProductItemModel>>(
        future: Provider.of<ProductProvider>(context, listen: false)
            .fetchProductsByCategory(categoryName),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          } else {
            final products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: products.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productDetails,
                      arguments: products[i].id,
                    );
                  },
                  child: ProductItem(
                    productId: products[i].id,
                    productItem: products[i],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
