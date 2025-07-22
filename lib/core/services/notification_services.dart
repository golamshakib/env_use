import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('FCM Background: ${message.notification?.title}');
}

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static String? _fcmToken;
  static String? get fcmToken => _fcmToken;

  /// Initialize Push Notification Service
  Future<void> initialize() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log("iOS permission status: ${settings.authorizationStatus}");

    // Set foreground presentation for iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Get FCM Token
    _fcmToken = await _firebaseMessaging.getToken();
    log("FCM Token: $_fcmToken");

    // Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      _fcmToken = token;
      log("FCM Token refreshed: $token");
    });

    /// Initialize Local Notification Settings
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Notification clicked with payload: ${response.payload}");
        // Handle local tap navigation here if needed
      },
    );

    /// Handle Foreground Notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground message: ${message.notification?.title}");
      _showNotification(message);
    });

    /// Handle Background Notification Tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Tapped notification while app was in background.");
      // _navigateToScreen(message);
    });

    /// Handle Notification Tap From Terminated State
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log("Tapped notification from terminated state.");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // _navigateToScreen(message);
        });
      }
    });
  }

  /// Show Local Notification
  Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'General notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'You have a new message',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

// /// Navigate to a widgets when tapping a notification
// void _navigateToScreen(RemoteMessage message) {
//   navigatorKey.currentState?.push(
//     MaterialPageRoute(
//       builder: (context) => const EnterPriseNotificationScreen(),
//     ),
//   );
// }
}