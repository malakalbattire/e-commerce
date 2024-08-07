import 'package:e_commerce_app_flutter/views/widgets/order_tile_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/order_provider.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (orderProvider.state == OrderState.initial) {
        orderProvider.loadOrders(currentUser!.uid);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await orderProvider.loadOrders(currentUser!.uid);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                if (orderProvider.state == OrderState.loading)
                  const CircularProgressIndicator.adaptive()
                else if (orderProvider.state == OrderState.error ||
                    currentUser == null)
                  SigninSignoutWidget()
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

extension DateFormat on DateTime {
  String toShortDateString() {
    return '$day/$month/$year';
  }
}
