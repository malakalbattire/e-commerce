class ApiPath {
  static String user(String id) => 'users/$id';
  static String products() => 'products/';
  static String carousel() => 'carousel/';
  static String product(String documentId) => 'products/$documentId';
  static String addToCart(String uid, String cartId) =>
      'users/$uid/cart/$cartId';
  static String addToCartItems(String uid) => 'users/$uid/cart/';

  static String addToFavorites(String uid, String favoritesId) =>
      'users/$uid/favorites/$favoritesId';
  static String addToFavoritesItems(String uid) => 'users/$uid/favorites/';
  static String addAddress(String uid, String addressId) =>
      'users/$uid/address/$addressId';
  static String addAddressItems(String uid) => 'users/$uid/address/';
  static String addPaymentCard(String uid, String paymentMethodId) =>
      'users/$uid/cards/$paymentMethodId';
  static String addPaymentCardItems(String uid) => 'users/$uid/cards/';

  static String createOrder(String uid, String orderId) =>
      'users/$uid/orders/$orderId';
  static String orderItems(String uid) => 'users/$uid/orders/';
}
