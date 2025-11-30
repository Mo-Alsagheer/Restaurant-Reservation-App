import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize notification service
  Future<void> initialize() async {
    // Request permission (iOS)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('Notification permission status: ${settings.authorizationStatus}');
    }

    // Get FCM token
    final token = await _messaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }

    // TODO: Save token to Firestore for vendor device registration

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        print('FCM Token refreshed: $newToken');
      }
      // TODO: Update token in Firestore
    });
  }

  /// Subscribe to a restaurant topic for booking notifications
  Future<void> subscribeToRestaurant(String restaurantId) async {
    final topic = 'restaurant_${restaurantId}_bookings';
    await _messaging.subscribeToTopic(topic);
    if (kDebugMode) {
      print('Subscribed to topic: $topic');
    }
  }

  /// Unsubscribe from a restaurant topic
  Future<void> unsubscribeFromRestaurant(String restaurantId) async {
    final topic = 'restaurant_${restaurantId}_bookings';
    await _messaging.unsubscribeFromTopic(topic);
    if (kDebugMode) {
      print('Unsubscribed from topic: $topic');
    }
  }

  /// Setup foreground notification handler
  void setupForegroundHandler(Function(RemoteMessage) onForegroundMessage) {
    FirebaseMessaging.onMessage.listen(onForegroundMessage);
  }

  /// Setup background notification handler
  static Future<void> backgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print('Background message: ${message.messageId}');
      print('Notification: ${message.notification?.title}');
    }
    // TODO: Handle background notification (e.g., update local database)
  }
}
