import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_cloud_messaging_repository.g.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  printDebug("=====> Handling a background message: ${message.messageId}");

  // For background messages on Android, let the system handle the notification
  // Don't show a local notification
  if (Platform.isAndroid) {
    return;
  }

  // The rest of the handler is for iOS background notifications if needed
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true, // Added playSound
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);

  if (message.notification != null) {
    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true, // Added playSound
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          sound: 'default',
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
    );
  }
}

@riverpod
FirebaseCloudMessagingRepo notificationRepository(Ref ref) {
  return FirebaseCloudMessagingRepo();
}

class FirebaseCloudMessagingRepo {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Set background message handler first
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: true, // Added critical alert permission
    );

    printDebug(
        '=====> User granted permission: ${settings.authorizationStatus}');

    // Set foreground notification presentation options for iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications with updated iOS settings
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      requestCriticalPermission: true, // Added critical permission request
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        printDebug('Notification tapped: ${response.payload}');
      },
    );

    await _createNotificationChannel();

    // Handle initial message if app was terminated
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      printDebug(
          '=====> App opened from terminated state with message: ${initialMessage.messageId}');
    }
  }

  Future<String?> getFCMToken() async {
    final token = await _firebaseMessaging.getToken();
    printDebug('=====>> getting token : $token');
    return token;
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      sound: 'default',
      badgeNumber: 1, // Added badge number
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now()
          .microsecond, // Changed from millisecond to microsecond for more unique IDs
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  void configureFirebaseMessaging({
    Function(RemoteMessage)? onMessage,
    Function(RemoteMessage)? onMessageOpenedApp,
    Function(String?)? onToken,
  }) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onMessage?.call(message);

      // Show local notification only when app is in foreground
      if (message.notification != null) {
        printDebug(
            '=====> fcm.onMessage > checking if should show local notification');

        // Show local notification only in foreground for both platforms
        bool shouldShowLocalNotification = true;

        // On iOS, Firebase already shows the notification in foreground
        if (Platform.isIOS) {
          shouldShowLocalNotification = false;
        }

        if (shouldShowLocalNotification) {
          printDebug('=====> fcm.onMessage > showing local notification');
          showLocalNotification(
            title: message.notification!.title ?? '',
            body: message.notification!.body ?? '',
            payload: message.data.toString(),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onMessageOpenedApp?.call(message);
    });

    _firebaseMessaging.onTokenRefresh.listen((String? token) {
      onToken?.call(token);
    });
  }
}
