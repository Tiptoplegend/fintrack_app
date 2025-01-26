import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: const Color(0xFF005341), // Matches the green gradient
          statusBarIconBrightness: Brightness.light, // Light icons for contrast
        ),
        child: Scaffold(
          body: Stack(children: [
            _Uppersection(),
            Positioned(
              left: 30,
              top: 100,
              child: _Greetings(),
            ),
            Positioned(
              top: 210,
              left: 60,
              child: Cardsection(),
            )
          ]),
        ));
  }
}

Widget _Uppersection() {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 310,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF005341),
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
                      height: 100,
                    ),
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget _Greetings() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hi Bamps',
        style: TextStyle(
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
          style: TextStyle(
              fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.bold),
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
              color: Color(0xFF005341)),
        ),
      ),
    ],
  );
}
