import 'dart:async';

import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class CartServices {
  Stream<List<AddToCartModel>> getCartItemsStream(String userId);
  Future<List<AddToCartModel>> getCartItems();
  Future<void> removeCartItem(String productId);
  Future<void> incrementCartItemQuantity(String id, int incrementBy);
  Future<void> decrementCartItemQuantity(String id, int decrementBy);
  Future<void> clearCart();
  Future<void> addToCart(AddToCartModel addToCartModel);
}

class CartServicesImpl implements CartServices {
  final authServices = AuthServicesImpl();
  IO.Socket? socket;

  final StreamController<List<AddToCartModel>> _cartItemsController =
      StreamController<List<AddToCartModel>>.broadcast();

  CartServicesImpl() {
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io('${BackendUrl.url}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket?.on('connect', (_) {
      print('Connected to Socket.IO server');
    });

    socket?.on('cartUpdated', (data) async {
      print('Cart updated: $data');
      final userId = await getCurrentUserId();
      _fetchAndEmitCartItems(userId);
    });

    socket?.on('cartCleared', (data) async {
      print('Cart cleared: $data');
      _cartItemsController.add([]);
    });

    socket?.on('disconnect', (_) {
      print('Disconnected from Socket.IO server');
    });
  }

  Future<String> getCurrentUserId() async {
    final currentUser = await authServices.getUser();
    if (currentUser == null) {
      throw Exception('No user is currently logged in');
    }
    return currentUser.id;
  }

  Future<void> _fetchAndEmitCartItems(String userId) async {
    final cartItems = await getCartItems();
    _cartItemsController.sink.add(cartItems);
  }

  @override
  Stream<List<AddToCartModel>> getCartItemsStream(String userId) {
    _fetchAndEmitCartItems(userId);
    return _cartItemsController.stream;
  }

  @override
  Future<List<AddToCartModel>> getCartItems() async {
    try {
      final currentUser = await authServices.getUser();
      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      final userId = currentUser.id;
      final url = Uri.parse('${BackendUrl.url}/cart/$userId');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> cartItemsJson =
            json.decode(response.body) as List<dynamic>;
        return cartItemsJson
            .map(
                (json) => AddToCartModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load cart items: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching cart items: $e');
    }
  }

  @override
  Future<void> addToCart(AddToCartModel addToCartModel) async {
    final url = Uri.parse('${BackendUrl.url}/cart');
    final body = json.encode(addToCartModel.toMap());

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add item to cart');
    }
  }

  @override
  Future<void> removeCartItem(String id) async {
    final currentUser = await authServices.getUser();
    if (currentUser == null) {
      throw Exception('No user is currently logged in');
    }

    final url = Uri.parse('${BackendUrl.url}/cart/$id');

    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete cart item');
    }
  }

  @override
  Future<void> clearCart() async {
    final currentUser = await authServices.getUser();
    if (currentUser == null) {
      throw Exception('No user is currently logged in');
    }

    final userId = currentUser.id;

    final response = await http.delete(
      Uri.parse('${BackendUrl.url}/cart/$userId/clear'),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to clear cart');
    }
  }

  @override
  Future<void> incrementCartItemQuantity(String id, int incrementBy) async {
    final response = await http.put(
      Uri.parse('${BackendUrl.url}/cart/$id/increment'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({'incrementBy': incrementBy}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to increment quantity');
    }
  }

  @override
  Future<void> decrementCartItemQuantity(String id, int decrementBy) async {
    final response = await http.put(
      Uri.parse('${BackendUrl.url}/cart/$id/decrement'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({'decrementBy': decrementBy}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to decrement quantity');
    }
  }

  void dispose() {
    _cartItemsController.close();
  }
}
