import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/Data/expense_data.dart';
import 'package:fintrack_app/Models/expense_Item.dart';
import 'package:fintrack_app/components/expense_summary.dart';
import 'package:fintrack_app/database.dart';
import 'package:fintrack_app/providers/SettingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ));
              },
              icon: CircleAvatar(
                radius: 24,
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : const AssetImage("assets/images/icons8-user-48 (1).png")
                        as ImageProvider,
              ),
            ),

            const SizedBox(
              width: 80,
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
    builder: (context, expenseData, child) {
      return StreamBuilder<QuerySnapshot>(
        stream: expenseStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Process data after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            expenseData.overallExpenseList.clear();
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              for (var doc in snapshot.data!.docs) {
                ExpenseItem expense = ExpenseItem.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                );
                expenseData.addNewExpense(expense);
              }
            }
            // Notify listeners is not needed here as Consumer listens to changes
          });

          return ListView(
            children: [
              ExpenseSummary(startOfweek: expenseData.StartOfWeekDate()),

              const SizedBox(height: 20),
              const Text(
                'Transaction History',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              // Check if there are transactions
              (snapshot.hasData && snapshot.data!.docs.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        return Slidable(
                          endActionPane:
                              ActionPane(motion: StretchMotion(), children: [
                            SlidableAction(
                              onPressed: ((context) async {
                                // delete expense
                                await Transactionservice()
                                    .deleteTransaction(ds.id);
                              }),
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                            ),
                          ]),
                          child: ListTile(
                            leading:
                                const CircleAvatar(child: Icon(Icons.grade)),
                            title: Text(ds['category']),
                            subtitle: Text(
                              DateFormat('MMM d yyyy     hh:mm a')
                                  .format(ds['date'].toDate()),
                            ),
                            trailing: Text(ds['amount'].toString()),
                          ),
                        );
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Text('No Transactions/ History'),
                      ),
                    ),
            ],
          );
        },
      );
    },
  );
}
