import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/views/pages/order_pages%20/my_orders_page.dart';
import 'package:flutter/material.dart';

class OrderInfoWidget extends StatelessWidget {
  const OrderInfoWidget({
    super.key,
    required this.order,
    required this.context,
  });

  final OrderModel order;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
            'Order Number (${order.orderNumber})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Order ID: ${order.id}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Date: ${order.createdAt.toLocal().toShortDateString()}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Total Amount: \$${order.totalAmount}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
