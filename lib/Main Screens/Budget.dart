import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fintrack_app/Main%20Screens/CreateBudgetPage.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  Stream<QuerySnapshot>? budgetStream;

  void getontheload() {
    budgetStream = Budgetservice().getbudgetDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  int currentMonthIndex = 3; // March
  int currentYear = DateTime.now().year;

  void previousMonth() {
    setState(() {
      if (currentMonthIndex > 1) {
        currentMonthIndex--;
      } else {
        currentMonthIndex = 12; // December
        currentYear--;
      }
    });
  }

  void nextMonth() {
    setState(() {
      if (currentMonthIndex < 12) {
        currentMonthIndex++;
      } else {
        currentMonthIndex = 0; // January
        currentYear++;
      }
    });
  }

  final user = FirebaseAuth.instance.currentUser!;
  final userimg = FirebaseAuth.instance.currentUser!.photoURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF005341),
                Color(0xFF43A047),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : const AssetImage(
                                "assets/images/icons8-user-48 (1).png")
                            as ImageProvider,
                  ),
                ),
                title: const Text(
                  'Budget',
                  style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
              ),

              // Month and Year Selector inside AppBar
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: MonthYearSelector(
                  currentMonth: months[currentMonthIndex],
                  currentYear: currentYear,
                  onPrevious: previousMonth,
                  onNext: nextMonth,
                ),
              ),
            ],
          ),
        ),
      ),
      body: BudgetContent(budgetStream: budgetStream),
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
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: onPrevious,
          ),
          Column(
            children: [
              Text(
                currentMonth,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "$currentYear",
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
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
  final Stream<QuerySnapshot>? budgetStream;

  const BudgetContent({super.key, this.budgetStream});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Budget',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Icon(Icons.shopping_cart, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      'Shopping',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Remaining: \$100',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  minHeight: 15,
                  value: 0.5,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 4),
                const Text(
                  '\$200 of \$300 spent',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 200),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateBudgetPage()),
              );
            },
            child: const Text(
              "Create budget",
              style: TextStyle(
                fontFamily: 'inter',
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
