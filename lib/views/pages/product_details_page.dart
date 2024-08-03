import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/provider/product_details_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductDetailsProvider()..getProductDetails(productId),
      child: Scaffold(
        appBar: AppBar(
          title: const Align(
              alignment: Alignment.center, child: Text('Product Details')),
        ),
        body: Consumer<ProductDetailsProvider>(
          builder: (context, provider, _) {
            if (provider.selectedProduct == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Image.network(
                              provider.selectedProduct!.imgUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  provider.selectedProduct!.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${provider.selectedProduct!.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              provider.selectedProduct!.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Size:',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10.0,
                              children: Size.values.map((Size size) {
                                return ChoiceChip(
                                  label: Text(size.name),
                                  selected: provider.selectedSize == size,
                                  onSelected: (bool selected) {
                                    provider.setSize(size);
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text(
                                  'QTY:',
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    provider.decrementQuantity();
                                  },
                                ),
                                Text(
                                  provider.quantity.toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: provider.quantity <
                                          provider.selectedProduct!.inStock
                                      ? () => provider.incrementQuantity()
                                      : null,
                                ),
                              ],
                            ),
                            Text(
                              'In Stock: ${provider.selectedProduct!.inStock}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: provider.selectedSize == null
                          ? null
                          : () async {
                              await provider.addToCart(productId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to cart'),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

extension SizeExtension on Size {
  String get name {
    switch (this) {
      case Size.S:
        return 'S';
      case Size.M:
        return 'M';
      case Size.L:
        return 'L';
      case Size.xL:
        return 'XL';
      default:
        return '';
    }
  }
}
