class HomeCarouselModel {
  final String id;
  final String imgUrl;

  HomeCarouselModel({required this.id, required this.imgUrl});
}

List<HomeCarouselModel> dummyCarouselItems = [
  HomeCarouselModel(
      id: '1',
      imgUrl:
          'https://i.pinimg.com/564x/da/e3/e9/dae3e91ac3fbdd1ddf94b3760cc72a53.jpg'),
  HomeCarouselModel(
    id: '2',
    imgUrl:
        'https://i.pinimg.com/564x/d0/a1/ca/d0a1ca6190a39c77380c308083c332d3.jpg',
  ),
  HomeCarouselModel(
      id: '3',
      imgUrl:
          'https://i.pinimg.com/564x/13/75/34/13753460c5554d32530e514762649cb7.jpg'),
  HomeCarouselModel(
      id: '4',
      imgUrl:
          'https://i.pinimg.com/564x/15/86/5f/15865f5bd00138f3d769a2394c07eba7.jpg'),
];
