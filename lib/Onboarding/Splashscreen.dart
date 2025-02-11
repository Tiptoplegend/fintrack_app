import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fintrack_app/Onboarding/Welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Welcomepage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005341),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int i = 1; i <= 3; i++)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 150 * _controller.value * i,
                    height: 150 * _controller.value * i,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(1 - _controller.value),
                        width: 3,
                      ),
                    ),
                  );
                },
              ),
            Image.asset(
              'assets/logo.png',
              width: 160,
              height: 160,
            ),
          ],
        ),
      ),
    );
  }
}
