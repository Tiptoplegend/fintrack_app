import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: const Color(0xFF005341),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  _Uppersection(),
                  const Positioned(
                    left: 30,
                    top: 100,
                    child: _Greetings(),
                  ),
                  const Positioned(
                    top: 210,
                    left: 60,
                    child: Cardsection(),
                  ),
                  const Positioned(
                    top: 410,
                    left: 45,
                    child: _tips(),
                  ),
                  const Positioned(
                    top: 490,
                    left: 40,
                    child: _History(),
                  ),
                  Positioned(
                    top: 520,
                    left: 20,
                    right: 20,
                    child: _Expensecards(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _Uppersection() {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 310,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF005341),
                  Color(0xFF43A047),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("assets/images/user.png"),
                    ),
                    const SizedBox(width: 200, height: 100),
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

class _Greetings extends StatelessWidget {
  const _Greetings();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi Name",
          style: const TextStyle(
            fontFamily: 'inter',
            fontSize: 30,
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
            borderRadius: BorderRadius.circular(10),
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
                fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.bold),
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
    return Container(
      width: 330,
      height: 70,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'assets/images/icons8-lightbulb-80.png',
              width: 60,
              height: 60,
            ),
          ),
          const SizedBox(width: 10),
          Column(
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
                'Spend less than you earn.',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
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
        itemCount: 5,
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
