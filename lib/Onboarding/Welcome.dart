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
            top: 5, // Adjust this value to move the logo up or down
            left: MediaQuery.of(context).size.width / 2 -
                95, // Center horizontally
            child: _Logo(),
          ),

          // Illustration
          Positioned(
            top: 150, // Adjust this value to move the illustration up or down
            left: MediaQuery.of(context).size.width / 2 -
                180, // Center horizontally
            child: _Illustration(),
          ),

          // Title
          Positioned(
            top: 450, // Adjust this value to move the title up or down
            left: MediaQuery.of(context).size.width *
                0.1, // Add some padding from the left
            right: MediaQuery.of(context).size.width *
                0.1, // Add some padding from the right
            child: _Title(),
          ),

          Positioned(
            top: 650, // Adjust this value to move the title up or down
            left: MediaQuery.of(context).size.width *
                0.1, // Add some padding from the left
            right: MediaQuery.of(context).size.width *
                0.1, // Add some padding from the right
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
    width: 190, // Adjust width as needed
    height: 200, // Adjust height as needed
  );
}

Widget _Illustration() {
  return Image.asset(
    "assets/images/illustration.png",
    width: 360,
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
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Become your own money manager make every cent count",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'Create an Account',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005341),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'Sign in',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
