import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/Data/expense_data.dart';
import 'package:fintrack_app/Models/expense_Item.dart';
import 'package:fintrack_app/components/expense_summary.dart';
import 'package:fintrack_app/database.dart';
import 'package:fintrack_app/providers/SettingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void getontheload() {
    expenseStream = Transactionservice().getexpenseDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            const SizedBox(width: 80),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(height: 10),
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
      body: _TransactionList(
        context, // Pass the stable context
        expenseStream,
        _searchController,
        _searchQuery,
      ),
    );
  }
}

Widget _TransactionList(
  BuildContext stableContext,
  Stream<QuerySnapshot>? expenseStream,
  TextEditingController searchController,
  String searchQuery,
) {
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
            expenseData.notifyListeners();
          });

          // Filter transactions based on search query
          List<DocumentSnapshot> filteredDocs = snapshot.hasData
              ? snapshot.data!.docs.where((doc) {
                  String category = doc['category'].toString().toLowerCase();
                  String date = DateFormat('MMM d yyyy     hh:mm a')
                      .format(doc['date'].toDate())
                      .toLowerCase();
                  return category.contains(searchQuery) ||
                      date.contains(searchQuery);
                }).toList()
              : [];

          return ListView(
            children: [
              ExpenseSummary(startOfweek: expenseData.StartOfWeekDate()),
              const SizedBox(height: 20),
              const Text(
                'Transaction History',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CupertinoSearchTextField(
                  controller: searchController,
                  placeholder: 'Search by Category or Date',
                ),
              ),
              // Check if there are filtered transactions
              filteredDocs.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = filteredDocs[index];
                        return Slidable(
                          endActionPane:
                              ActionPane(motion: StretchMotion(), children: [
                            SlidableAction(
                              onPressed: (context) async {
                                try {
                                  await Transactionservice()
                                      .deleteTransaction(ds.id);
                                  ScaffoldMessenger.of(stableContext)
                                      .showSnackBar(
                                    // Use stableContext
                                    const SnackBar(
                                        content: Text(
                                            'Transaction deleted successfully')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(stableContext)
                                      .showSnackBar(
                                    // Use stableContext
                                    SnackBar(
                                        content: Text(
                                            'Error deleting transaction: $e')),
                                  );
                                }
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Expense Info',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Category: ${ds['category']}'),
                                          Text('Amount: ${ds['amount']}'),
                                          Text(
                                            'Date: ${DateFormat('MMM d yyyy hh:mm a').format(ds['date'].toDate())}',
                                          ),
                                          Text(
                                              'Notes: ${ds['notes'] ?? 'No notes'}'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icons.info,
                              backgroundColor: Colors.blue,
                            ),
                          ]),
                          child: ListTile(
                            leading:
                                const CircleAvatar(child: Icon(Icons.grade)),
                            title: Text(
                              ds['category'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              DateFormat('MMM d yyyy     hh:mm a')
                                  .format(ds['date'].toDate()),
                            ),
                            trailing: Text(
                              "GHC ${ds['amount'].toString()}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 14),
                            ),
                          ),
                        );
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Text('No Transactions Found'),
                      ),
                    ),
            ],
          );
        },
      );
    },
  );
}
