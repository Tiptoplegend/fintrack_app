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
            top: 760,
            left: MediaQuery.of(context).size.width / 2.8 - 80,
            child: _Navbar(),
          ),
        ],
      ),
    );
  }
}

Widget _Navbar() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _NavItem(
          iconPath: 'assets/images/icons8-home-48.png',
          label: 'Home',
          onPressed: () {},
        ),
        _NavItem(
          iconPath: 'assets/images/icons8-analytics-48.png',
          label: 'Analytics',
          onPressed: () {},
        ),
        _NavItem(
          iconPath: 'assets/images/icons8-home-48.png',
          label: 'Add',
          onPressed: () {},
        ),
        _NavItem(
          iconPath: 'assets/images/icons8-home-48.png',
          label: 'Goals',
          onPressed: () {},
        ),
        _NavItem(
          iconPath: 'assets/images/icons8-home-48.png',
          label: 'Profile',
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget _NavItem({
  required String iconPath,
  required String label,
  required VoidCallback onPressed,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        onPressed: onPressed,
        icon: Image.asset(
          iconPath,
          width: 38,
          height: 38,
        ),
      ),
      const SizedBox(height: -1), // Space between icon and text
      Text(
        label,
        style: const TextStyle(fontSize: 12), // Adjust text size as needed
      ),
    ],
  );
}
