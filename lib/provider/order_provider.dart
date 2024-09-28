import 'package:e_commerce_app_flutter/models/order_item_model/order_item_model.dart';
import 'package:e_commerce_app_flutter/services/address_services.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/product_details_services.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/services/order_services.dart';
import 'package:e_commerce_app_flutter/provider/cart_provider.dart';
import 'dart:async';

enum OrderState { initial, loading, loaded, error }

class OrderProvider with ChangeNotifier {
  final OrderServicesImpl orderServices = OrderServicesImpl();
  final ProductDetailsServicesImpl productServices =
      ProductDetailsServicesImpl();
  final AddressServicesImpl addressServices = AddressServicesImpl();
  final AuthServices authServices = AuthServicesImpl();
  List<OrderModel> _orders = [];
  OrderState _state = OrderState.initial;
  String _errorMessage = '';

  List<OrderModel> get orders => _orders;
  OrderState get state => _state;
  String get errorMessage => _errorMessage;

  OrderModel? _currentOrder;
  Stream<OrderModel>? _orderStatusStream;

  OrderModel? get currentOrder => _currentOrder;

  Future<void> placeOrder({
    required String userId,
    required String addressId,
    required List<String> productIds,
    required String paymentId,
    required String cityName,
    required String countryName,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String cardNumber,
    required double totalAmount,
    required int orderNumber,
    required CartProvider cartProvider,
  }) async {
    _state = OrderState.loading;
    _errorMessage = '';
    notifyListeners();

    final currentUser = authServices.getUser();

    if (currentUser == null) {
      _errorMessage = 'You are signed out. Please sign in to place an order.';
      _state = OrderState.error;
      notifyListeners();
      return;
    }
    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      final orderItems = cartProvider.cartItems.map((cartItem) {
        return OrderItem(
          productId: cartItem.product.id,
          quantity: cartItem.quantity,
        );
      }).toList();

      final newOrder = OrderModel(
        id: orderId,
        userId: userId,
        items: orderItems,
        addressId: addressId,
        paymentId: paymentId,
        cityName: cityName,
        countryName: countryName,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        cardNumber: cardNumber,
        totalAmount: totalAmount,
        createdAt: DateTime.now(),
        orderNumber: orderNumber,
        productIds: productIds,
        orderStatus: [OrderStatus.waitingForConfirmation],
      );

      await orderServices.createOrder(newOrder);

      for (var orderItem in orderItems) {
        final product =
            await productServices.getProductDetails(orderItem.productId);

        final updatedStock = product.inStock - orderItem.quantity;

        final updatedProduct = {
          'name': product.name,
          'price': product.price,
          'description': product.description,
          'inStock': updatedStock,
        };

        await productServices.updateProductDetails(
            orderItem.productId, updatedProduct);
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

  Future<void> loadOrders(String userId) async {
    _state = OrderState.loading;
    _errorMessage = '';
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

  Stream<OrderModel>? listenToOrderStatus(String userId, String orderId) {
    _orderStatusStream = orderServices.getOrderStatusStream(userId, orderId);
    return _orderStatusStream;
  }

  void clearOrders() {
    _orders = [];
    _state = OrderState.initial;
    notifyListeners();
  }
}
