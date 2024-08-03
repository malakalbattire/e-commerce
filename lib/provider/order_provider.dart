import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/order_model.dart';
import 'package:e_commerce_app_flutter/services/order_services.dart';

enum OrderState { initial, loading, loaded, error }

class OrderProvider with ChangeNotifier {
  final orderServices = OrderServicesImpl();
  List<OrderModel> _orders = [];
  OrderState _state = OrderState.initial;
  String _errorMessage = '';

  List<OrderModel> get orders => _orders;
  OrderState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> placeOrder({
    required String userId,
    required List<String> productIds,
    required String addressId,
    required String paymentId,
    required double totalAmount,
  }) async {
    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final newOrder = OrderModel(
        id: orderId,
        userId: userId,
        productIds: productIds,
        addressId: addressId,
        paymentId: paymentId,
        totalAmount: totalAmount,
        createdAt: DateTime.now(),
      );
      await orderServices.createOrder(newOrder);
      _orders.add(newOrder);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = OrderState.error;
      notifyListeners();
    }
  }

  Future<void> loadOrders(String userId) async {
    _state = OrderState.loading;
    notifyListeners();

    try {
      _orders = await orderServices.getUserOrders(userId);
      _state = OrderState.loaded;
    } catch (error) {
      _state = OrderState.error;
      _errorMessage = error.toString();
    }
    notifyListeners();
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await orderServices.deleteOrder(orderId);
      _orders.removeWhere((order) => order.id == orderId);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = OrderState.error;
      notifyListeners();
    }
  }
}
