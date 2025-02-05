class ApiConstants {
  static const String defaultUrl = 'http://147.93.36.151:5000';
}

enum ApiEndpoints {
  // User
  login,
  createLogin,
  updateLogin,
  getUser,
  getOtherUser,
  getAllUsers,
  logout,

  // Warehouse
  warehouse,
  warehouseProducts,
  records,

  // Notification
  updateFirebaseToken,

  // Carts
  carts,
  cartDetails,
  cartUse,
  cartShutdown,
  cartMaintenance,
}

extension ApiEndpointsExtension on ApiEndpoints {
  String get path {
    switch (this) {
      case ApiEndpoints.warehouseProducts:
        return 'warehouses/{warehouseId}/products';
      case ApiEndpoints.createLogin:
        return 'create_login';
      case ApiEndpoints.updateLogin:
        return 'update_login';
      case ApiEndpoints.getUser:
        return 'get_user';
      case ApiEndpoints.getAllUsers:
        return 'get_all_users';
      case ApiEndpoints.getOtherUser:
        return 'get_user/{userName}';
      default:
        return name;
    }
  }
}
