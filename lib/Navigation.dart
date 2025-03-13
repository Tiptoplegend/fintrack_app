import 'dart:math';
import 'package:fintrack_app/FAB%20pages/Categories.dart';
import 'package:fintrack_app/FAB%20pages/Chatbot.dart';
import 'package:fintrack_app/FAB%20pages/Transactions.dart';
import 'package:fintrack_app/Main%20Screens/CreateBudgetPage.dart';
import 'package:flutter/material.dart';
import 'package:fintrack_app/Main%20Screens/Analytics.dart';
import 'package:fintrack_app/Main%20Screens/Goals.dart';
import 'package:fintrack_app/Main%20Screens/Homepage.dart';
import 'Main Screens/Budget.dart';

class Navigation extends StatefulWidget {
  final int selectedIndex;
  const Navigation({super.key, this.selectedIndex = 0}); // Default to Home

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late int currentIndex;
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selectedIndex; // Start with the selected tab
  }

  static List<Widget> body = [
    Homepage(),
    Analytics(),
    const Goals(),
    const BudgetScreen(),
    const CreateBudgetPage(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: body,
          ),
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: buildNavbar(),
          ),
          if (isMenuOpen)
            GestureDetector(
              onTap: () => setState(() => isMenuOpen = false),
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          if (isMenuOpen)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildMenuButton(
                        angle: -5 * pi / 6,
                        icon: Icons.chat,
                        label: "Chatbot",
                        page: const ChatbotPage(),
                      ),
                      _buildMenuButton(
                        angle: -pi / 2,
                        icon: Icons.attach_money,
                        label: "Transaction",
                        page: const TransactionPage(),
                      ),
                      _buildMenuButton(
                        angle: -pi / 6,
                        icon: Icons.category,
                        label: "Categories",
                        page: CategoriesPage(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => isMenuOpen = !isMenuOpen),
        backgroundColor: Colors.green,
        child: Icon(
          isMenuOpen ? Icons.close : Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMenuButton({
    required double angle,
    required IconData icon,
    required String label,
    required Widget page,
  }) {
    const double radius = 80.0;
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: isMenuOpen ? 1.0 : 0.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            radius * cos(angle) * value,
            radius * sin(angle) * value,
          ),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: label,
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
              setState(() => isMenuOpen = false);
            },
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavbar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.analytics_outlined, "Analytics", 1),
          const SizedBox(width: 10),
          _buildNavItem(Icons.track_changes, "Goals", 2),
          _buildNavItem(Icons.monetization_on, "Budget", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSelected ? 40 : 30,
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
