import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/order_tile_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/order_provider.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  String? lastUserId;
  final AuthServices _authServices = AuthServicesImpl();

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return FutureBuilder<UserData?>(
      future: _authServices.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const SigninSignoutWidget();
        }

        final currentUserId = snapshot.data!.id;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (orderProvider.state == OrderState.initial ||
            currentUserId != lastUserId) {
          lastUserId = currentUserId;
          orderProvider.clearOrders();
          orderProvider.loadOrders(currentUserId);
        }
        });

        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pushNamed(AppRoutes.home);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('My Orders'),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await orderProvider.loadOrders(currentUserId);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      if (orderProvider.state == OrderState.loading)
                        const CircularProgressIndicator.adaptive()
                      else if (orderProvider.state == OrderState.error)
                        const SigninSignoutWidget()
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
          ),
        );
      },
    );
  }
}

extension DateFormat on DateTime {
  String toShortDateString() {
    return '$day/$month/$year';
  }
}
