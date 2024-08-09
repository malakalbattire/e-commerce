import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';

abstract class FavoritesServices {
  Future<ProductItemModel> getProductDetails(String id);
  Future<void> addToFav(FavoriteModel addToFavModel);
  Future<void> removeFromFav(String productId);
  Future<List<FavoriteModel>> getFavItems(String userId);
  Stream<List<FavoriteModel>> getFavItemsStream(String userId);
}

class FavServicesImpl implements FavoritesServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  Future<String> _getCurrentUserId() async {
    final currentUser = await authServices.getUser();
    if (currentUser == null) {
      throw Exception('No user is signed in.');
    }
    return currentUser.uid;
  }

  @override
  Future<void> addToFav(FavoriteModel addToFavModel) async {
    final userId = await _getCurrentUserId();
    return await firestore.setData(
      path: ApiPath.addToFavorites(userId, addToFavModel.id),
      data: addToFavModel.toMap(),
    );
  }

  @override
  Future<void> removeFromFav(String productId) async {
    final userId = await _getCurrentUserId();
    return await firestore.deleteData(
      path: ApiPath.addToFavorites(userId, productId),
    );
  }

  @override
  Future<ProductItemModel> getProductDetails(String id) async {
    return await firestore.getDocument<ProductItemModel>(
      path: ApiPath.product(id),
      builder: (data, documentId) => ProductItemModel.fromMap(data, documentId),
    );
  }

  @override
  Future<List<FavoriteModel>> getFavItems(String userId) async {
    return await firestore.getCollection(
      path: ApiPath.addToFavoritesItems(userId),
      builder: (data, documentId) => FavoriteModel.fromMap(data, documentId),
    );
  }

  @override
  Stream<List<FavoriteModel>> getFavItemsStream(String userId) {
    return firestore.collectionStream(
      path: ApiPath.addToFavoritesItems(userId),
      builder: (data, documentId) => FavoriteModel.fromMap(data, documentId),
    );
  }
}
