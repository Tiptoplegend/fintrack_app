import 'package:fintrack_app/debug_log.dart';
import 'package:fintrack_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    appLog('FCM: requesting notification permission');
    final settings = await _firebaseMessaging.requestPermission();
    appLog(
      'FCM: permission status=${settings.authorizationStatus}, '
      'alert=${settings.alert}, badge=${settings.badge}',
    );

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      appLog('FCM: waiting for APNS token (iOS)');
      final apnsToken = await _waitForApnsToken();
      if (apnsToken == null) {
        appLog(
          'FCM: APNS token not available (common on simulator); '
          'skipping getToken, registering listeners',
        );
        initPushNotification();
        return;
      }
      appLog('FCM: APNS token received (${apnsToken.length} chars)');
    }

    try {
      final fCMToken = await _firebaseMessaging.getToken();
      appLog('FCM: device token=$fCMToken');
    } on FirebaseException catch (e, st) {
      if (e.code == 'apns-token-not-set') {
        appLog('FCM: getToken skipped', error: e.message);
      } else {
        appLog('FCM: getToken failed', error: e, stackTrace: st);
        rethrow;
      }
    }

    initPushNotification();
  }

  /// APNS registration is async; FCM requires this token on iOS before [getToken].
  Future<String?> _waitForApnsToken({int maxAttempts = 15}) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final token = await _firebaseMessaging.getAPNSToken();
      if (token != null) {
        appLog('FCM: APNS ready after attempt ${attempt + 1}/$maxAttempts');
        return token;
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
    appLog('FCM: APNS not ready after $maxAttempts attempts');
    return null;
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    appLog(
      'FCM: opened notification '
      'title=${message.notification?.title} '
      'data=${message.data}',
    );

    navigatorkey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  Future<void> initPushNotification() async {
    appLog('FCM: registering push listeners');
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        appLog('FCM: app opened from terminated state via notification');
      }
      handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      appLog(
        'FCM: foreground message '
        'title=${message.notification?.title}',
      );
    });
  }
}