import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:fintrack_app/Main%20Screens/BudgetSuccessPage.dart';
import 'package:fintrack_app/Main%20Screens/CalendarPage.dart';

class CreateBudgetPage extends StatefulWidget {
  const CreateBudgetPage({super.key});

  @override
  State<CreateBudgetPage> createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  final TextEditingController _controller = TextEditingController();
  final intl.NumberFormat _formatter = intl.NumberFormat("#,##0.##");
  String? _selectedCategory;
  String? _selectedBudgetCycle = 'Daily';
  bool _isUpdatingText = false;

  final Map<String, IconData> categoryIcons = {
    'Food': Icons.fastfood,
    'Transport': Icons.directions_bus,
    'Entertainment': Icons.movie,
    'Health': Icons.local_hospital,
    'Shopping': Icons.shopping_cart,
  };

  final Map<String, Color> categoryColors = {
    'Food': Colors.orange,
    'Transport': Colors.blue,
    'Entertainment': Colors.purple,
    'Health': Colors.red,
    'Shopping': Colors.green,
  };

  @override
  void initState() {
    super.initState();
    _controller.text = "₵";

    _controller.addListener(() {
      if (_isUpdatingText) return;
      _isUpdatingText = true;

      String text = _controller.text.replaceAll('₵', '').replaceAll(',', '');
      if (text.isNotEmpty) {
        double? value = double.tryParse(text);
        if (value != null) {
          String formattedText = '₵${_formatter.format(value)}';
          _controller.value = TextEditingValue(
            text: formattedText,
            selection: TextSelection.collapsed(offset: formattedText.length),
          );
        }
      } else {
        _controller.text = "₵";
        _controller.selection = const TextSelection.collapsed(offset: 1);
      }

      _isUpdatingText = false;
    });
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
                  hintText: '₵0',
                  hintStyle: TextStyle(
                    color: _selectedCategory != null
                        ? categoryColors[_selectedCategory] ?? Colors.white
                        : Colors.white,
                    fontSize: 30,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
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
                        items: categoryIcons.keys.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: categoryColors[category]!
                                      .withOpacity(0.2),
                                  child: Icon(
                                    categoryIcons[category],
                                    color: categoryColors[category],
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return categoryIcons.keys.map((category) {
                            return Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: categoryColors[category]!
                                      .withOpacity(0.2),
                                  child: Icon(
                                    categoryIcons[category],
                                    color: categoryColors[category],
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.black, 
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
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
                          onPressed: () {
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
                                    'Please enter a valid budget amount.',
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

                            // Navigate to BudgetSuccessPage if all validations pass
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BudgetSuccessPage(),
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