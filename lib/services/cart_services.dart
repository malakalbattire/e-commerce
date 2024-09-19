import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();
  final String backendUrl = 'http://192.168.88.10:3000';

  @override
  Future<void> addToCart(AddToCartModel addToCartModel) async {
    final url = Uri.parse('$backendUrl/cart');
    final body = json.encode(addToCartModel.toMap());
    print("Sending request to $url with body: $body");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 201) {
      print("Response: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to add item to cart');
    }
  }

  @override
  Future<List<AddToCartModel>> getCartItems() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      final userId = currentUser.uid;
      final url = Uri.parse('$backendUrl/cart/$userId');

      print('Fetching cart items from: $url');

      final response = await http.get(url);

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> cartItemsJson =
            json.decode(response.body) as List<dynamic>;
        print('Decoded cart items JSON: $cartItemsJson');
        return cartItemsJson
            .map(
                (json) => AddToCartModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load cart items: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      throw Exception('Error fetching cart items: $e');
    }
  }

  @override
  Stream<List<AddToCartModel>> getCartItemsStream(String userId) {
    return Stream.periodic(Duration(seconds: 10), (_) async {
      try {
        final url = Uri.parse('$backendUrl/cart/$userId');

        if (url == null) {
          throw Exception('Constructed URL is null');
        }

        print('Fetching cart items from: $url');

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> cartItemsJson =
              json.decode(response.body) as List<dynamic>;
          return cartItemsJson
              .map((json) =>
                  AddToCartModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
              'Failed to load cart items: ${response.reasonPhrase}');
        }
      } catch (e) {
        print('Error fetching cart items: $e');
        throw Exception('Error fetching cart items: $e');
      }
    }).asyncMap((event) => event);
  }

  @override
  Future<void> removeCartItem(String id) async {
    try {
      final currentUser = await authServices.getUser();
      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      final url = Uri.parse('$backendUrl/cart/$id');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Cart item deleted successfully');
      } else {
        print('Failed to delete cart item: ${response.reasonPhrase}');
        throw Exception('Failed to delete cart item');
      }
    } catch (e) {
      print('Error removing cart item: $e');
      throw Exception('Error removing cart item: $e');
    }
  }

  Future<void> clearCart() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final response = await http.delete(
        Uri.parse('$backendUrl/cart/$userId/clear'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print('Cart cleared successfully');
      } else {
        final errorResponse = jsonDecode(response.body);
        final errorMessage = errorResponse['message'] ?? 'Unknown error';
        print('Failed to clear cart: $errorMessage');
      }
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  @override
  Future<void> incrementCartItemQuantity(String id, int incrementBy) async {
    print("======${id}=======");
    try {
      final response = await http.put(
        Uri.parse('$backendUrl/cart/$id/increment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'incrementBy': incrementBy,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Quantity incremented');
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          final errorMessage = errorResponse['message'] ?? 'Unknown error';
          final serverError = errorResponse['error'] ?? 'No additional info';
          print(
              'Failed to increment quantity: $errorMessage. Server error: $serverError');
        } catch (jsonError) {
          print('Error parsing error response: ${response.body}');
        }
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  @override
  Future<void> decrementCartItemQuantity(String id, int decrementBy) async {
    print("======${id}=======");
    try {
      final response = await http.put(
        Uri.parse('$backendUrl/cart/$id/decrement'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'decrementBy': decrementBy,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Quantity decremented');
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          final errorMessage = errorResponse['message'] ?? 'Unknown error';
          final serverError = errorResponse['error'] ?? 'No additional info';
          print(
              'Failed to decrement quantity: $errorMessage. Server error: $serverError');
        } catch (jsonError) {
          print('Error parsing error response: ${response.body}');
        }
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }
}
