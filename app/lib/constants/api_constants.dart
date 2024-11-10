// ignore_for_file: constant_identifier_names

class ApiConstants {
  static const String baseUrl = '';
}

enum ApiBodyParts {
  username,
  password,
  new_password,
  jwt_token,
  email,
  name,
  roles,
}

enum ApiEndpoints {
  login,
  user,
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
