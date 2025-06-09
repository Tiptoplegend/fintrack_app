// File: lib/providers/Helpscreen.dart 
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Financial Tips for Students'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005341), Color(0xFF00A86B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HelpSection(
              title: "1. Create a Budget",
              content:
                  "Track your income (e.g., allowances, part-time job earnings) and expenses (e.g., rent, food, transportation). Stick to your budget and adjust it as needed.",
            ),
            HelpSection(
              title: "2. Differentiate Wants from Needs",
              content:
                  "Prioritize essential expenses like tuition, rent, and food over non-essential items like entertainment or luxury purchases.",
            ),
            HelpSection(
              title: "3. Avoid Impulse Purchases",
              content:
                  "Plan your spending and avoid buying items on a whim. Wait a day or two before making non-essential purchases.",
            ),
            HelpSection(
              title: "4. Use Student Discounts",
              content:
                  "Take advantage of discounts offered to students for transportation, software, subscriptions, and entertainment.",
            ),
            HelpSection(
              title: "5. Save Regularly",
              content:
                  "Set aside a portion of your income or allowance for savings. Even small amounts can add up over time.",
            ),
            HelpSection(
              title: "6. Find Part-Time Work",
              content:
                  "Consider part-time jobs or freelance opportunities to supplement your income. Ensure it doesn’t interfere with your studies.",
            ),
            HelpSection(
              title: "7. Avoid Credit Card Debt",
              content:
                  "Use credit cards responsibly. Pay off your balance in full each month to avoid high-interest charges.",
            ),
            HelpSection(
              title: "8. Cook at Home",
              content:
                  "Save money by preparing meals at home instead of eating out. Meal planning can help reduce food waste and expenses.",
            ),
            HelpSection(
              title: "9. Track Your Spending",
              content:
                  "Use apps or spreadsheets to monitor your expenses and identify areas where you can cut back.",
            ),
            HelpSection(
              title: "10. Plan for Emergencies",
              content:
                  "Build an emergency fund to cover unexpected expenses like medical bills or urgent travel.",
            ),
            HelpSection(
              title: "11. Learn About Financial Aid",
              content:
                  "Explore scholarships, grants, and student loans to reduce the financial burden of tuition and other expenses.",
            ),
            HelpSection(
              title: "12. Invest in Your Future",
              content:
                  "If possible, start learning about investments and saving for long-term goals like postgraduate studies or career development.",
            ),
          ],
        ),
      ),
    );
  }
}

class HelpSection extends StatelessWidget {
  final String title;
  final String content;

  const HelpSection({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 5),
          Text(content,
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}