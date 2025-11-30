import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/firebase/firebase_initializer.dart';
import '../core/config/env_config.dart';
import '../vendor_app/vendor_app.dart';

Future<void> bootstrapVendorApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set environment (default to dev for now)
  EnvConfig.setFlavor(AppFlavor.dev);

  // Initialize Firebase
  try {
    await FirebaseInitializer.initialize();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Continue anyway for development - Firebase will be configured later
  }

  // Run the app wrapped in ProviderScope for Riverpod
  runApp(const ProviderScope(child: VendorApp()));
}
