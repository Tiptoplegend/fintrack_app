import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  Stream? Goalstream;
  void getontheload() {
    Goalstream = GoalsService().getGoalsDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getontheload();
  }

  final user = FirebaseAuth.instance.currentUser!;
  final userimg = FirebaseAuth.instance.currentUser!.photoURL;

  Widget GoalsDetails() {
    return Expanded(
      child: StreamBuilder(
        stream: Goalstream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                Center(
                  child: Image.asset('assets/images/Goals.png',
                      width: 270, height: 270),
                ),
                Text(
                  "No Goals Have been Added",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }

          final docs = snapshot.data.docs;
          final firstGoal = docs[0];
          final remainingGoals = docs.length > 1 ? docs.sublist(1) : [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full-width first goal
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          // Add this
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: 100,
                                animationDuration: 1000,
                                lineWidth: 15,
                                percent: 0.7, // 70%
                                animation: true,
                                circularStrokeCap: CircularStrokeCap.round,
                                backgroundColor: Colors.grey,
                                progressColor: Colors.green,
                                center: Column(
                                  children: [
                                    const SizedBox(height: 30),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          firstGoal['title'],
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '\₵${(firstGoal['amount'])}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                arcType: ArcType.HALF,
                                arcBackgroundColor: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Wrap for remaining goals
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: remainingGoals.map<Widget>((doc) {
                      DocumentSnapshot ds = doc;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 24,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ds['title'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '\₵${ds['amount']}',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: LinearProgressIndicator(
                                    minHeight: 14,
                                    value: 0.5,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('0% Saved'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

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
              radius: 25,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage("assets/images/icons8-user-48 (1).png")
                      as ImageProvider,
            ),
            const SizedBox(width: 110),
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
          GoalsDetails(),
          _CreateGoalbtn(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

Widget _CreateGoalbtn(BuildContext context) {
  TextEditingController TitleController = TextEditingController();
  TextEditingController AmountController = TextEditingController();
  return Center(
    child: SizedBox(
      width: 350,
      child: ElevatedButton(
        onPressed: () {
          // Code for modal will be here
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Title of the modal
                        const Text(
                          'Add New Goal',
                          style: TextStyle(fontSize: 18),
                        ),

                        // Goal title
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: TextField(
                            controller: TitleController,
                            keyboardType: TextInputType.text, // Text keyboard
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2,
                                ),
                              ),
                              hintText: 'Goal Title (eg. Car, House)',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Goal amount title
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Goal Amount',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // TextField for amount
                        //
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: TextField(
                            controller: AmountController,
                            keyboardType:
                                TextInputType.number, // Numeric keyboard
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2,
                                ),
                              ),
                              hintText: 'Enter the amount',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Code to add goal will be here
                              Map<String, dynamic> goalsInfoMap = {
                                'userId':
                                    FirebaseAuth.instance.currentUser!.uid,
                                'title': TitleController.text,
                                'amount': AmountController.text,
                                // 'timestamp': FieldValue.serverTimestamp(),
                              };
                              await GoalsService().addGoals(goalsInfoMap);

                              Navigator.pop(context); // Close the modal
                              // Clear the text fields after adding the goal
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.green[600],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text(
                              'Add Goal',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.green[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Create Goal',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
