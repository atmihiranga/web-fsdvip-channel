import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/firebase_cloud_messaging/repositories/firebase_cloud_messaging_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firebase_cloud_messaging_viewmodel.g.dart';

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  late final NotificationRepository _repository;

  @override
  FutureOr<void> build() async {
    _repository = ref.read(notificationRepositoryProvider);
    await _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _repository.initialize();

    _repository.configureFirebaseMessaging(
      onMessage: _handleForegroundMessage,
      onMessageOpenedApp: _handleMessageOpenedApp,
      onToken: _handleTokenRefresh,
    );

    // Handle initial message if app was opened from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }

    // Get initial FCM token
    final token = await _repository.getFCMToken();
    if (token != null) {
      // TODO: Send token to your backend
      printDebug('====> FCM Token: $token');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    printDebug(
        '=====> Received foreground message: ${message.notification?.title}');
    // Handle the message according to your app's needs
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    printDebug(
        '=====> App opened from notification: ${message.notification?.title}');
    // Navigate to appropriate screen based on message data
  }

  void _handleTokenRefresh(String? token) {
    if (token != null) {
      // TODO: Send updated token to your backend
      printDebug('=====> Updated FCM Token: $token');
    }
  }

  void _handleInitialMessage(RemoteMessage message) {
    printDebug('Handling initial message: ${message.messageId}');
    // Navigate or perform actions based on the initial message
  }

  // Method to show a local notification manually if needed
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _repository.showLocalNotification(
      title: title,
      body: body,
      payload: payload,
    );
  }
}
