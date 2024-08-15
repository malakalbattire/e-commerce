import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/models/order_item_model.dart';

class AdminOrdersProvider with ChangeNotifier {
  Stream<List<OrderModel>> get ordersStream => _ordersStreamController.stream;

  final _ordersStreamController =
      StreamController<List<OrderModel>>.broadcast();

  AdminOrdersProvider() {
    _initializeOrdersStream();
  }

  void _initializeOrdersStream() {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((userSnapshot) {
      List<OrderModel> loadedOrders = [];
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
              );

              loadedOrders.add(order);
            }
          }
          _ordersStreamController.add(loadedOrders);
        });
      }
    });
  }

  @override
  void dispose() {
    _ordersStreamController.close();
    super.dispose();
  }
}
