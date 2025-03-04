// Ensure this import is correct
import 'package:fintrack_app/Data/expense_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  final user = FirebaseAuth.instance.currentUser!;
  final userimg = FirebaseAuth.instance.currentUser!.photoURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF005341),
                Color(0xFF43A047),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage("assets/images/icons8-user-48 (1).png")
                      as ImageProvider,
            ),
            const SizedBox(
              width: 100,
            ), // To create spacing if needed on the left
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(height: 10), // Moves the text down
                Text(
                  'Analytics',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        // widgets will go here

        children: [
          _TransactionList(),
        ],
      ),
    );
  }
}

Widget _TransactionList() {
  return Consumer<ExpenseData>(
    builder: (context, value, child) {
      return Scaffold(
        body: ListView.builder(
          itemCount: value.getExpenseList().length,
          itemBuilder: (context, index) {
            final expense = value.getExpenseList()[index];
            final formattedDate =
                DateFormat('dd/MM/yyyy').format(expense.expenseDate);

            return ListTile(
              title: Text(expense.category.name),
              subtitle: Text(formattedDate), // Updated to use formatted date
              trailing: Text('GHC${expense.expenseAmount.toStringAsFixed(2)}'),
            );
          },
        ),
      );
    },
  );
}

// we would Create the widgets below
