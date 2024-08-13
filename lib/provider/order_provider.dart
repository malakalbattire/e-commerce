// import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
// import 'package:e_commerce_app_flutter/models/order_item_model.dart';
// import 'package:e_commerce_app_flutter/services/address_services.dart';
// import 'package:e_commerce_app_flutter/services/product_details_services.dart';
// import 'package:flutter/foundation.dart';
// import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
// import 'package:e_commerce_app_flutter/services/order_services.dart';
// import 'package:e_commerce_app_flutter/provider/cart_provider.dart';
//
// enum OrderState { initial, loading, loaded, error }
//
// class OrderProvider with ChangeNotifier {
//   final OrderServicesImpl orderServices = OrderServicesImpl();
//   final ProductDetailsServicesImpl productServices =
//       ProductDetailsServicesImpl();
//   final AddressServicesImpl addressServices = AddressServicesImpl();
//
//   List<OrderModel> _orders = [];
//   OrderState _state = OrderState.initial;
//   String _errorMessage = '';
//   Map<String, AddressModel> _addressCache = {};
//
//   List<OrderModel> get orders => _orders;
//   OrderState get state => _state;
//   String get errorMessage => _errorMessage;
//
//   Future<void> placeOrder({
//     required String userId,
//     required String addressId,
//     required List<String> productIds,
//     required String paymentId,
//     required String cityName,
//     required String countryName,
//     required String firstName,
//     required String lastName,
//     required String phoneNumber,
//     required String cardNumber,
//     required double totalAmount,
//     required int orderNumber,
//     required CartProvider cartProvider,
//   }) async {
//     _state = OrderState.loading;
//     _errorMessage = '';
//     notifyListeners();
//
//     try {
//       final orderId = DateTime.now().millisecondsSinceEpoch.toString();
//
//       final orderItems = cartProvider.cartItems.map((cartItem) {
//         return OrderItem(
//           productId: cartItem.product.id,
//           quantity: cartItem.quantity,
//         );
//       }).toList();
//
//       final newOrder = OrderModel(
//         id: orderId,
//         userId: userId,
//         items: orderItems,
//         addressId: addressId,
//         paymentId: paymentId,
//         cityName: cityName,
//         countryName: countryName,
//         firstName: firstName,
//         lastName: lastName,
//         phoneNumber: phoneNumber,
//         cardNumber: cardNumber,
//         totalAmount: totalAmount,
//         createdAt: DateTime.now(),
//         orderNumber: orderNumber,
//         productIds: productIds,
//       );
//
//       await orderServices.createOrder(newOrder);
//
//       for (var cartItem in cartProvider.cartItems) {
//         await _updateProductInStock(cartItem.product.id, cartItem.quantity);
//       }
//
//       _orders.add(newOrder);
//       _state = OrderState.loaded;
//       notifyListeners();
//     } catch (error) {
//       _errorMessage = error.toString();
//       _state = OrderState.error;
//       notifyListeners();
//     }
//   }
//
//   Future<AddressModel?> getAddressDetails(String addressId) async {
//     if (_addressCache.containsKey(addressId)) {
//       return _addressCache[addressId];
//     }
//     try {
//       final address = await addressServices.getAddressById(addressId);
//       _addressCache[addressId] = address;
//       return address;
//     } catch (error) {
//       _errorMessage = error.toString();
//       _state = OrderState.error;
//       notifyListeners();
//       return null;
//     }
//   }
//
//   Future<void> _updateProductInStock(String productId, int quantity) async {
//     try {
//       final product = await productServices.getProductDetails(productId);
//       final updatedStock = product.inStock - quantity;
//       await productServices.updateProductStock(productId, updatedStock);
//     } catch (error) {
//       _errorMessage = error.toString();
//       _state = OrderState.error;
//       notifyListeners();
//     }
//   }
//
//   Future<void> loadOrders(String userId) async {
//     _state = OrderState.loading;
//     _errorMessage = '';
//     notifyListeners();
//
//     try {
//       _orders = await orderServices.getUserOrders(userId);
//       _state = OrderState.loaded;
//     } catch (error) {
//       _state = OrderState.error;
//       _errorMessage = error.toString();
//     }
//     notifyListeners();
//   }
//
//   void clearOrders() {
//     _orders = [];
//     _state = OrderState.initial;
//     notifyListeners();
//   }
//
//   Future<void> deleteOrder(String orderId) async {
//     try {
//       await orderServices.deleteOrder(orderId);
//       _orders.removeWhere((order) => order.id == orderId);
//       notifyListeners();
//     } catch (error) {
//       _errorMessage = error.toString();
//       _state = OrderState.error;
//       notifyListeners();
//     }
//   }
// }
import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/models/order_item_model.dart';
import 'package:e_commerce_app_flutter/services/address_services.dart';
import 'package:e_commerce_app_flutter/services/product_details_services.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:e_commerce_app_flutter/services/order_services.dart';
import 'package:e_commerce_app_flutter/provider/cart_provider.dart';

enum OrderState { initial, loading, loaded, error }

class OrderProvider with ChangeNotifier {
  final OrderServicesImpl orderServices = OrderServicesImpl();
  final ProductDetailsServicesImpl productServices =
      ProductDetailsServicesImpl();
  final AddressServicesImpl addressServices = AddressServicesImpl();

  List<OrderModel> _orders = [];
  OrderState _state = OrderState.initial;
  String _errorMessage = '';
  Map<String, AddressModel> _addressCache = {};

  List<OrderModel> get orders => _orders;
  OrderState get state => _state;
  String get errorMessage => _errorMessage;

  /// Places an order and updates the product stock.
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

  /// Retrieves address details, using cached data if available.
  Future<AddressModel?> getAddressDetails(String addressId) async {
    if (_addressCache.containsKey(addressId)) {
      return _addressCache[addressId];
    }
    try {
      final address = await addressServices.getAddressById(addressId);
      _addressCache[addressId] = address;
      return address;
    } catch (error) {
      _errorMessage = error.toString();
      _state = OrderState.error;
      notifyListeners();
      return null;
    }
  }

  /// Updates the product stock after an order is placed.
  Future<void> _updateProductInStock(String productId, int quantity) async {
    try {
      final product = await productServices.getProductDetails(productId);
      final updatedStock = product.inStock - quantity;
      await productServices.updateProductStock(productId, updatedStock);
    } catch (error) {
      _errorMessage = error.toString();
      _state = OrderState.error;
      notifyListeners();
    }
  }

  /// Loads orders for a specific user.
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

  /// Clears the list of orders and resets the state.
  void clearOrders() {
    _orders = [];
    _state = OrderState.initial;
    notifyListeners();
  }

  /// Deletes an order by its ID.
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
