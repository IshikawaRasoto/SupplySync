import 'package:flutter/material.dart';

class MainConstants {
  static const String appName = 'SupplySync';
  static const String companyName = 'SupplySync';
}

class AuthConstants {
  static const int minPasswordLength = 6;
}

enum DataKeys { apiUrl, companyName, savePassword }

enum UserRoles {
  admin(AppServices.values),
  armazem([
    AppServices.fetchWarehouses,
    AppServices.fetchRecords,
    AppServices.loadingWarehouses,
    AppServices.updateProfile
  ]),
  doca([
    AppServices.loadingDock,
    AppServices.fetchRecords,
    AppServices.updateProfile
  ]),
  manutencao([
    AppServices.fetchRecords,
    AppServices.carts,
    AppServices.updateProfile,
  ]),
  ;

  final List<AppServices> permissions;
  const UserRoles(this.permissions);
}

enum AppServices {
  fetchWarehouses('Armazéns', '/home/warehouses', Icons.warehouse),
  updateProfile('Perfil', '/home/changeprofile', Icons.person),
  loadingDock('Docas', '/home/docksTransport', Icons.local_shipping),
  loadingWarehouses(
      'Drones Chegando', '/home/warehouseTransport', Icons.flight_land),
  carts('Drones', '/home/carts', Icons.drive_eta),
  fetchRecords('Registros', '/home/records', Icons.receipt_long),
  fetchWorkers('Funcionários', '/home/workers', Icons.people),
  newWorker('Novo Funcionário', '/home/registeruser', Icons.person_add);

  final String name;
  final String path;
  final IconData icon;

  const AppServices(this.name, this.path, this.icon);
}

class AssetsConstants {
  static const String logo = 'assets/icon/app_icon.png';
}
