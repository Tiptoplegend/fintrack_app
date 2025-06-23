import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/database.dart';
import 'package:fintrack_app/providers/SettingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fintrack_app/Main%20Screens/CreateBudgetPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  Stream<QuerySnapshot>? budgetStream;

  void getontheload() {
    budgetStream = Budgetservice().getbudgetDetails(
      month: currentMonthIndex + 1,
      year: currentYear,
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getontheload();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getontheload();
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

  int currentMonthIndex = DateTime.now().month -
      1; // Initialize to current month (zero-based index)
  int currentYear = DateTime.now().year;

  void previousMonth() {
    setState(() {
      if (currentMonthIndex > 0) {
        currentMonthIndex--;
      } else {
        currentMonthIndex = 11; // December (zero-based index)
        currentYear--;
      }
      getontheload();
    });
  }

  void nextMonth() {
    setState(() {
      if (currentMonthIndex < 11) {
        currentMonthIndex++;
      } else {
        currentMonthIndex = 0; // January (zero-based index)
        currentYear++;
      }
      getontheload();
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
                flexibleSpace: Container(
                  decoration: const BoxDecoration(),
                ),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                elevation: 0,
                title: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ));
                      },
                      icon: CircleAvatar(
                        radius: 24,
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : const AssetImage(
                                    "assets/images/icons8-user-48 (1).png")
                                as ImageProvider,
                      ),
                    ),

                    const SizedBox(
                      width: 90,
                    ), // To create spacing if needed on the left
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(height: 10), // Moves the text down
                        Text(
                          'Budget',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
      body: budgetdetails(budgetStream, currentMonthIndex, currentYear),
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

Widget budgetdetails(
    Stream? budgetStream, int currentMonthIndex, int currentYear) {
  return StreamBuilder(
    stream: budgetStream,
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            if (!snapshot.hasData || snapshot.data.docs.isEmpty) ...[
              const SizedBox(height: 20),
              const Center(child: Text("No budgets found.")),
              const SizedBox(height: 20),
            ],
            if (snapshot.hasData && snapshot.data.docs.isNotEmpty)
              ...snapshot.data.docs.map<Widget>((doc) {
                DocumentSnapshot ds = doc;
                return Slidable(
                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context) async {
                          // delete budget
                          await Budgetservice().deleteBudget(ds.id);
                        }),
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budget cycle: ${ds['cycle']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.shopping_cart,
                                  color: Colors.green),
                              const SizedBox(width: 10),
                              Text(ds['category'],
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // progress bar
                          FutureBuilder<double>(
                            future: Budgetservice().getTotalSpentForBudget(
                              ds['category'],
                              ds['Month'],
                              ds['Year'],
                            ),
                            builder: (context, snapshot) {
                              double spent = snapshot.data ?? 0.0;
                              double budgetAmount = double.tryParse(
                                      ds['budgetAmount'].toString()) ??
                                  1.0;
                              double progress =
                                  (spent / budgetAmount).clamp(0.0, 1.0);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Remaining: ₵${(budgetAmount - spent).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: (budgetAmount - spent) < 0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    minHeight: 15,
                                    value: progress,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '₵${spent.toStringAsFixed(2)} of ₵${budgetAmount.toStringAsFixed(2)} spent',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  if (progress >= 0.5)
                                    Text(
                                      'You have spent more than 50% of your budget!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    )
                                  else if (progress >= 0.8)
                                    Text(
                                      'You have spent more than 80% of your budget!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            const SizedBox(height: 30),
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
                      builder: (context) => CreateBudgetPage(
                        month: currentMonthIndex + 1,
                        year: currentYear,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Create Budget",
                  style: TextStyle(
                    fontFamily: 'inter',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      );
    },
  );
}
