import 'package:flutter/material.dart';
import 'package:food_delivery/Screens/loginScreen.dart';
import 'package:food_delivery/Screens/splashScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
