import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/models/order_item_model/order_item_model.dart';

class AdminOrdersProvider with ChangeNotifier {
  // Existing orders stream controller
  Stream<List<OrderModel>> get ordersStream => _ordersStreamController.stream;
  final _ordersStreamController =
      StreamController<List<OrderModel>>.broadcast();

  // New stream controller for order status updates
  final _orderStatusStreamController =
      StreamController<Map<String, OrderStatus>>.broadcast();

  Stream<Map<String, OrderStatus>> get orderStatusStream =>
      _orderStatusStreamController.stream;

  AdminOrdersProvider() {
    _initializeOrdersStream();
  }

  void _initializeOrdersStream() {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((userSnapshot) {
      final Map<String, OrderModel> ordersMap = {};

      for (var userDoc in userSnapshot.docs) {
        String userId = userDoc.id;

        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('orders')
            .snapshots()
            .listen((orderSnapshot) {
          for (var orderDoc in orderSnapshot.docs) {
            var orderData = orderDoc.data() as Map<String, dynamic>?;

            if (orderData != null) {
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
                orderStatus = [OrderStatus.waitingForConfirmation];
              }

              var order = OrderModel(
                id: orderDoc.id,
                userId: userId,
                items: items,
                cityName: orderData['cityName'] as String? ?? '',
                productIds: List<String>.from(
                    orderData['productIds'] as List<dynamic>? ?? []),
                addressId: orderData['addressId'] as String? ?? '',
                paymentId: orderData['paymentId'] as String? ?? '',
                countryName: orderData['countryName'] as String? ?? '',
                firstName: orderData['firstName'] as String? ?? '',
                lastName: orderData['lastName'] as String? ?? '',
                phoneNumber: orderData['phoneNumber'] as String? ?? '',
                cardNumber: orderData['cardNumber'] as String? ?? '',
                totalAmount:
                    (orderData['totalAmount'] as num?)?.toDouble() ?? 0.0,
                createdAt: (orderData['createdAt'] as Timestamp?)?.toDate() ??
                    DateTime.now(),
                orderNumber: orderData['orderNumber'] as int? ?? 0,
                orderStatus: orderStatus,
              );

              ordersMap[order.id] = order;

              // Emit the current status for the order
              if (orderStatus.isNotEmpty) {
                _orderStatusStreamController.add({order.id: orderStatus.last});
              }
            }
          }

          _ordersStreamController.add(ordersMap.values.toList());
        });
      }
    });
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userDocs = await usersCollection.get();

      for (var userDoc in userDocs.docs) {
        final userId = userDoc.id;
        final ordersCollection =
            usersCollection.doc(userId).collection('orders');
        final orderDoc = await ordersCollection.doc(orderId).get();

        if (orderDoc.exists) {
          final currentData = orderDoc.data();
          if (currentData != null && currentData['orderStatus'] is List) {
            final List<dynamic> statusList = currentData['orderStatus'];
            if (statusList.isNotEmpty) {
              // Replace the last status with the new status
              statusList[statusList.length - 1] = newStatus.name;
            } else {
              statusList.add(newStatus.name);
            }
            await orderDoc.reference.update({
              'orderStatus': statusList,
            });

            // Emit the updated status for the order
            _orderStatusStreamController.add({orderId: newStatus});
          }
        }
      }
    } catch (error) {
      print('Failed to update order status: $error');
    }
  }

  Stream<OrderStatus> getOrderStatusStream(String orderId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(orderId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data != null && data['orderStatus'] is List) {
        final statusList = data['orderStatus'] as List;
        return OrderStatus.values.firstWhere(
          (e) => e.name == statusList.last,
          orElse: () => OrderStatus.waitingForConfirmation,
        );
      } else {
        return OrderStatus.waitingForConfirmation;
      }
    });
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
