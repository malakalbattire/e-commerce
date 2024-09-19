import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class CartServices {
  Stream<List<AddToCartModel>> getCartItemsStream(String userId);
  Future<List<AddToCartModel>> getCartItems();
  Future<void> removeCartItem(String productId);
  Future<void> updateCartItem(AddToCartModel item, String productId);
  Future<void> incrementCartItemQuantity(String productId);
  Future<void> decrementCartItemQuantity(String productId);
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

  @override
  Future<void> updateCartItem(AddToCartModel item, String productId) async {
    final currentUser = await authServices.getUser();
    await firestore.setData(
      path: ApiPath.addToCart(currentUser!.uid, productId),
      data: item.toMap(),
    );
  }

  @override
  Future<void> clearCart() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final cartCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');

    final cartDocs = await cartCollection.get();
    for (var doc in cartDocs.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> incrementCartItemQuantity(String productId) async {
    final currentUser = await authServices.getUser();
    final cartItem = await firestore.getDocument(
      path: ApiPath.addToCart(currentUser!.uid, productId),
      builder: (data, documentId) => AddToCartModel.fromMap(data, documentId),
    );
    if ((cartItem.quantity) < cartItem.inStock) {
      final newQuantity = (cartItem.quantity) + 1;
      cartItem.quantity = newQuantity;
      await firestore.setData(
        path: ApiPath.addToCart(currentUser.uid, productId),
        data: cartItem.toMap(),
      );
    } else {
      print('reach limit');
    }
  }

  @override
  Future<void> decrementCartItemQuantity(String productId) async {
    final currentUser = await authServices.getUser();
    final cartItem = await firestore.getDocument(
      path: ApiPath.addToCart(currentUser!.uid, productId),
      builder: (data, documentId) => AddToCartModel.fromMap(data, documentId),
    );
    if ((cartItem.quantity) > 1) {
      final newQuantity = (cartItem.quantity) - 1;
      cartItem.quantity = newQuantity;
      await firestore.setData(
        path: ApiPath.addToCart(currentUser.uid, productId),
        data: cartItem.toMap(),
      );
    } else {
      await removeCartItem(productId);
    }
  }
}
