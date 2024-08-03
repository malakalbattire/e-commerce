import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/order_provider.dart';
import 'package:e_commerce_app_flutter/models/order_model.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final userId =
        FirebaseAuth.instance.currentUser!.uid; // Replace with actual user ID

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (orderProvider.state == OrderState.initial) {
        orderProvider.loadOrders(userId);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await orderProvider.loadOrders(userId);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                if (orderProvider.state == OrderState.loading)
                  const CircularProgressIndicator.adaptive()
                else if (orderProvider.state == OrderState.error)
                  Text('Error: ${orderProvider.errorMessage}')
                else if (orderProvider.orders.isEmpty)
                  const Center(child: Text('No orders found'))
                else ...[
                  for (var order in orderProvider.orders)
                    OrderTile(order: order),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.id}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date: ${order.createdAt.toLocal().toShortDateString()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Total Amount: \$${order.totalAmount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Products:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            // You can replace this with a real product list based on `order.productIds`
            // Here, a placeholder is used for demonstration
            for (var productId in order.productIds)
              Text('Product ID: $productId'),
            const SizedBox(height: 16.0),
            Text(
              'Address ID: ${order.addressId}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Payment ID: ${order.paymentId}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

extension DateFormat on DateTime {
  String toShortDateString() {
    return '${this.day}/${this.month}/${this.year}';
  }
}
