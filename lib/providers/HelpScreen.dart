import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Help'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005341), Color(0xFF00A86B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Expandable Help Items
            Expanded(
              child: ListView(
                children: [
                  buildExpansionTile(
                    icon: Icons.attach_money,
                    color: Colors.green,
                    title: 'Budget',
                    content:
                        '''• Set monthly limits for categories like food, transport, or entertainment.
• Get notified when you're nearing your budget.
• Helps you develop discipline and avoid overspending.
• Understand where your money goes and adjust accordingly.''',
                    textColor: textColor,
                  ),
                  buildExpansionTile(
                    icon: Icons.track_changes,
                    color: Colors.red,
                    title: 'Goals',
                    content:
                        '''• Create specific saving goals like "New Laptop" or "Vacation".
• Assign target amounts and timelines.
• Track progress visually to stay motivated.
• Helps you save purposefully instead of randomly.''',
                    textColor: textColor,
                  ),
                  buildExpansionTile(
                    icon: Icons.money_off_csred,
                    color: Colors.lightGreen,
                    title: 'Expense',
                    content:
                        '''• Quickly log daily expenses by category and amount.
• Use tags like "Groceries", "Bills", or "Transport" for easy filtering.
• Helps identify spending patterns and habits.
• Supports informed financial decisions based on actual data.''',
                    textColor: textColor,
                  ),
                  buildExpansionTile(
                    icon: Icons.bar_chart,
                    color: Colors.blue,
                    title: 'Analytics',
                    content:
                        '''• View charts that show your income vs. expenses.
• See breakdowns by category, time period, or goal.
• Gain insights like "Most spent on food" or "Saving trends".
• Empowers you to make better financial plans using data.''',
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpansionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
    required Color textColor,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color, // Title color matches icon color
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            content,
            style: TextStyle(fontSize: 16, color: textColor, height: 1.5),
          ),
        ),
      ],
    );
  }
}