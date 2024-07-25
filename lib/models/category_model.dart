class CategoryModel {
  final String id;
  final String imgUrl;

  CategoryModel({required this.id, required this.imgUrl});
}

List<CategoryModel> dummyCategories = [
  CategoryModel(
      id: '1',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN%20%282%29-page-1.jpg'),
  CategoryModel(
      id: '2',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN%20%281%29-page-001%20%281%29.jpg'),
  CategoryModel(
      id: '3',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN-page-001.jpg'),
  CategoryModel(
      id: '4',
      imgUrl:
          'https://www.supermarketcy.com.cy/images/styles/medium/FROZEN-page-2.jpg'),
  CategoryModel(
      id: '5',
      imgUrl: 'https://www.supermarketcy.com.cy/images/styles/medium/7.jpg'),
];
