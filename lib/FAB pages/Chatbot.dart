
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    String username = user.displayName ?? "User";

    return Scaffold(
      resizeToAvoidBottomInset:
          true, 
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'FinBot',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.access_time_rounded,
              size: 30,
            ),
            onPressed: () {
              // Action for the clock icon button
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Fixed content: Image and text
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50), // Add spacing from the top
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/chat.png',
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(
                          height: 10), // Adjust spacing between image and text
                      Text(
                        'Hello, $username!\nI Am Ready To Help You',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Ask me about any financial tip or advice you want, i am here to assist  you',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Scrollable content: TextField
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                reverse:
                    true, // Ensures the TextField stays visible when the keyboard opens
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type your message here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.send,
                            color: Colors.lightGreen,
                            size: 30,
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
