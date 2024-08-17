import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/provider/product_details_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool _isEditing = false;
  bool _isStockEditing = false;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<ProductDetailsProvider>(context, listen: false);
    provider.getProductDetails(widget.productId).then((_) {
      final product = provider.selectedProduct;
      if (product != null) {
        _priceController.text = product.price.toString();
        _descriptionController.text = product.description;
        _nameController.text = product.name;
        _stockController.text = product.inStock.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isAdmin = currentUser?.email == 'admin@gmail.com';

    return Consumer<ProductDetailsProvider>(
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
            actions: isAdmin
                ? [
                    IconButton(
                      icon: Icon(_isEditing ? Icons.check : Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                          if (!_isEditing) {
                            final updatedProduct = {
                              'name': _nameController.text,
                              'price': double.tryParse(_priceController.text) ??
                                  product.price,
                              'description': _descriptionController.text,
                              'inStock': int.tryParse(_stockController.text) ??
                                  product.inStock,
                            };
                            provider.updateProductDetails(
                                widget.productId, updatedProduct);
                            if (_isStockEditing) {
                              final newStock =
                                  int.tryParse(_stockController.text) ??
                                      product.inStock;
                              provider.updateProductStock(
                                  widget.productId, newStock);
                            }
                          }
                        });
                      },
                    ),
                  ]
                : null,
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
                          if (_isEditing) ...[
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Product Name',
                              ),
                            ),
                            TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Price',
                              ),
                            ),
                            TextField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                            TextField(
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Stock',
                              ),
                            ),
                          ] else ...[
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
                            const SizedBox(height: 10),
                            if (isAdmin)
                              Text(
                                'In Stock: ${product.inStock}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                          const SizedBox(height: 16),
                          if (!isAdmin && product.colors != null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Colors:',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10.0,
                                    children: product.colors!.map((color) {
                                      return GestureDetector(
                                        onTap: () {
                                          provider.setColor(color);
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color.color,
                                            border: Border.all(
                                              color: provider.selectedColor ==
                                                      color
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              width: 3,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (!isAdmin)
                            const Text(
                              'Size:',
                              style: TextStyle(fontSize: 18),
                            ),
                          const SizedBox(height: 10),
                          if (!isAdmin &&
                              (product.size == null ||
                                  product.size == Size.OneSize))
                            const Text(
                              'One Size',
                              style: TextStyle(fontSize: 18),
                            )
                          else if (!isAdmin)
                            Wrap(
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
                          if (!isAdmin) ...[
                            const Divider(),
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
                          ],
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isAdmin)
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
                                      await provider
                                          .addToCart(widget.productId);
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
                              backgroundColor: (hasColors && isColorSelected)
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColor,
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
    );
  }
}
