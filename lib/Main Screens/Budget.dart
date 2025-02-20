import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fintrack_app/Main%20Screens/CreateBudgetPage.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
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

  int currentMonthIndex = 4; // May
  int currentYear = DateTime.now().year;

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

  final user = FirebaseAuth.instance.currentUser!;
  final userimg = FirebaseAuth.instance.currentUser!.photoURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade800,
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
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
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
      body: BudgetContent(),
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
  const BudgetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You don’t have a budget.",
              style: TextStyle(
                  fontFamily: 'inter', fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            const Text(
              "Let’s make one so you are in control.",
              style: TextStyle(
                  fontFamily: 'inter', fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateBudgetPage()),
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
        ),
      ),
    );
  }
}
