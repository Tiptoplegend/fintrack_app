import 'package:flutter/material.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 60,
            child: titles(),
          ),
        ],
      ),
    );
  }
}

Widget titles() {
  return Column(
    children: [
      Text(
        "Password Recovery",
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
      SizedBox(height: 10),
      Text(
        "Enter your Email",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ],
  );
}
