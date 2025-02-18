import 'package:fintrack_app/database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  final FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/user.png"),
            ),
            const SizedBox(width: 120),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Goals',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Positioned(
            top: 580,
            left: 33,
            child: _creategoalsbtn(context),
          ),
        ],
      ),
    );
  }
}

Widget _creategoalsbtn(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(3),
    child: ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext modalContext) => _modalbottom(modalContext),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(Colors.green.value),
        minimumSize: Size(340, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        'Create New Goal',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    ),
  );
}

// the menu that shows when you click the creatbtn
Widget _modalbottom(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add new Goal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            // textfield for title dey here
            TextField(
              controller: titleController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Goal Title',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // textfeild for amount dey here
                    child: Text(
                      'Goal Amount',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: amountController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      prefixText: 'GHc',
                      prefixStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      hintText: '0.00',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // createbtn dey here
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')));
                  return;
                }
                // the logic that handles the creation of the goals de start from here
                final newGoal = Goal(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  targetAmount: double.parse(amountController.text),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(Colors.green.value),
                minimumSize: Size(340, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Create Goal',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class Goal {
  String id;
  String title;
  double targetAmount;
  double savedAmount;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.savedAmount = 0.0,
  });

  double get progressPercentage => (savedAmount / targetAmount).clamp(0.0, 1.0);
}

class Goalcard extends StatelessWidget {
  final Goal goal;
  final bool isWide;
  const Goalcard({super.key, required this.goal, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'GHC $goal.targetAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: goal.progressPercentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 5,
          ),
          SizedBox(height: 8),
          Text(
            '${(goal.progressPercentage * 100).toStringAsFixed(0)}% saved',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
