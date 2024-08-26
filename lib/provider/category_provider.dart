import 'package:e_commerce_app_flutter/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [
    CategoryModel(
      name: 'Drinks',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN%20%282%29-page-1.jpg',
    ),
    CategoryModel(
      name: 'Chips',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN%20%281%29-page-001%20%281%29.jpg',
    ),
    CategoryModel(
      name: 'Makeup',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN-page-001.jpg',
    ),
  ];

  List<CategoryModel> get categories => _categories;

  void selectCategory(BuildContext context, String categoryName) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.productsList,
      arguments: categoryName,
    );
  }
}
