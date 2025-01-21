import 'package:fintrack_app/Main%20Screens/Goals.dart';
import 'package:fintrack_app/Main%20Screens/Homepage.dart';
import 'package:flutter/material.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  int currentIndex = 0;

  // List of pages or widgets to display based on selected tab
  static List<Widget> body = [
    Homepage(),
    const Icon(Icons.analytics, size: 50),
    const Icon(Icons.add_circle, size: 50),
    const Goals(),
    const Icon(Icons.monetization_on, size: 50),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: body.elementAt(currentIndex),
            ),
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: buildNavbar(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildNavbar() {
    return Padding(
      // color: Colors.transparent,
      // elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.analytics_outlined, "Analytics", 1),
          _buildNavItem(Icons.add_circle, "Add", 2),
          _buildNavItem(Icons.track_changes, "Goals", 3),
          _buildNavItem(Icons.monetization_on, "Budget", 4),
        ],
      ),
    );
  }

  // Widget to create a navigation item
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSelected ? 40 : 30, // Highlight the selected icon
            color: isSelected ? Colors.green : Colors.black,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
