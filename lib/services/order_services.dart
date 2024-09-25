import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class OrderServices {
  Future<void> createOrder(OrderModel order);
  Future<void> updateOrder(OrderModel order);
  Future<void> deleteOrder(String orderId);
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
    try {
      final response =
          await http.get(Uri.parse('${BackendUrl.url}/orders/$userId'));

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
