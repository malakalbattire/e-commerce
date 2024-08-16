import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class CartServices {
  Stream<List<AddToCartModel>> getCartItemsStream();

  Future<List<AddToCartModel>> getCartItems();
  Future<void> removeCartItem(String productId);
  Future<void> updateCartItem(AddToCartModel item, String productId);
  Future<void> incrementCartItemQuantity(String productId);
  Future<void> decrementCartItemQuantity(String productId);
  Future<void> clearCart();
}

class CartServicesImpl implements CartServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  @override
  Stream<List<AddToCartModel>> getCartItemsStream() async* {
    final currentUser = await authServices.getUser();
    yield* firestore.collectionStream(
      path: ApiPath.addToCartItems(currentUser!.uid),
      builder: (data, documentId) => AddToCartModel.fromMap(data, documentId),
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
  Future<List<AddToCartModel>> getCartItems() async {
    final currentUser = await authServices.getUser();
    return await firestore.getCollection(
      path: ApiPath.addToCartItems(currentUser!.uid),
      builder: (data, documentId) => AddToCartModel.fromMap(data, documentId),
    );
  }

  @override
  Future<void> removeCartItem(String productId) async {
    final currentUser = await authServices.getUser();
    await firestore.deleteData(
      path: ApiPath.addToCart(currentUser!.uid, productId),
    );
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
