import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    final message =
        ModalRoute.of(context)?.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: message != null
          ? Column(
              children: [
                ListTile(
                  title: Text(message.notification?.title ?? 'No Title'),
                  subtitle: Text(message.notification?.body ?? 'No Body'),
                  trailing: Text(message.sentTime.toString()),
                ),
              ],
            )
          : const Center(
              child: Text('No notification data available.'),
            ),
    );
  }
}
