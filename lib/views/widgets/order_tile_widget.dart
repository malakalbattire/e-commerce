import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/views/pages/order_pages%20/my_orders_page.dart';
import 'package:e_commerce_app_flutter/views/pages/order_pages%20/order_details_page.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;

  const OrderTile({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text('Order ID: ${order.id}'),
        subtitle: Text(
          'Date: ${order.createdAt.toLocal().toShortDateString()}\n'
          'Total: \$${order.totalAmount}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.gray,
              ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailsPage(order: order),
              ),
            );
          },
        ),
      ),
    );
  }
}
