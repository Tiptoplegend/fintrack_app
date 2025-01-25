import 'package:fintrack_app/Main%20Screens/Homepage.dart';
import 'package:fintrack_app/Main%20Screens/Landingpage.dart';
import 'package:fintrack_app/Onboarding/Splashscreen.dart';
import 'package:fintrack_app/Onboarding/Welcome.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FinTrackApp());
}

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  // the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintrack App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
