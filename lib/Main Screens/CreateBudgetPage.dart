import 'package:fintrack_app/FAB%20pages/Categories.dart';
import 'package:fintrack_app/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:fintrack_app/Main%20Screens/BudgetSuccessPage.dart';
import 'package:fintrack_app/Main%20Screens/CalendarPage.dart';

class CreateBudgetPage extends StatefulWidget {
  final int? month;
  final int? year;
  const CreateBudgetPage({super.key, this.month, this.year});

  @override
  State<CreateBudgetPage> createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  final TextEditingController _controller = TextEditingController();
  final intl.NumberFormat _formatter = intl.NumberFormat("#,###"); // <-- Use this format
  final FirestoreService firestoreService = FirestoreService();
  String? _selectedCategory;
  String? _selectedBudgetCycle = 'Daily';
  bool _isUpdatingText = false;

  Category? selectedCategory;
  List<Category> categories = [
    Category(name: "Food", icon: Icons.fastfood),
    Category(name: "Transportation", icon: Icons.directions_car),
    Category(name: "Entertainment", icon: Icons.movie),
    Category(name: "Utilities", icon: Icons.lightbulb),
    Category(name: "Shopping", icon: Icons.shopping_cart),
  ];

  @override
  void initState() {
    super.initState();
    _controller.text = "₵0.00";
    _controller.addListener(() {
      if (_isUpdatingText) return;
      _isUpdatingText = true;

      // Always keep the cedi sign at the start
      String text = _controller.text;
      if (!text.startsWith('₵')) {
        text = '₵${text.replaceAll('₵', '')}';
      }


      String numeric = text.replaceAll('₵', '').replaceAll(',', '');

      if (numeric.isNotEmpty) {
        int? value = int.tryParse(numeric);
        if (value != null && value != 0) {
          String formattedText = '₵${_formatter.format(value)}';
          _controller.value = TextEditingValue(
            text: formattedText,
            selection: TextSelection.collapsed(offset: formattedText.length),
          );
        } else {
          // If value is 0 or invalid, just keep the cedi sign
          _controller.value = const TextEditingValue(
            text: '₵',
            selection: TextSelection.collapsed(offset: 1),
          );
        }
      } else {
        
        _controller.value = const TextEditingValue(
          text: '₵',
          selection: TextSelection.collapsed(offset: 1),
        );
      }

      _isUpdatingText = false;
    });
    _fetchCategories();
  }

  // Fetch the categories from the database
  void _fetchCategories() async {
    var userCategories = await FirestoreService().getCategories();
    if (userCategories != null && mounted) {
      setState(() {
        for (var doc in userCategories) {
          categories.add(Category(name: doc['name'], icon: Icons.category));
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Budget',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF005341),
              Color(0xFF43A047),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 250), // Spacer
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'How much do you want to spend?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 1), // Spacer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
                decoration: InputDecoration(
                  hintText: '₵',
                  hintStyle: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color:Colors.grey
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 19),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Color(0xFF007D3E)),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                          size: 30,
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.name,
                            child: Row(
                              children: [
                                Icon(category.icon,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black),
                                const SizedBox(width: 10),
                                Text(category.name,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black)),
                              ],
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return categories.map((category) {
                            return Row(
                              children: [
                                Icon(category.icon, color: Colors.black),
                                const SizedBox(width: 10),
                                Text(
                                  category.name,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            );
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        value: _selectedCategory,
                      ),
                      const SizedBox(height: 16), // Spacer
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Cycle:',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedBudgetCycle ?? 'Select Cycle',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_month,
                                  color: Colors.black, size: 30),
                              onPressed: () async {
                                String? selectedCycle =
                                    await _CalendarModal(context);
                                if (selectedCycle != null) {
                                  setState(() {
                                    _selectedBudgetCycle = selectedCycle;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16), // Spacer
                      SwitchListTile(
                        contentPadding: const EdgeInsets.only(left: 0),
                        title: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Receive Alert',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        value: true,
                        onChanged: (value) {},
                        activeColor: const Color(0xFF007D3E),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Receive alert when it reaches some point',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Spacer
                      SizedBox(
                        width: 350,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate inputs before proceeding
                            String budgetText = _controller.text
                                .replaceAll('₵', '')
                                .replaceAll(',', '');
                            double? budgetAmount = double.tryParse(budgetText);

                            if (budgetAmount == null || budgetAmount <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    'Please enter budget amount.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            if (_selectedCategory == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    'Please select a category.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            if (_selectedBudgetCycle == null ||
                                _selectedBudgetCycle == 'Select Cycle') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    'Please select a budget cycle.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            final rawAmount = _controller.text.trim();
                            final cleanedAmount =
                                rawAmount.replaceAll(RegExp(r'[^\d.]'), '');

                            final amount =
                                double.tryParse(cleanedAmount) ?? 0.0;
                            // database mapping for budget
                            String userId =
                                FirebaseAuth.instance.currentUser!.uid;
                            Map<String, dynamic> budgetinfoMap = {
                              "userId": userId,
                              "budgetAmount": amount,
                              "category": _selectedCategory,
                              "cycle": _selectedBudgetCycle,
                              "Month": widget.month ?? DateTime.now().month,
                              "Year": widget.year ?? DateTime.now().year,
                              "createdAt": DateTime.timestamp(),
                            };
                            await Budgetservice().addbudget(budgetinfoMap);
                      
                              Navigator.push(
                               context,
                              PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500), // slower transition
                              pageBuilder: (context, animation, secondaryAnimation) => const BudgetSuccessPage(),
                               transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0); // Slide from right
                                const end = Offset.zero;
                                 const curve = Curves.ease;
                                final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                return SlideTransition(
                                position: animation.drive(tween),
                                  child: child,
                              );
                            },
                            ),
                           );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007D3E),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _CalendarModal(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.9,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: CalendarPage(
            onCycleSelected: (cycle) {
              Navigator.pop(context, cycle);
            },
          ),
        ),
      ),
    );
  }
}
