import 'package:e_commerce_app_flutter/models/order_item_model/order_item_model.dart';
import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class OrderServices {
  Future<void> createOrder(OrderModel order);
  Future<List<OrderModel>> getUserOrders(String userId);
  Stream<OrderModel> getOrderStatusStream(String userId, String orderId);
}

class OrderServicesImpl implements OrderServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  @override
  Future<void> createOrder(OrderModel order) async {
    final currentUser = await authServices.getUser();
    final String userId = currentUser!.uid;

    final url = Uri.parse('${BackendUrl.url}/orders');
    final Map<String, dynamic> body = {
      'id': order.id,
      'userId': userId,
      'items': order.items.map((item) => item.toMap()).toList(),
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
      'orderStatus': order.orderStatus?.map((status) => status.name).toList(),
    };

    try {
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
  Stream<OrderModel> getOrderStatusStream(
      String userId, String orderId) async* {
    final url = Uri.parse('${BackendUrl.url}/orders/$orderId/status');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        yield OrderModel(
          id: data['id'] ?? '',
          userId: data['userId'] ?? '',
          items: (data['items'] as List<dynamic>? ?? [])
              .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList(),
          cityName: data['cityName'] ?? '',
          productIds: List<String>.from(data['productIds'] ?? []),
          addressId: data['addressId'] ?? '',
          paymentId: data['paymentId'] ?? '',
          countryName: data['countryName'] ?? '',
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          cardNumber: data['cardNumber'] ?? '',
          totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
          createdAt:
              DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
          orderNumber: data['orderNumber'] ?? 0,
          orderStatus: (data['orderStatus'] as List<dynamic>? ?? [])
              .map((status) => OrderStatus.values.firstWhere(
                  (e) => e.toString().split('.').last == status,
                  orElse: () => OrderStatus.waitingForConfirmation))
              .toList(),
        );
      } else {
        throw Exception('Failed to fetch order status: ${response.body}');
      }
    } catch (e) {
      print('Error fetching order status: $e');
      yield OrderModel(
        id: '',
        userId: '',
        items: [],
        cityName: '',
        productIds: [],
        addressId: '',
        paymentId: '',
        countryName: '',
        firstName: '',
        lastName: '',
        phoneNumber: '',
        cardNumber: '',
        totalAmount: 0,
        createdAt: DateTime.now(),
        orderNumber: 0,
        orderStatus: [OrderStatus.waitingForConfirmation],
      );
    }
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final response =
          await http.get(Uri.parse('${BackendUrl.url}/orders?userId=$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> ordersData = json.decode(response.body);

        return ordersData
            .map<OrderModel>((data) => OrderModel.fromMap(data))
            .toList();
      } else {
        throw Exception('Failed to load user orders: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user orders: $e');
      throw e;
    }
  }
}
