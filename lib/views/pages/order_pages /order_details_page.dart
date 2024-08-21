import 'package:e_commerce_app_flutter/provider/product_providers/product_details_provider.dart';
import 'package:e_commerce_app_flutter/views/widgets/order_widgets/order_address_and_payment_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/order_widgets/order_info_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/order_widgets/order_product_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductDetailsProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.getProductsDetails(order.productIds);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          OrderInfoWidget(order: order, context: context),
          const SizedBox(height: 16.0),
          OrderProductListWidget(
              order: order, context: context, productProvider: productProvider),
          const SizedBox(height: 16.0),
          OrderAddressAndPaymentWidget(order: order, context: context),
        ],
      ),
    );
  }
}
