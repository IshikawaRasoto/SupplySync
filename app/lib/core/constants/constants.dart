class MainConstants {
  static const String appName = 'SupplySync';
  static const String companyName = 'SupplySync';
}

enum SecureDataKeys { userName, password }

enum DataKeys { apiUrl, companyName, savePassword }

enum UserRoles {
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

class AssetsConstants {
  static const String logo = 'assets/images/appIcon.png';
}
