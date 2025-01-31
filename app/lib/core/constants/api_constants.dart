// ignore_for_file: constant_identifier_names

class ApiConstants {
  static const String baseUrl = '';
}

enum ApiEndpoints {
  login,
  create_login,
  update_login,
  get_user,
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
      default:
        return name;
    }
  }
}
