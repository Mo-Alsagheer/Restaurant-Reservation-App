import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage vendor's current restaurant ID in local storage
class VendorRestaurantPrefs {
  static const String _keyRestaurantId = 'vendor.currentRestaurantId';

  /// Get the stored restaurant ID
  static Future<String?> getRestaurantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRestaurantId);
  }

  /// Save the restaurant ID
  static Future<bool> setRestaurantId(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyRestaurantId, restaurantId);
  }

  /// Clear the stored restaurant ID
  static Future<bool> clearRestaurantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_keyRestaurantId);
  }
}
