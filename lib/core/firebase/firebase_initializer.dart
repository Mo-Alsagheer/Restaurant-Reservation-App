import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../config/env_config.dart';
import '../../firebase_options.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    // Note: Run 'flutterfire configure' to generate firebase_options.dart
    // For now, we'll use a placeholder approach
    // Once you configure Firebase, import the generated file:
    // import 'firebase_options.dart';

    try {
      await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (kDebugMode) {
        print('Firebase initialized successfully for ${EnvConfig.flavor}');
      }

      // Connect to Firebase emulators in dev mode (optional)
      if (EnvConfig.isDev && kDebugMode) {
        // Uncomment when using emulators:
        // await FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
        // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        // await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Firebase: $e');
      }
      rethrow;
    }
  }
}
