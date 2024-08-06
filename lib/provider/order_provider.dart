import 'package:e_commerce_app_flutter/services/product_details_services.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/services/order_services.dart';
import 'package:e_commerce_app_flutter/provider/cart_provider.dart';

enum OrderState { initial, loading, loaded, error }

class OrderProvider with ChangeNotifier {
  final orderServices = OrderServicesImpl();
  final productServices = ProductDetailsServicesImpl();
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
    required CartProvider cartProvider,
  }) async {
    _state = OrderState.loading;
    notifyListeners();

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

      for (var cartItem in cartProvider.cartItems) {
        await _updateProductInStock(cartItem.product.id, cartItem.quantity);
      }

      _orders.add(newOrder);
      _state = OrderState.loaded;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = OrderState.error;
      notifyListeners();
    }
  }

  Future<void> _updateProductInStock(String productId, int quantity) async {
    try {
      final product = await productServices.getProductDetails(productId);

      if (product != null) {
        final updatedStock = product.inStock - quantity;

        await productServices.updateProductStock(productId, updatedStock);
      }
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
