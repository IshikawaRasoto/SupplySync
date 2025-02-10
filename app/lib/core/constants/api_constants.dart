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
  warehouses('warehouses'),
  warehouseProducts('warehouses/{warehouseId}'),
  records('get_logs'),

  // Notification
  updateFirebaseToken('updateFirebaseToken'),

  // Carts
  getCarts('get_carts'),
  cartDetails('cart_details/{cartId}'),
  cartUse('cart_use'),
  cartRequest('cart_request'),
  cartShutdown('cart_shutdown/{cartId}'),
  cartMaintenance('cart_maintenance/{cartId}'),

  // Warehouse Transport
  fetchIncomingDrones('warehouse/{warehouseId}/incoming-drones'),
  uploadDronePhoto('cart/{cartId}/upload_drone_photo'),
  releaseDrone('cart/{cartId}/release_cart');

  final String path;
  const ApiEndpoints(this.path);
}
