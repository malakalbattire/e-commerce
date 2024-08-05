class CategoryModel {
  final String name;
  final String imgUrl;

  CategoryModel({required this.name, required this.imgUrl});
}

List<CategoryModel> categories = [
  CategoryModel(
      name: 'Drinks',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN%20%282%29-page-1.jpg'),
  CategoryModel(
      name: 'Chips',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN%20%281%29-page-001%20%281%29.jpg'),
  CategoryModel(
      name: 'Makeup',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN-page-001.jpg'),
];
