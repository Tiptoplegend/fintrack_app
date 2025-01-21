import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _Uppersection(),
        Positioned(
          left: 35,
          top: 75,
          child: _Greetings(),
        ),
        Positioned(top: 190, left: 55, child: Cardsection())
      ]),
    );
  }
}

Widget _Uppersection() {
  return Scaffold(
    body: SingleChildScrollView(
        child: Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF009688),
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

          // The settings and User icon Section will be below

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage("assets/images/user.png"),
                  ),
                  const SizedBox(
                    width: 200,
                    height: 80,
                  ),
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    )),
  );
}

Widget _Greetings() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hi Bamps',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      Text(
        'Welcome, lets manage some money',
        style: TextStyle(fontSize: 16, color: Colors.white),
      )
    ],
  );
}

Widget Cardsection() {
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
          )),
      Positioned(
        top: 10,
        left: 15,
        child: Text(
          'This Months Spendings',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      Positioned(
          top: 25,
          left: 15,
          child: Text(
            'GHC 2,000',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009688)),
          )),
    ],
  );
}
