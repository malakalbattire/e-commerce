import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class OrderServices {
  Future<void> createOrder(OrderModel order);
  Future<OrderModel> getOrder(String orderId);
  Future<void> updateOrder(OrderModel order);
  Future<void> deleteOrder(String orderId);
  Future<List<OrderModel>> getUserOrders(String userId);

  Stream<OrderModel> getOrderStatusStream(String userId, String orderId);
}

class OrderServicesImpl implements OrderServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  // @override
  // Future<void> createOrder(OrderModel order) async {
  //   final currentUser = await authServices.getUser();
  //
  //   await firestore.setData(
  //     path: ApiPath.createOrder(currentUser!.uid, order.id),
  //     data: order.toMap(),
  //   );
  // }
  @override
  Future<void> createOrder(OrderModel order) async {
    // Get the current logged-in user
    final currentUser = await authServices.getUser();
    final String userId =
        currentUser!.uid; // Assuming uid is available in currentUser

    // Set up the API endpoint and request body
    final url = Uri.parse(
        'http://192.168.88.2/orders'); // Replace with your Node.js server URL
    final Map<String, dynamic> body = {
      'id': order.id,
      'userId': userId, // Use current user's ID
      'items': order.items
          .map((item) => item.toMap())
          .toList(), // Convert order items to JSON
      'cityName': order.cityName,
      'productIds': order.productIds,
      'addressId': order.addressId,
      'paymentId': order.paymentId,
      'countryName': order.countryName,
      'firstName': order.firstName,
      'lastName': order.lastName,
      'phoneNumber': order.phoneNumber,
      'cardNumber': order.cardNumber,
      'totalAmount': order.totalAmount,
      'orderNumber': order.orderNumber,
      // Check if orderStatus is null, if not map to a list of strings (enum names)
      'orderStatus': order.orderStatus?.map((status) => status.name).toList(),
    };

    try {
      // Send the POST request to the Node.js backend
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print('Order placed successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to place order: ${response.body}');
      }
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  @override
  Future<OrderModel> getOrder(String orderId) async {
    final currentUser = await authServices.getUser();
    return await firestore.getDocument(
      path: ApiPath.createOrder(currentUser!.uid, orderId),
      builder: (data, documentId) => OrderModel.fromMap(data),
    );
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    await firestore.setData(
      path: ApiPath.createOrder(order.userId, order.id),
      data: order.toMap(),
    );
  }

  @override
  Stream<OrderModel> getOrderStatusStream(String userId, String orderId) {
    return firestore.documentStream(
      path: ApiPath.createOrder(userId, orderId),
      builder: (data, documentId) => OrderModel.fromMap(data),
    );
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    final currentUser = await authServices.getUser();
    await firestore.deleteData(
      path: ApiPath.createOrder(currentUser!.uid, orderId),
    );
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    return await firestore.getCollection(
      path: ApiPath.orderItems(userId),
      builder: (data, documentId) => OrderModel.fromMap(data),
    );
  }
}
