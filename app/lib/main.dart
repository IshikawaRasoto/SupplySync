import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: RouterMain.user)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouterMain.router,
      debugShowCheckedModeBanner: false,
      title: MainConstants.appName,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.primary,
        cardColor: AppColors.button,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          titleTextStyle: const TextStyle(
            color: AppColors.text,
            fontSize: 20,
          ),
          toolbarHeight: 50,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.button,
            foregroundColor: AppColors.buttonText,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.text,
          ),
        ),
      ),
    );
  }
}
