enum AppFlavor { dev, prod }

class EnvConfig {
  static AppFlavor _flavor = AppFlavor.dev;

  static AppFlavor get flavor => _flavor;

  static void setFlavor(AppFlavor flavor) {
    _flavor = flavor;
  }

  static bool get isDev => _flavor == AppFlavor.dev;
  static bool get isProd => _flavor == AppFlavor.prod;

  // Firebase project IDs (update these with your actual Firebase projects)
  static String get firebaseProjectId {
    switch (_flavor) {
      case AppFlavor.dev:
        return 'restaurant-app-dev';
      case AppFlavor.prod:
        return 'restaurant-app-prod';
    }
  }
}
