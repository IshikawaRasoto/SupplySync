import 'package:flutter/material.dart';

class MainConstants {
  static const String appName = 'SupplySync';
  static const String companyName = 'SupplySync';
}

class AuthConstants {
  static const int minPasswordLength = 6;
}

enum SecureDataKeys { userName, password }

enum DataKeys { apiUrl, companyName, savePassword }

enum UserRoles {
  admin(AppServices.values),
  armazem([
    AppServices.fetchWarehouse,
    AppServices.fetchRecords,
    AppServices.drones,
  ]),
  doca([
    AppServices.loadingDock,
    AppServices.fetchRecords,
    AppServices.drones,
  ]),
  manutencao([
    AppServices.fetchRecords,
    AppServices.drones,
  ]),
  ;

  final List<AppServices> permissions;
  const UserRoles(this.permissions);
}

enum AppServices {
  fetchWarehouses,
  fetchWarehouse,
  updateProfile,
  loadingDock,
  drones,
  fetchRecords,
  fetchWorkers,
  newWorker,
}

extension AppServicesExtension on AppServices {
  String get name {
    switch (this) {
      case AppServices.fetchWarehouses:
        return 'Armazéns';
      case AppServices.updateProfile:
        return 'Perfil';
      case AppServices.loadingDock:
        return 'Docas';
      case AppServices.drones:
        return 'Drones';
      case AppServices.fetchRecords:
        return 'Registros';
      case AppServices.fetchWorkers:
        return 'Funcionários';
      case AppServices.newWorker:
        return 'Novo Funcionário';
      default:
        return '';
    }
  }

  String get path {
    switch (this) {
      case AppServices.fetchWarehouses:
        return '/home/warehouses';
      case AppServices.updateProfile:
        return '/home/changeprofile';
      case AppServices.loadingDock:
        return '/home/docks';
      case AppServices.drones:
        return '/home/drones';
      case AppServices.fetchRecords:
        return '/home/records';
      case AppServices.fetchWorkers:
        return '/home/workers';
      case AppServices.newWorker:
        return '/home/newworker';
      default:
        return '';
    }
  }

  IconData get icon {
    switch (this) {
      case AppServices.fetchWarehouses:
        return Icons.warehouse;
      case AppServices.updateProfile:
        return Icons.person;
      case AppServices.loadingDock:
        return Icons.local_shipping;
      case AppServices.drones:
        return Icons.drive_eta;
      case AppServices.fetchRecords:
        return Icons.receipt_long;
      case AppServices.fetchWorkers:
        return Icons.people;
      case AppServices.newWorker:
        return Icons.person_add;
      default:
        return Icons.error;
    }
  }
}

class AssetsConstants {
  static const String logo = 'assets/images/appIcon.png';
}
