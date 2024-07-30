import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';

abstract class FavoritesServices {
  Future<ProductItemModel> getProductDetails(String id);
  Future<void> addToFav(FavoriteModel addToFavModel);
  Future<void> removeFromFav(String productId);
  Future<List<FavoriteModel>> getFavItems();
}

class FavServicesIpl implements FavoritesServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  @override
  Future<void> addToFav(FavoriteModel addToFavModel) async {
    final currentUser = await authServices.getUser();
    return await firestore.setData(
      path: ApiPath.addToFavorites(currentUser!.uid, addToFavModel.id),
      data: addToFavModel.toMap(),
    );
  }

  @override
  Future<void> removeFromFav(String productId) async {
    final currentUser = await authServices.getUser();
    await firestore.deleteData(
      path: ApiPath.addToFavorites(currentUser!.uid, productId),
    );
  }

  @override
  Future<ProductItemModel> getProductDetails(String id) async {
    return await firestore.getDocument<ProductItemModel>(
        path: ApiPath.product(id),
        builder: (data, documentId) =>
            ProductItemModel.fromMap(data, documentId));
  }

  @override
  Future<List<FavoriteModel>> getFavItems() async {
    final currentUser = await authServices.getUser();
    return await firestore.getCollection(
      path: ApiPath.addToFavoritesItems(currentUser!.uid),
      builder: (data, documentId) => FavoriteModel.fromMap(data, documentId),
    );
  }
}
