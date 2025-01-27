import 'package:flutter/material.dart';

class MainConstants {
  static const String appName = 'SupplySync';
  static const String companyName = 'SupplySync';
}

enum SecureDataKeys { userName, password }

enum DataKeys { apiUrl, companyName, savePassword }

enum UserRoles {
  none,
  admin,
  armazem,
  doca,
  manutencao,
  user,
}

enum UserPermissions {
  fetchWarehouses,
  fetchWarehouse,
  updateProfile,
  loadingDock,
  drones,
  fetchRecords,
  fetchWorkers,
}

class RolesPermissions {
  static const Map<UserRoles, List<UserPermissions>> permissions = {
    UserRoles.armazem: [
      UserPermissions.fetchWarehouse,
      UserPermissions.fetchRecords,
      UserPermissions.drones,
    ],
    UserRoles.doca: [
      UserPermissions.loadingDock,
      UserPermissions.fetchRecords,
      UserPermissions.drones,
    ],
    UserRoles.manutencao: [
      UserPermissions.fetchRecords,
      UserPermissions.drones,
    ],
    UserRoles.user: [
      UserPermissions.fetchRecords,
    ],
  };
}

class AppColors {
  static const Color primary = Color.fromARGB(255, 218, 212, 198);
  static const Color text = Colors.black;
  static const Color button = Color.fromARGB(255, 44, 44, 44);
  static const Color redButton = Color.fromARGB(255, 182, 16, 33);
  static const Color disabledButton = Color.fromARGB(255, 95, 95, 95);
  static const Color buttonText = Colors.white;
}

class AssetsConstants {
  static const String logo = 'assets/images/appIcon.png';
}
