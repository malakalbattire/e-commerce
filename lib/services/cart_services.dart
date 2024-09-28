import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
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
  final authServices = AuthServicesImpl();

  @override
  Future<void> addToCart(AddToCartModel addToCartModel) async {
    final url = Uri.parse('${BackendUrl.url}/cart');
    final body = json.encode(addToCartModel.toMap());
    if (kDebugMode) {
      print("Sending request to $url with body: $body");
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 201) {
      if (kDebugMode) {
        print("Response: ${response.statusCode} - ${response.body}");
      }
      throw Exception('Failed to add item to cart');
    }
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

      if (kDebugMode) {
        print('Fetching cart items from: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final List<dynamic> cartItemsJson =
            json.decode(response.body) as List<dynamic>;
        if (kDebugMode) {
          print('Decoded cart items JSON: $cartItemsJson');
        }
        return cartItemsJson
            .map(
                (json) => AddToCartModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load cart items: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching cart items: $e');
      }
      throw Exception('Error fetching cart items: $e');
    }
  }

  @override
  Stream<List<AddToCartModel>> getCartItemsStream(String userId) {
    return Stream.periodic(Duration(seconds: 10), (_) async {
      try {
        final url = Uri.parse('${BackendUrl.url}/cart/$userId');

        if (url == null) {
          throw Exception('Constructed URL is null');
        }

        if (kDebugMode) {
          print('Fetching cart items from: $url');
        }

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
        if (kDebugMode) {
          print('Error fetching cart items: $e');
        }
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

      final url = Uri.parse('${BackendUrl.url}/cart/$id');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Cart item deleted successfully');
        }
      } else {
        if (kDebugMode) {
          print('Failed to delete cart item: ${response.reasonPhrase}');
        }
        throw Exception('Failed to delete cart item');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing cart item: $e');
      }
      throw Exception('Error removing cart item: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    final currentUser = await authServices.getUser();
    if (currentUser == null) {
      throw Exception('No user is currently logged in');
    }

    final userId = currentUser.id;

    try {
      final response = await http.delete(
        Uri.parse('${BackendUrl.url}/cart/$userId/clear'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Cart cleared successfully');
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        final errorMessage = errorResponse['message'] ?? 'Unknown error';
        if (kDebugMode) {
          print('Failed to clear cart: $errorMessage');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cart: $e');
      }
    }
  }

  @override
  Future<void> incrementCartItemQuantity(String id, int incrementBy) async {
    if (kDebugMode) {
      print("======$id=======");
    }
    try {
      final response = await http.put(
        Uri.parse('${BackendUrl.url}/cart/$id/increment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'incrementBy': incrementBy,
        }),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Quantity incremented');
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          final errorMessage = errorResponse['message'] ?? 'Unknown error';
          final serverError = errorResponse['error'] ?? 'No additional info';
          if (kDebugMode) {
            print(
                'Failed to increment quantity: $errorMessage. Server error: $serverError');
          }
        } catch (jsonError) {
          if (kDebugMode) {
            print('Error parsing error response: ${response.body}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
    }
  }

  @override
  Future<void> decrementCartItemQuantity(String id, int decrementBy) async {
    if (kDebugMode) {
      print("======$id=======");
    }
    try {
      final response = await http.put(
        Uri.parse('${BackendUrl.url}/cart/$id/decrement'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'decrementBy': decrementBy,
        }),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Quantity decremented');
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          final errorMessage = errorResponse['message'] ?? 'Unknown error';
          final serverError = errorResponse['error'] ?? 'No additional info';
          if (kDebugMode) {
            print(
                'Failed to decrement quantity: $errorMessage. Server error: $serverError');
          }
        } catch (jsonError) {
          if (kDebugMode) {
            print('Error parsing error response: ${response.body}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
    }
  }
}
