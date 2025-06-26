// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fintrack_app/FAB%20pages/Categories.dart';
// import 'package:fintrack_app/Main%20Screens/Goals.dart';
// import 'package:fintrack_app/Navigation.dart';
// import 'package:fintrack_app/database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';

// class TransactionPage extends StatefulWidget {
//   const TransactionPage({super.key});

//   @override
//   State<TransactionPage> createState() => _TransactionPageState();
// }

// class _TransactionPageState extends State<TransactionPage> {
//   Stream<QuerySnapshot>? GoalsStream;

//   bool _isSwitched = false;

//   Goals? selectedGoal;
//   Category? selectedCategory;
//   List<Category> categories = [
//     Category(name: "Food", icon: Icons.fastfood),
//     Category(name: "Transportation", icon: Icons.directions_car),
//     Category(name: "Entertainment", icon: Icons.movie),
//     Category(name: "Utilities", icon: Icons.lightbulb),
//     Category(name: "Shopping", icon: Icons.shopping_cart),
//     Category(name: "Goals/Savings", icon: Icons.track_changes),
//   ];

//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _NotesController = TextEditingController();
//   final FirestoreService firestoreService = FirestoreService();

//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories();
//     _amountController.addListener(_formatAmount);
//     getontheload();
//   }

//   void _fetchCategories() async {
//     var userCategories = await FirestoreService().getCategories();
//     if (userCategories != null) {
//       setState(() {
//         for (var doc in userCategories) {
//           categories.add(Category(name: doc['name'], icon: Icons.category));
//         }
//       });
//     }
//   }

//   void _formatAmount() {
//     String text = _amountController.text.replaceAll(',', '');
//     if (text.isNotEmpty) {
//       _amountController.value = _amountController.value.copyWith(
//         text: NumberFormat('#,###').format(int.parse(text)),
//         selection:
//             TextSelection.collapsed(offset: _amountController.text.length),
//       );
//     }
//   }

//   void getontheload() {
//     GoalsStream = GoalsService().getGoalsDetails();
//     setState(() {});
//   }

//   // Function to show the category selection modal
//   void _showCategoryModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           height: MediaQuery.of(context).size.height * 0.6, // Modal height
//           child: Column(
//             children: [
//               Text(
//                 "Select Category",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: categories.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       leading:
//                           Icon(categories[index].icon, color: Colors.green),
//                       title: Text(categories[index].name),
//                       onTap: () {
//                         setState(() {
//                           selectedCategory = categories[index];
//                         });
//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

// // modal to show goals
//   void showgoalmodal() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return StreamBuilder(
//           stream: GoalsStream,
//           builder: (context, AsyncSnapshot snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return Center(child: Text('No Goals Found'));
//             }

//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     'Select Goals',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot ds = snapshot.data!.docs[index];
//                       return ListTile(
//                         leading: Icon(Icons.track_changes_sharp,
//                             color: Colors.green),
//                         title: Text(ds['title']),
//                         trailing: Text(
//                           'Target Amount: GHC ${ds['amount'] ?? '0'}',
//                           style: TextStyle(fontSize: 14, color: Colors.green),
//                         ),
//                         onTap: () {
//                           setState(() {
//                             selectedGoal = Goals(
//                               title: ds['title'],
//                               amount: ds['amount'],
//                             );
//                           });
//                           Navigator.pop(context);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _NotesController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight),
//         child: AppBar(
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF005341), Color(0xFF43A047)],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//             ),
//           ),
//           title: const Text('Transactions'),
//           centerTitle: true,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _textfield(),
//             SizedBox(height: 20),
//             _notesection(),
//             SizedBox(height: 20),
//             _CatGoalsbtn(),
//             SizedBox(height: 30),
//             _addtobudget(),
//             Spacer(),
//             _Continuebtn(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _textfield() {
//     return TextField(
//       controller: _amountController,
//       keyboardType: TextInputType.number,
//       style: TextStyle(fontSize: 30),
//       decoration: InputDecoration(
//         prefixIcon: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child:
//               Text('GHC', style: TextStyle(fontSize: 25, color: Colors.white)),
//         ),
//         suffixIcon: Icon(Icons.attach_money_outlined),
//         hintText: '0.00',
//         hintStyle: TextStyle(color: Colors.grey, fontSize: 25),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.transparent),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.grey[200]!),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.green),
//         ),
//       ),
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//       ],
//     );
//   }

//   Widget _notesection() {
//     return TextField(
//       controller: _NotesController,
//       style: TextStyle(fontSize: 14),
//       decoration: InputDecoration(
//         suffixIcon: Icon(Icons.note_add_outlined),
//         hintText: 'Notes (Optional)',
//         hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }

//   Widget _CatGoalsbtn() {
//     // goalsbtn
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () {
//             showgoalmodal();
//           },
//           style: ElevatedButton.styleFrom(
//             minimumSize: Size(150, 60),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             backgroundColor: Color(Colors.green.value),
//           ),
//           icon: selectedGoal != null
//               ? Icon(Icons.track_changes_sharp,
//                   color: Color(Colors.white.value))
//               : Icon(Icons.track_changes_sharp,
//                   color: Color(Colors.white.value)),
//           label: Text(selectedGoal?.title ?? "Select Goal",
//               style: TextStyle(color: Colors.white)),
//         ),
//         // categorybtn
//         ElevatedButton.icon(
//           onPressed: _showCategoryModal,
//           style: ElevatedButton.styleFrom(
//             minimumSize: Size(150, 60),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             backgroundColor: Color(Colors.green.value),
//           ),
//           icon: selectedCategory != null
//               ? Icon(selectedCategory!.icon, color: Color(Colors.white.value))
//               : Icon(Icons.category, color: Color(Colors.white.value)),
//           label: Text(selectedCategory?.name ?? "Categories",
//               style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }

//   Widget _addtobudget() {
//     return ListTile(
//       leading: Icon(Icons.monetization_on, color: Colors.green),
//       title: Text('Add to Budget'),
//       trailing: Switch(
//         value: _isSwitched,
//         activeColor: Colors.green,
//         onChanged: (value) {
//           // Handle switch change
//           setState(() {
//             _isSwitched = value;
//           });
//         },
//       ),
//     );
//   }

//   Widget _Continuebtn() {
//     return ElevatedButton(
//       onPressed: () async {
//         _saveExpense();

//         Map<String, dynamic> expenseInfoMap = {
//           'amount': _amountController.text,
//           'category': selectedCategory!.name,
//           'icon': selectedCategory!.icon?.codePoint,
//           'notes': _NotesController.text,
//           'date': DateTime.now(),
//           'userId': FirebaseAuth.instance.currentUser!.uid,
//           'linktobudget': _isSwitched,
//           'linktogoal': selectedGoal?.title,
//           'Month': DateTime.now().month,
//           'Year': DateTime.now().year,
//         };
//         await Transactionservice().addTransaction(expenseInfoMap);
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color(Colors.green.value),
//         minimumSize: Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//       child: Text(
//         'Continue',
//         style: TextStyle(fontSize: 16, color: Colors.white),
//       ),
//     );
//   }

//   void _saveExpense() {
//     if (_amountController.text.isEmpty || selectedCategory == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please enter an amount and select a category'),
//         ),
//       );
//       return;
//     }
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Navigation(selectedIndex: 1),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/FAB%20pages/Categories.dart';
import 'package:fintrack_app/Main%20Screens/Goals.dart';
import 'package:fintrack_app/Navigation.dart';
import 'package:fintrack_app/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  Stream<QuerySnapshot>? GoalsStream;

  bool _isSwitched = false;

  Goals? selectedGoal;
  Category? selectedCategory;
  List<Category> categories = [
    Category(name: "Food", icon: Icons.fastfood),
    Category(name: "Transportation", icon: Icons.directions_car),
    Category(name: "Entertainment", icon: Icons.movie),
    Category(name: "Utilities", icon: Icons.lightbulb),
    Category(name: "Shopping", icon: Icons.shopping_cart),
    Category(name: "Goals/Savings", icon: Icons.track_changes),
  ];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _NotesController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _amountController.addListener(_formatAmount);
    getontheload();
  }

  void _fetchCategories() async {
    var userCategories = await FirestoreService().getCategories();
    if (userCategories != null) {
      setState(() {
        for (var doc in userCategories) {
          categories.add(Category(name: doc['name'], icon: Icons.category));
        }
      });
    }
  }

  void _formatAmount() {
    String text = _amountController.text.replaceAll(',', '');
    if (text.isNotEmpty) {
      try {
        double amount = double.parse(text);
        _amountController.value = _amountController.value.copyWith(
          text: NumberFormat('#,###').format(amount.toInt()),
          selection:
              TextSelection.collapsed(offset: _amountController.text.length),
        );
      } catch (e) {
        print('Error formatting amount: $e');
        // Optionally clear or reset the text
      }
    }
  }

  void getontheload() {
    GoalsStream = GoalsService().getGoalsDetails();
    setState(() {});
  }

  void _showCategoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Text(
                "Select Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading:
                          Icon(categories[index].icon, color: Colors.green),
                      title: Text(categories[index].name),
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showgoalmodal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder(
          stream: GoalsStream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No Goals Found'));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select Goals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return ListTile(
                        leading: Icon(Icons.track_changes_sharp,
                            color: Colors.green),
                        title: Text(ds['title']),
                        trailing: Text(
                          'Target Amount: GHC ${ds['amount'] ?? '0'}',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                        onTap: () {
                          setState(() {
                            selectedGoal = Goals(
                              title: ds['title'],
                              amount: ds['amount'],
                            );
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatAmount);
    _amountController.dispose();
    _NotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF005341), Color(0xFF43A047)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: const Text('Transactions'),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _textfield(),
            SizedBox(height: 20),
            _notesection(),
            SizedBox(height: 20),
            _CatGoalsbtn(),
            SizedBox(height: 30),
            _addtobudget(),
            Spacer(),
            _Continuebtn(),
          ],
        ),
      ),
    );
  }

  Widget _textfield() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 30),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Text('GHC', style: TextStyle(fontSize: 25, color: Colors.white)),
        ),
        suffixIcon: Icon(Icons.attach_money_outlined),
        hintText: '0.00',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget _notesection() {
    return TextField(
      controller: _NotesController,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.note_add_outlined),
        hintText: 'Notes (Optional)',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _CatGoalsbtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            showgoalmodal();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(150, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Color(Colors.green.value),
          ),
          icon: selectedGoal != null
              ? Icon(Icons.track_changes_sharp,
                  color: Color(Colors.white.value))
              : Icon(Icons.track_changes_sharp,
                  color: Color(Colors.white.value)),
          label: Text(selectedGoal?.title ?? "Select Goal",
              style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton.icon(
          onPressed: _showCategoryModal,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(150, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Color(Colors.green.value),
          ),
          icon: selectedCategory != null
              ? Icon(selectedCategory!.icon, color: Color(Colors.white.value))
              : Icon(Icons.category, color: Color(Colors.white.value)),
          label: Text(selectedCategory?.name ?? "Categories",
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _addtobudget() {
    return ListTile(
      leading: Icon(Icons.monetization_on, color: Colors.green),
      title: Text('Add to Budget'),
      trailing: Switch(
        value: _isSwitched,
        activeColor: Colors.green,
        onChanged: (value) {
          setState(() {
            _isSwitched = value;
          });
        },
      ),
    );
  }

  Widget _Continuebtn() {
    return ElevatedButton(
      onPressed: () async {
        if (_amountController.text.isEmpty || selectedCategory == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enter an amount and select a category'),
            ),
          );
          return;
        }

        // Remove commas and parse as double
        String cleanedAmount = _amountController.text.replaceAll(',', '');
        double amount;
        try {
          amount = double.parse(cleanedAmount);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid amount format')),
          );
          return;
        }

        Map<String, dynamic> expenseInfoMap = {
          'amount': amount, // Store as double
          'category': selectedCategory!.name,
          'icon': selectedCategory!.icon?.codePoint,
          'notes': _NotesController.text,
          'date': DateTime.now(),
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'linktobudget': _isSwitched,
          'linktogoal': selectedGoal?.title,
          'Month': DateTime.now().month,
          'Year': DateTime.now().year,
        };

        try {
          await Transactionservice().addTransaction(expenseInfoMap);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Navigation(selectedIndex: 1),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving transaction: $e')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(Colors.green.value),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        'Continue',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
