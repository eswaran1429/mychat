import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _message = FirebaseMessaging.instance;
  final _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    //request permisstion
    requestPermission();
    //setup
    _setupNotificationChannel();
    //foreground
    FirebaseMessaging.onMessage.listen(showNotification);
    //open message
    FirebaseMessaging.onMessageOpenedApp.listen(openHandler);
    //background
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

  }

  Future<void> requestPermission() async {
    await _message.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<void> _setupNotificationChannel() async {
    const channel = AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Notifications',
        description: 'For important notifications', importance: Importance.high);

    await _localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _localNotification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')));
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null && notification.android != null) {
      _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'high_importance_channel', 'High Importance Notifications',
                  channelDescription: 'For important notifications',
                  importance: Importance.high,
                  priority: Priority.high,
                  icon: '@mipmap/ic_launcher')));
    }
  }

  Future<void> openHandler(RemoteMessage message) async {
    if (message.data['type'] == 'chat') {
      //have to work on specific page and message from the chat
    }
  }
}
