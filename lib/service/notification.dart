import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _requestPermission();
    await _setupNotificationChannel();
    FirebaseMessaging.onMessage.listen(showNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    _printToken();
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
  }

  Future<void> _setupNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: 'For important notifications',
      importance: Importance.high,
    );

    await _localNotification
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _localNotification.initialize(
      const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notify = message.notification;
    if (notify != null && notify.android != null) {
      await _localNotification.show(
        notify.hashCode,
        notify.title,
        notify.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', 'High Importance Notifications',
            channelDescription: 'For important notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      // Handle chat notification tap
    }
  }

  void _printToken() async {
    print('Token: ${await _messaging.getToken()}');
  }
}
