import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/database.dart';
import 'package:fintrack_app/notifications.dart';
import 'package:fintrack_app/providers/SettingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser!;
  final userimg = FirebaseAuth.instance.currentUser!.photoURL;

  @override
  Widget build(BuildContext context) {
    String username = user.displayName ?? "User";

    return WillPopScope(
      onWillPop: () async {
        // Show exit confirmation dialog
        bool exitApp = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Exit App?"),
            content: Text("Do you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text("Yes"),
              ),
            ],
          ),
        );

        return exitApp;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: Stack(
            children: [
              _Uppersection(context: context),
              SafeArea(
                top: false,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 40,
                        top: 110,
                        child: _Greetings(username: username),
                      ),
                      const Positioned(
                        top: 210,
                        left: 56,
                        child: Cardsection(),
                      ),
                      const Positioned(
                        top: 405,
                        left: 45,
                        child: _tips(),
                      ),
                      const Positioned(
                        top: 515,
                        left: 40,
                        child: _History(),
                      ),
                      Positioned(
                        top: 510,
                        left: 20,
                        right: 20,
                        child: _Expensecards(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _Uppersection({required BuildContext context}) {
  final user = FirebaseAuth.instance.currentUser;
  final padding = MediaQuery.of(context).padding;

  return Container(
    height: 310 + padding.top,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF005341),
          Color(0xFF43A047),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
    ),
    child: Column(
      children: [
        SizedBox(
            height: padding
                .top), // Add padding to cover the status bar and notch area
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: CircleAvatar(
                radius: 27,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage("assets/images/icons8-user-48 (1).png")
                        as ImageProvider,
              ),
            ),
            const SizedBox(width: 200, height: 40),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Notifications(),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_on_sharp),
              color: Colors.white,
              iconSize: 30,
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    ),
  );
}

class _Greetings extends StatelessWidget {
  final String username;

  const _Greetings({required this.username});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi $username",
          style: const TextStyle(
            fontFamily: 'inter',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'Welcome, lets manage some money',
          style:
              TextStyle(fontFamily: 'inter', fontSize: 18, color: Colors.white),
        )
      ],
    );
  }
}

class Cardsection extends StatefulWidget {
  const Cardsection({super.key});

  @override
  State<Cardsection> createState() => _CardsectionState();
}

class _CardsectionState extends State<Cardsection> {
  Stream? budgetStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getontheload();
  }

  void getontheload() {
    budgetStream = Budgetservice().getbudgetDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Months Spendings',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'inter',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'GHC 0',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005341),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: budgetStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Oops! No budget set yet",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  DocumentSnapshot ds = snapshot.data.docs[0];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              ds['category'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 270,
                        child: LinearProgressIndicator(
                          minHeight: 14,
                          value: 0.1,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '₵0 of ${ds['budgetAmount']} spent',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _tips extends StatelessWidget {
  const _tips();

  @override
  Widget build(BuildContext context) {
    List<String> financialTips = [
      "Track your spending to know where your money goes.",
      "Save at least 10% of your income each month.",
      "Use the 50/30/20 rule: 50% for needs, 30% for wants, and 20% for savings.",
      "Avoid impulse purchases—wait 24 hours before buying.",
      "Invest early to take advantage of compound interest and secure your future.",
      "Always have an emergency fund that covers at least 3-6 months of expenses.",
    ];

    String getRandomTip() {
      return (financialTips..shuffle()).first;
    }

    return Container(
      width: 330,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns text at the top
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'assets/images/icons8-lightbulb-80.png',
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 8), // Adds space between image and text
          Expanded(
            // Ensures text wraps properly
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TIP OF THE DAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  getRandomTip(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _History extends StatelessWidget {
  const _History();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'History',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}

class _Expensecards extends StatefulWidget {
  @override
  _ExpensecardsState createState() => _ExpensecardsState();
}

class _ExpensecardsState extends State<_Expensecards> {
  Stream? expensestream;

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  getontheload() async {
    expensestream = Transactionservice().getexpenseDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: expensestream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 45, bottom: 45),
              child: Text(
                "No Transaction/Expense History",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          ); // Show message if no data
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return SizedBox(
              width: 380,
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.green),
                  title: Text(
                    ds['category'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat('MMM-d-yyyy     hh:mm a')
                        .format(ds['date'].toDate()),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  trailing: Text(
                    "GHC ${ds['amount']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 14),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
