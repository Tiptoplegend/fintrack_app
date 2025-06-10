import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Green header
            Container(
              color: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Help',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

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
  }) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
        ),
      ],
    );
  }
}