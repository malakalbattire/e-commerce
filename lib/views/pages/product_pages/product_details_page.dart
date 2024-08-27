import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/product_providers/product_item_provider.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/provider/product_providers/product_details_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

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
    final AuthServicesImpl authServices = AuthServicesImpl();
    Future<bool> isAdminFuture = authServices.isAdmin();

    final productItemProvider = Provider.of<ProductItemProvider>(context);

    return FutureBuilder<bool>(
      future: isAdminFuture,
      builder: (context, snapshot) {
        final bool isAdmin = snapshot.data ?? false;

        return Consumer<ProductDetailsProvider>(
          builder: (context, provider, _) {
            if (provider.selectedProduct == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final product = provider.selectedProduct!;
            final bool isOutOfStock = provider.quantity > product.inStock;
            final bool hasSize =
                product.sizes != null && product.sizes!.isNotEmpty;
            final bool isSizeSelected = provider.selectedSize != null;
            final bool isColorSelected = provider.selectedColor != null;
            final bool hasColors =
                product.colors != null && product.colors!.isNotEmpty;

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
                                  'price':
                                      double.tryParse(_priceController.text) ??
                                          product.price,
                                  'description': _descriptionController.text,
                                  'inStock':
                                      int.tryParse(_stockController.text) ??
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
                              return StreamBuilder<String>(
                                stream: productItemProvider
                                    .getImgUrlStream(product.id),
                                builder: (context, imgSnapshot) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: imgSnapshot.hasData
                                        ? CachedNetworkImage(
                                            imageUrl: imgSnapshot.data!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator
                                                            .adaptive()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
                                        : const SizedBox(),
                                  );
                                },
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
                                const SizedBox(height: 28),
                                Text(
                                  'Product Name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.text_fields),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Price',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                TextField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.attach_money),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Description',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                TextField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.description),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'In Stock',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                TextFormField(
                                  controller: _stockController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.store),
                                  ),
                                ),
                              ] else ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StreamBuilder<String>(
                                      stream: productItemProvider
                                          .getNameStream(product.id),
                                      builder: (context, nameSnapshot) {
                                        return Text(
                                          nameSnapshot.data ?? '',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                    StreamBuilder<double>(
                                      stream: productItemProvider
                                          .getPriceStream(product.id),
                                      builder: (context, priceSnapshot) {
                                        final price = priceSnapshot.data
                                                ?.toStringAsFixed(2) ??
                                            '';
                                        return Text(
                                          '\$ $price',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                StreamBuilder<String>(
                                  stream: productItemProvider
                                      .getDescriptionStream(product.id),
                                  builder: (context, descriptionSnapshot) {
                                    return Text(
                                      descriptionSnapshot.data ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                if (isAdmin)
                                  StreamBuilder<int>(
                                    stream: productItemProvider
                                        .getStockStream(product.id),
                                    builder: (context, inStockSnapshot) {
                                      final inStock =
                                          inStockSnapshot.data?.toString() ??
                                              '';
                                      return Text(
                                        'In Stock: $inStock',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                              ],
                              const SizedBox(height: 16),
                              if (!isAdmin && hasColors)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  color:
                                                      provider.selectedColor ==
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
                              if (!isAdmin) ...[
                                const Text(
                                  'Size:',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                StreamBuilder<List<ProductSize>>(
                                  stream: provider.sizesStream,
                                  builder: (context, sizesSnapshot) {
                                    if (!sizesSnapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final productSizes = sizesSnapshot.data!;
                                    final sizes =
                                        productSizes.map((productSize) {
                                      return convertProductSizeToSize(
                                          productSize);
                                    }).toList();

                                    return sizes.isEmpty
                                        ? const Text(
                                            'One Size',
                                            style: TextStyle(fontSize: 18),
                                          )
                                        : Wrap(
                                            spacing: 10.0,
                                            children: sizes.map((Size size) {
                                              return ChoiceChip(
                                                label: Text(size.name),
                                                selected:
                                                    provider.selectedSize ==
                                                        size,
                                                onSelected: (bool selected) {
                                                  provider.setSize(size);
                                                },
                                              );
                                            }).toList(),
                                          );
                                  },
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
                                        onPressed: () {
                                          provider.incrementQuantity();
                                        },
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
                                  const SizedBox(height: 10),
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: ((hasSize &&
                                                          !isSizeSelected) ||
                                                      (hasColors &&
                                                          !isColorSelected))
                                                  ? null
                                                  : () async {
                                                      if (currentUser == null) {
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              "Please sign in to add items to the cart",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.4),
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      } else {
                                                        await provider
                                                            .addToCart(widget
                                                                .productId);
                                                      }
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: (hasColors &&
                                                        isColorSelected)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .primaryColor,
                                              ),
                                              child: const Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Size convertProductSizeToSize(ProductSize productSize) {
  switch (productSize) {
    case ProductSize.S:
      return Size.S;
    case ProductSize.M:
      return Size.M;
    case ProductSize.L:
      return Size.L;
    case ProductSize.xL:
      return Size.xL;
  }
}
