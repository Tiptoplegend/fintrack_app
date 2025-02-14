import 'package:fintrack_app/database.dart';
import 'package:flutter/material.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
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
      body: Stack(
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

  final GoalService goalService = GoalService();
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
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
                String title = titleController.text;
                double amount = double.parse(amountController.text) ?? 0;

                if (title.isNotEmpty && amount > 0) {
                  goalService.addGoal(title, amount);
                  Navigator.pop(context);
                }
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
