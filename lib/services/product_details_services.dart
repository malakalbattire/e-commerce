import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';

abstract class ProductDetailsServices {
  Future<ProductItemModel> getProductDetails(String id);
  Future<void> addToCart(AddToCartModel addToCartModel);
  Future<void> updateProductStock(String productId, int newStock);
  // Future<void> fetchProductsByCategory(String category);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();
  @override
  Future<ProductItemModel> getProductDetails(String id) async =>
      await firestore.getDocument<ProductItemModel>(
          path: ApiPath.product(id),
          builder: (data, documentId) =>
              ProductItemModel.fromMap(data, documentId));

  // @override
  // Future<List<ProductItemModel>> fetchProductsByCategory(String category) async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection('products')
  //         .where('category', isEqualTo: category)
  //         .get();
  //
  //     List<ProductItemModel> products = querySnapshot.docs.map((doc) {
  //       return ProductItemModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  //     }).toList();
  //
  //     return products;
  //   } catch (e) {
  //     throw Exception('Failed to load products: $e');
  //   }
  // }
  //
  @override
  Future<void> updateProductStock(String productId, int newStock) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'inStock': newStock});
  }

  @override
  Future<void> addToCart(AddToCartModel addToCartModel) async {
    final currentUser = await authServices.getUser();
    await firestore.setData(
      path: ApiPath.addToCart(currentUser!.uid, addToCartModel.id),
      data: addToCartModel.toMap(),
    );
  }
}
