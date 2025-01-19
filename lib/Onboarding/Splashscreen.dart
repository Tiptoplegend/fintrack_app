// ignore_for_file: use_build_context_synchronously


import 'package:fintrack_app/Onboarding/Welcome.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder:
        (context) => const Welcomepage()
        ),
      );
    });
    return Scaffold(
      backgroundColor: Color(0xFF005341),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 230,
              height: 230,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}