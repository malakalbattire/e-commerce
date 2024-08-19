import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';

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

  @override
  Future<void> createOrder(OrderModel order) async {
    final currentUser = await authServices.getUser();

    await firestore.setData(
      path: ApiPath.createOrder(currentUser!.uid, order.id),
      data: order.toMap(),
    );
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
