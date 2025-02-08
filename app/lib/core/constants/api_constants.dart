class ApiConstants {
  static const String defaultUrl = 'http://147.93.36.151:5000';
}

enum ApiEndpoints {
  // User
  login('login'),
  createLogin('create_login'),
  updateLogin('update_login'),
  getUser('get_user'),
  getOtherUser('get_user/{userName}'),
  getAllUsers('get_all_users'),
  logout('logout'),

  // Warehouse
  warehouse('warehouse'),
  warehouseProducts('warehouses/{warehouseId}/products'),
  records('get_logs'),

  // Notification
  updateFirebaseToken('updateFirebaseToken'),

  // Carts
  getCarts('get_carts'),
  cartDetails('cart_details'),
  cartUse('cart_use'),
  cartRequest('cart_request'),
  cartShutdown('cart_shutdown'),
  cartMaintenance('cart_maintenance');

  final String path;
  const ApiEndpoints(this.path);
}
