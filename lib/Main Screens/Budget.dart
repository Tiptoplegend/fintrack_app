import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  int currentMonthIndex = 4; // May
  int currentYear = DateTime.now().year; // Get current year

  // Navigate to the previous month
  void previousMonth() {
    setState(() {
      if (currentMonthIndex > 0) {
        currentMonthIndex--;
      } else {
        currentMonthIndex = 11; // December
        currentYear--; 
      }
    });
  }

  // Navigate to the next month
  void nextMonth() {
    setState(() {
      if (currentMonthIndex < 11) {
        currentMonthIndex++;
      } else {
        currentMonthIndex = 0; // January
        currentYear++; 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0), 
          child: const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/images/user.png"), // Ensure this image exists
          ),
        ),
        title: const Text(
          'Budget',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BudgetContent(
        currentMonth: months[currentMonthIndex],
        currentYear: currentYear,
        onPrevious: previousMonth,
        onNext: nextMonth,
      ),
    );
  }
}

class MonthYearSelector extends StatelessWidget {
  final String currentMonth;
  final int currentYear;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MonthYearSelector({
    super.key,
    required this.currentMonth,
    required this.currentYear,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Colors.green.shade800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button (Month/Year)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: onPrevious,
          ),

          // Display Current Month and Year
          Column(
            children: [
              Text(
                currentMonth,
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                "$currentYear",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),

          // Next Button (Month/Year)
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class BudgetContent extends StatelessWidget {
  final String currentMonth;
  final int currentYear;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const BudgetContent({
    super.key,
    required this.currentMonth,
    required this.currentYear,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Month and Year Selector
        MonthYearSelector(
          currentMonth: currentMonth,
          currentYear: currentYear,
          onPrevious: onPrevious,
          onNext: onNext,
        ),
        
        // No Budget Message
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "You don’t have a budget.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  "Let’s make one so you are in control.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}