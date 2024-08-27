import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';

abstract class ProductDetailsServices {
  Future<ProductItemModel> getProductDetails(String id);
  Future<void> addToCart(AddToCartModel addToCartModel);
  Stream<List<ProductSize>> getProductSizes(String productId);
  Future<void> updateProductStock(String productId, int newStock);
  Future<void> updateProductDetails(
      String productId, Map<String, dynamic> updatedFields);

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

  @override
  Stream<List<ProductSize>> getProductSizes(String productId) {
    return FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final sizes = (data['sizes'] as List<dynamic>)
            .map((item) => ProductSize.values
                .firstWhere((size) => size.name == item as String))
            .toList();
        return sizes;
      } else {
        return [];
      }
    });
  }

  @override
  Future<void> updateProductDetails(
      String productId, Map<String, dynamic> updatedFields) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update(updatedFields);
  }
}
