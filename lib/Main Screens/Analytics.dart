import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/Data/expense_data.dart';
import 'package:fintrack_app/components/expense_summary.dart';
import 'package:fintrack_app/database.dart';
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
  Stream<QuerySnapshot>? expenseStream;

  void getontheload() {
    expenseStream = Transactionservice().getexpenseDetails();
    setState(() {});
  }

  // void getontheload() async {
  //   expenseStream = Transactionservice().getexpenseDetails();

  //   // Load existing expenses from Firestore into ExpenseData provider
  //   expenseStream!.listen((snapshot) {
  //     final expenseProvider = Provider.of<ExpenseData>(context, listen: false);
  //     expenseProvider.overallExpenseList.clear(); // Clear old data

  //     for (var doc in snapshot.docs) {
  //       expenseProvider.addNewExpense(ExpenseItem(
  //         category: doc['category'],
  //         expenseAmount: doc['amount'],
  //         expenseDate: doc['date'].toDate(),
  //         expenseNote: '',
  //         id: '',
  //       ));
  //     }
  //   });

  //   setState(() {});
  // }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

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
      body: _TransactionList(expenseStream),
    );
  }
}

Widget _TransactionList(Stream<QuerySnapshot>? expenseStream) {
  return Consumer<ExpenseData>(
    builder: (context, value, child) {
      return ListView(
        children: [
          // Weekly summary goes here
          ExpenseSummary(startOfweek: value.StartOfWeekDate()),
          const SizedBox(height: 20),

          // Expense/Transaction goes here
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          StreamBuilder<QuerySnapshot>(
            stream: expenseStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No transactions found.'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];

                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.grade)),
                    title: Text(ds['category']),
                    subtitle: Text(
                      DateFormat('MMM d yyyy     hh:mm a')
                          .format(ds['date'].toDate()),
                    ),
                    trailing: Text(ds['amount'].toString()),
                  );
                },
              );
            },
          ),
        ],
      );
    },
  );
}
