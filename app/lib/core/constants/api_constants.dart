class ApiConstants {
  static const String baseUrl = 'http://192.168.15.21:5000';
}

enum ApiEndpoints {
  login,
  createLogin,
  updateLogin,
  getUser,
  logout,
  warehouse,
  warehouseProducts,
  records,
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
      default:
        return name;
    }
  }
}
