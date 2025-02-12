import 'package:flutter/material.dart';

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;
}
