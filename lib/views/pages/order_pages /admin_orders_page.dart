import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/provider/admin_providers/admin_orders_provider.dart';
import 'package:e_commerce_app_flutter/views/pages/order_pages%20/order_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: StreamBuilder<List<OrderModel>>(
          stream: Provider.of<AdminOrdersProvider>(context).ordersStream,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No orders found.'));
            }

            final orders = snapshot.data!;
            final sortedOrders = orders
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedOrders.length,
              itemBuilder: (ctx, index) {
                final order = sortedOrders[index];
                final currentStatus = order.orderStatus!.isNotEmpty
                    ? order.orderStatus?.first
                    : OrderStatus.waitingForConfirmation;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${order.firstName} ${order.lastName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StreamBuilder<Map<String, OrderStatus>>(
                            stream: Provider.of<AdminOrdersProvider>(context)
                                .orderStatusStream,
                            builder: (context, statusSnapshot) {
                              final orderStatusMap = statusSnapshot.data;
                              final orderStatus =
                                  orderStatusMap?[order.id] ?? currentStatus;

                              return DropdownButton<OrderStatus>(
                                isExpanded: true,
                                value: orderStatus,
                                items: OrderStatus.values
                                    .map((OrderStatus status) {
                                  return DropdownMenuItem<OrderStatus>(
                                    value: status,
                                    child: Text(
                                        Provider.of<AdminOrdersProvider>(
                                                context,
                                                listen: false)
                                            .getOrderStatusText(status)),
                                  );
                                }).toList(),
                                onChanged: (OrderStatus? newStatus) {
                                  if (newStatus != null) {
                                    Provider.of<AdminOrdersProvider>(context,
                                            listen: false)
                                        .updateOrderStatus(order.id, newStatus);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Id: ${order.id}'),
                        Text(
                            'Created at: ${order.createdAt.toLocal().toString()}'),
                        Text('Total: \$${order.totalAmount}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
