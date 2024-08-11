import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/product_details_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return ChangeNotifierProvider(
      create: (_) => ProductDetailsProvider()..getProductDetails(productId),
      child: Consumer<ProductDetailsProvider>(
        builder: (context, provider, _) {
          if (provider.selectedProduct == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final product = provider.selectedProduct!;
          final bool isOutOfStock = provider.quantity > product.inStock;
          final bool hasSize = product.size != null;
          final bool isSizeSelected = provider.selectedSize != null;
          final bool isColorSelected = provider.selectedColor != null;
          final bool hasColors = product.colors != null;

          return Scaffold(
            appBar: AppBar(
              title: const Align(
                alignment: Alignment.center,
                child: Text('Product Details'),
              ),
            ),
            body: Stack(
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
                              product.imgUrl,
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
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
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
                              product.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 30),
                            if (product.colors != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Select Color:',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    DropdownButton<ProductColor>(
                                      value: provider.selectedColor,
                                      onChanged: (color) {
                                        if (color != null) {
                                          provider.setColor(color);
                                        }
                                      },
                                      items: product.colors!.map((color) {
                                        return DropdownMenuItem(
                                          value: color,
                                          child: Text(color.name),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 10),
                            const Text(
                              'Size:',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            product.size == null || product.size == Size.OneSize
                                ? const Text(
                                    'One Size',
                                    style: TextStyle(fontSize: 18),
                                  )
                                : Wrap(
                                    spacing: 10.0,
                                    children: Size.values.where((size) {
                                      return size != Size.OneSize;
                                    }).map((Size size) {
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
                                  onPressed: provider.quantity < product.inStock
                                      ? () => provider.incrementQuantity()
                                      : null,
                                ),
                              ],
                            ),
                            Text(
                              'In Stock: ${product.inStock}',
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
                    child: isOutOfStock
                        ? ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text(
                              'Sold Out',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: ((hasSize && !isSizeSelected) ||
                                    (hasColors && !isColorSelected))
                                ? null
                                : () async {
                                    if (currentUser == null) {
                                      Fluttertoast.showToast(
                                        msg:
                                            "Please sign in to add items to the cart",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.4),
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      await provider.addToCart(productId);
                                      Fluttertoast.showToast(
                                        msg: "Added to cart",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.4),
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
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
            ),
          );
        },
      ),
    );
  }
}
