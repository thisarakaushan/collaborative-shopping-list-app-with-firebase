// Packages
import 'package:flutter/material.dart';

// Bindings
import '../bindings/initial_binding.dart';

// App
import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Await the async dependencies to complete before running the app
  await InitialBinding().dependencies();

  runApp(MyApp());
}
