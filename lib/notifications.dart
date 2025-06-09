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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF005341),
                Color(0xFF43A047),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text('Notifications'),
            centerTitle: true, 
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
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