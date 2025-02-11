import 'package:flutter/material.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/user.png"),
              ),
              const SizedBox(
                width: 120,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [SizedBox(height: 10), Text('Goals')],
              )
            ],
          )),
      body: Stack(
          // widgets will go here
          ),
    );
  }
}
