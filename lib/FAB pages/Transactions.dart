import 'package:fintrack_app/Main%20Screens/Goals.dart';
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
          Positioned(
            top: 50,
            left: 30,
            child: _textfield(),
          ),
          Positioned(
            top: 160,
            left: 26,
            child: _notesection(),
          ),
          Positioned(
            top: 235,
            left: 30,
            child: _CatGoalsbtn(),
          ),
          Positioned(
            top: 600,
            left: 30,
            child: _Continuebtn(),
          )
        ],
      ),
    );
  }
}

Widget _textfield() {
  return SizedBox(
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
              borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          )),
    ),
  );
}

Widget _notesection() {
  return SizedBox(
    width: 360,
    height: 250,
    child: TextField(
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.note_add_outlined),
        hintText: 'Notes (Optional)',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        border: OutlineInputBorder(),
      ),
    ),
  );
}

Widget _CatGoalsbtn() {
  return Row(
    children: [
      ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            minimumSize: Size(150, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Color(Colors.green.value)),
        icon: Icon(Icons.track_changes_sharp, color: Color(Colors.white.value)),
        label: Text(' Select Goals', style: TextStyle(color: Colors.white)),
      ),
      SizedBox(
        width: 40,
      ),
      ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            minimumSize: Size(150, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Color(Colors.green.value)),
        icon: Icon(Icons.category, color: Color(Colors.white.value)),
        label: Text('Categories', style: TextStyle(color: Colors.white)),
      ),
    ],
  );
}

Widget _Continuebtn() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(Colors.green.value),
        minimumSize: Size(340, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        'Continue',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    ),
  );
}
