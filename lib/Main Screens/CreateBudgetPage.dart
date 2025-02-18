import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

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
    _controller.text = "₵"; // Start with the Cedi symbol

    _controller.addListener(() {
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
        backgroundColor: const Color(0xFF007D3E),
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
        color: const Color(0xFF007D3E),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 200),
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
            const SizedBox(height: 1),
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
                style: TextStyle(
                  color: _selectedCategory != null
                      ? categoryColors[_selectedCategory] ?? Colors.white
                      : Colors.white,
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 15),
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
                        style: const TextStyle(color: Colors.black),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                        items: categoryIcons.keys.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: categoryColors[category]!.withOpacity(0.2),
                                  child: Icon(categoryIcons[category], color: categoryColors[category]),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
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
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Budget Cycle',
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
                        style: const TextStyle(color: Colors.black),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                        items: const [
                          DropdownMenuItem(
                            value: 'Daily',
                            child: Text(
                              'Daily',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Weekly',
                            child: Text(
                              'Weekly',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Monthly',
                            child: Text(
                              'Monthly',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedBudgetCycle = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: const EdgeInsets.only(left: 0),
                        title: Align(
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
                        activeColor: Color(0xFF007D3E),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Receive alert when it reaches some point',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
}