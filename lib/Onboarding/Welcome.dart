// ignore_for_file: unused_label, non_constant_identifier_names

import 'package:fintrack_app/Onboarding/SignIn.dart';
import 'package:fintrack_app/Onboarding/SignUp.dart';
import 'package:flutter/material.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005341),
      body: Stack(
        children: [
          // Logo
          Positioned(
            top: 2,
            left: MediaQuery.of(context).size.width / 2 -
                95, 
            child: _Logo(),
          ),

          // Illustration
          Positioned(
            top: 140,
            left: MediaQuery.of(context).size.width / 2 -
                180,
            child: _Illustration(),
          ),

          // Title
          Positioned(
            top: 450, 
            left: MediaQuery.of(context).size.width *
                0.1, 
            right: MediaQuery.of(context).size.width *
                0.1, 
            child: _Title(),
          ),

          Positioned(
            top: 650,
            left: MediaQuery.of(context).size.width *
                0.0, 
            right: MediaQuery.of(context).size.width *
                0.0, 
            child: _buidButtons(context),
          ),
        ],
      ),
    );
  }
}

Widget _Logo() {
  return Image.asset(
    'assets/logo.png',
    width: 190, 
    height: 190, 
  );
}

Widget _Illustration() {
  return Image.asset(
    "assets/images/illustration.png",
    width: 350,
    height: 360,
  );
}

// Title Widget
Widget _Title() {
  return const Column(
    children: [
      Text(
        "Gain total control of your money",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 36,
           fontFamily: 'Inter',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Become your own money manager and make every cent count",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
           fontFamily: 'Inter',
          color: Colors.white,
        ),
      ),
    ],
  );
}

Widget _buidButtons(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder:
               (context) => SignUpPage()), 
            );
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            minimumSize: const Size(double.infinity, 50),
          );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'Create an Account',
            style: TextStyle(
              fontSize: 18,
               fontFamily: 'Inter',
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder:
               (context) => Signin()), 
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005341),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'Sign in',
            style: TextStyle(
              fontSize: 18,
               fontFamily: 'Inter',
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
