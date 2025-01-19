import 'package:flutter/material.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 750,
            left: MediaQuery.of(context).size.width / 3.7 - 80,
            child: _Navbar(),
          ),
        ],
      ),
    );
  }
}

Widget _Navbar() {
  return Stack(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Home logo
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/icons8-home-48.png',
                width: 38,
                height: 38,
              )),

          const SizedBox(width: 12),

          // Analytics
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/icons8-analytics-48.png',
                width: 38,
                height: 38,
              )),

          const SizedBox(width: 12),

          // Add
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/icons8-add-100.png',
                width: 80,
                height: 80,
              )),

          const SizedBox(width: 12),

          // Goals
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/icons8-goals-64.png',
                width: 38,
                height: 38,
              )),

          const SizedBox(width: 12),

          // Budget
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/icons8-budget-30.png',
                width: 38,
                height: 38,
              ))
        ],
      ),
    ],
  );
}
