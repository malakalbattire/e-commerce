class ApiPath {
  static String user(String id) => 'users/$id';
  static String products() => 'products/';
  static String carousel() => 'carousel/';
  static String product(String documentId) => 'products/$documentId';
  static String addToCart(String uid, String cartId) =>
      'users/$uid/cart/$cartId';
  static String addToCartItems(String uid) => 'users/$uid/cart/';
  static String favorites(String uid) => 'users/$uid/favorites/';
}
