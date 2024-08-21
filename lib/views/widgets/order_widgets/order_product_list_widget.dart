import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/provider/product_details_provider.dart';
import 'package:flutter/material.dart';

class OrderProductListWidget extends StatelessWidget {
  const OrderProductListWidget({
    super.key,
    required this.order,
    required this.context,
    required this.productProvider,
  });

  final OrderModel order;
  final BuildContext context;
  final ProductDetailsProvider productProvider;

  @override
  Widget build(BuildContext context) {
    final products = order.productIds
        .map((id) => productProvider.getProductById(id))
        .where((product) => product != null)
        .cast<ProductItemModel>()
        .toList();

    final productQuantities = <String, int>{};
    for (var orderItem in order.items) {
      productQuantities[orderItem.productId] = orderItem.quantity;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Products',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8.0),
          if (products.isEmpty)
            const Center(child: Text('No products available'))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final quantity = productQuantities[product.id] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        product.imgUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 60);
                        },
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Price: \$${product.price}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'QTY: $quantity',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
