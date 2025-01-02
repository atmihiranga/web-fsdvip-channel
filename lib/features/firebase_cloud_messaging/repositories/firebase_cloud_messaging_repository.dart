import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_cloud_messaging_repository.g.dart';

/// A simple in-memory set to keep track of recently processed message IDs
final Set<String> _processedMessageIds = {};

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  printDebug(
      "=====> fcm repo > Handling a background message: ${message.messageId}");

  // For background messages on Android, let the system handle the notification.
  // We usually don't show a local notification here for Android, because the
  // system tray automatically shows it if it has a 'notification' payload.
  if (Platform.isAndroid) {
    printDebug(
        "=====> fcm repo > Platform is Android. Not showing local background notification.");
    return;
  }

  // For iOS background messages, we may need to display a local notification
  // if we want it to behave similarly to Android’s system-handled notifications.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);

  if (message.notification != null) {
    // Deduplicate by messageId
    if (message.messageId != null &&
        _processedMessageIds.contains(message.messageId)) {
      printDebug(
          "=====> fcm repo > Background: Duplicate message. Skipping local notification.");
      return;
    } else if (message.messageId != null) {
      _processedMessageIds.add(message.messageId!);
    }

    printDebug(
        "=====> fcm repo > Showing a local notification for iOS background message");
    await flutterLocalNotificationsPlugin.show(
      // Use messageId's hashCode or fallback to DateTime
      message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: 'notification_icon',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
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
  bool _isConfigured = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: true,
    );
    printDebug(
        '=====> fcm repo > User granted permission: ${settings.authorizationStatus}');

    // iOS: show notifications while in the foreground
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      requestCriticalPermission: true,
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

    // Check if the app was opened via a notification tap from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      printDebug(
        '=====> fcm repo > App opened from terminated state with message: ${initialMessage.messageId}',
      );
    }

    // Optionally subscribe to a topic
    await subscribeToTopic('common');
  }

  Future<String?> getFCMToken() async {
    final token = await _firebaseMessaging.getToken(
      vapidKey:
          'BKFSJam_tm2zGBq9WZaCi0CsHqNTEphzAiObWPGaheTJont1-x_ntpXqOytGOEXFIBehd0IB9LROTiBTaO85ziU',
    );
    printDebug('=====>> fcm repo > getting token : $token');
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
    // Optionally pass in a messageId to deduplicate
    String? messageId,
  }) async {
    // Use the messageId’s hashCode if available, otherwise fallback
    final uniqueId =
        messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch;

    // Deduplicate logic if needed
    if (messageId != null && _processedMessageIds.contains(messageId)) {
      printDebug(
          "=====> fcm repo > showLocalNotification: Duplicate message. Skipping local notification.");
      return;
    } else if (messageId != null) {
      _processedMessageIds.add(messageId);
    }

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: 'notification_icon',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      uniqueId,
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
    if (_isConfigured) return; // <--- prevent multiple subscriptions
    _isConfigured = true;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onMessage?.call(message);

      // In the foreground on Android, we won't see a system notification unless
      // the payload is purely a 'notification' payload with high priority.
      // If we *also* call showLocalNotification() here, that can lead to duplicates
      // if the system also decides to show the notification.
      // If you are controlling FCM from your own server, consider sending only data payloads
      // for foreground notifications, and then you manually showLocalNotification.

      if (message.notification != null) {
        printDebug(
            '=====> fcm repo > onMessage > has notification. Checking platform...');

        // By default, we skip local notification on iOS foreground
        // because setForegroundNotificationPresentationOptions = true
        // already shows it. This avoids duplicates.
        bool shouldShowLocalNotification = !Platform.isIOS;

        if (shouldShowLocalNotification) {
          printDebug(
              '=====> fcm repo > onMessage > showing local notification on Android');
          showLocalNotification(
            title: message.notification!.title ?? '',
            body: message.notification!.body ?? '',
            payload: message.data.toString(),
            messageId: message.messageId,
          );
        } else {
          printDebug(
              '=====> fcm repo > onMessage > iOS: Let the system handle the foreground notification');
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

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      printDebug('=====> fcm repo > Successfully subscribed to topic: $topic');
    } catch (e) {
      printDebug('=====> Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      printDebug(
          '=====> fcm repo > Successfully unsubscribed from topic: $topic');
    } catch (e) {
      printDebug('=====> fcm repo > Error unsubscribing from topic: $e');
    }
  }
}
