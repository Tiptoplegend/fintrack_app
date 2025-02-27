import 'package:fintrack_app/providers/SettingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        // statusBarColor: const Color(0xFF005341),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            _Uppersection(context: context),
            SafeArea(
              top:
                  false, // Allow the container to extend into the status bar and notch area
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
                      left: 60,
                      child: Cardsection(),
                    ),
                    const Positioned(
                      top: 400,
                      left: 45,
                      child: _tips(),
                    ),
                    const Positioned(
                      top: 515,
                      left: 40,
                      child: _History(),
                    ),
                    Positioned(
                      top: 530,
                      left: 20,
                      right: 20,
                      child: _Expensecards(),
                    )
                  ],
                ),
              ),
            ),
          ],
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
            CircleAvatar(
              radius: 27,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage("assets/images/icons8-user-48 (1).png")
                      as ImageProvider,
            ),
            const SizedBox(width: 200, height: 40),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
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
        ),
        const Positioned(
          top: 10,
          left: 15,
          child: Text(
            'This Months Spendings',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'inter',
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
        ),
        const Positioned(
          top: 25,
          left: 15,
          child: Text(
            'GHC 2,000',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005341)),
          ),
        ),
      ],
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

class _Expensecards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 380,
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text("Transportation"),
                subtitle: const Text("12-Dec-2024"),
                trailing: const Text("GHC 200"),
              ),
            ),
          );
        },
      ),
    );
  }
}
