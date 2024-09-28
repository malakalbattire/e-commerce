import 'dart:async';
import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/models/order_item_model/order_item_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminOrdersProvider with ChangeNotifier {
  Stream<List<OrderModel>> get ordersStream => _ordersStreamController.stream;
  final _ordersStreamController =
      StreamController<List<OrderModel>>.broadcast();

  final _orderStatusStreamController =
      StreamController<Map<String, OrderStatus>>.broadcast();

  Stream<Map<String, OrderStatus>> get orderStatusStream =>
      _orderStatusStreamController.stream;

  AdminOrdersProvider() {
    _initializeOrdersStream();
  }
  void _initializeOrdersStream() async {
    final baseUrl = '${BackendUrl.url}/orders';

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> ordersData = json.decode(response.body);

        final Map<String, OrderModel> ordersMap = {};

        for (var orderData in ordersData) {
          var itemsData = orderData['items'] as List<dynamic>?;

          List<OrderItem> items = itemsData != null
              ? itemsData.map((item) {
                  return OrderItem.fromMap(item as Map<String, dynamic>);
                }).toList()
              : [];

          var statusData = orderData['orderStatus'];
          List<OrderStatus> orderStatus = [];
          if (statusData is List) {
            orderStatus = statusData
                .map((status) => OrderStatus.values.firstWhere(
                      (e) => e.name == status,
                      orElse: () => OrderStatus.waitingForConfirmation,
                    ))
                .toList();
          } else {
            if (kDebugMode) {
              print("can not get orders");
            }
            orderStatus = [OrderStatus.waitingForConfirmation];
          }

          var order = OrderModel(
            id: orderData['id'].toString(),
            userId: orderData['userId'].toString(),
            items: items,
            cityName: orderData['cityName'] as String? ?? '',
            productIds: List<String>.from(orderData['productIds'] ?? []),
            addressId: orderData['addressId'] as String? ?? '',
            paymentId: orderData['paymentId'] as String? ?? '',
            countryName: orderData['countryName'] as String? ?? '',
            firstName: orderData['firstName'] as String? ?? '',
            lastName: orderData['lastName'] as String? ?? '',
            phoneNumber: orderData['phoneNumber'] as String? ?? '',
            cardNumber: orderData['cardNumber'] as String? ?? '',
            totalAmount: (orderData['totalAmount'] as num?)?.toDouble() ?? 0.0,
            createdAt: DateTime.parse(
                orderData['createdAt'] ?? DateTime.now().toString()),
            orderNumber: orderData['orderNumber'] as int? ?? 0,
            orderStatus: orderStatus,
          );

          ordersMap[order.id] = order;

          if (orderStatus.isNotEmpty) {
            _orderStatusStreamController.add({order.id: orderStatus.last});
          }
        }

        _ordersStreamController.add(ordersMap.values.toList());
      } else {
        throw Exception('Failed to load orders: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching orders: $e');
      }
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final url = Uri.parse('${BackendUrl.url}/orders/$orderId/orderStatus');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'orderStatus': [newStatus.name],
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Order status updated successfully.');
        }
      } else if (response.statusCode == 404) {
        if (kDebugMode) {
          print('Order not found.');
        }
      } else {
        if (kDebugMode) {
          print('Failed to update order status: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating order status: $error');
      }
    }
  }

  String getOrderStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.waitingForConfirmation:
        return 'Waiting for Confirmation';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown Status';
    }
  }

  @override
  void dispose() {
    _ordersStreamController.close();
    _orderStatusStreamController.close();
    super.dispose();
  }
}
