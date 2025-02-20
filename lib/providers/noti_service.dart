import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  final bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // We are doifn the initializing below
  Future<void> initNotification() async {
    if (_isInitialized) return;


  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');


    const InitializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: InitializationSettingsAndroid,
      iOS: InitializationSettingsIOS,
    );

    await notificationPlugin.initialize(initSettings);
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_channel_id', 'Daily Notifications',
            channelDescription: 'Daily Notification Channel',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher'),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationPlugin.show(id, title, body, notificationDetails());
  }
}
