import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(top: 50, left: 30, child: _textfield()),
        ],
      ),
    );
  }
}

Widget _textfield() {
  return Container(
    width: 350,
    height: 500,
    child: TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 30),
      decoration: InputDecoration(
          suffixIcon: Icon(Icons.attach_money_outlined),
          hintText: 'GHC 0.00',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green)),
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          )),
    ),
  );
}
