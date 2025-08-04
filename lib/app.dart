// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Bindings
import '../bindings/initial_binding.dart';

// Pages
import '../../presentation/pages/auth/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      initialBinding: InitialBinding(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}
