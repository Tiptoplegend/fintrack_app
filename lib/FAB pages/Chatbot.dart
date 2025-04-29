import 'package:fintrack_app/services/openai_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();


  List<Map<String, String>> _messages = []; // role: user/bot, message
  bool _isLoading = false;
  bool hasStartedChat = false;

  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    String username = user.displayName ?? "User";

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures the keyboard pushes the content up
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

// import 'package:fintrack_app/services/openai_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ChatbotPage extends StatefulWidget {
//   const ChatbotPage({super.key});

//   @override
//   State<ChatbotPage> createState() => _ChatbotPageState();
// }

// class _ChatbotPageState extends State<ChatbotPage> {
//   final TextEditingController _controller = TextEditingController();
//   final OpenaiService _chatService = OpenaiService();

//   List<Map<String, String>> _messages = []; // role: user/bot, message
//   bool _isLoading = false;
//   bool hasStartedChat = false;

//   final user = FirebaseAuth.instance.currentUser!;

//   void _sendMessage() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;

//     setState(() {
//       hasStartedChat = true;
//       _messages.add({'role': 'user', 'message': text});
//       _isLoading = true;
//       _controller.clear();
//     });

//     try {
//       final response = await _chatService.getResponse(text);
//       setState(() {
//         _messages.add({'role': 'bot', 'message': response});
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add({
//           'role': 'bot',
//           'message': 'Something went wrong. Please try again.'
//         });
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String username = user.displayName ?? "User";

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         title: Text(
//           'FinBot',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.access_time_rounded,
//               size: 30,
//             ),
//             onPressed: () {
//               // Action for the clock icon button
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: hasStartedChat
//                   ? ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       reverse: true,
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[_messages.length - 1 - index];
//                         return Align(
//                           alignment: msg['role'] == 'user'
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 6),
//                             padding: const EdgeInsets.all(12),
//                             constraints: BoxConstraints(
//                                 maxWidth:
//                                     MediaQuery.of(context).size.width * 0.75),
//                             decoration: BoxDecoration(
//                               color: msg['role'] == 'user'
//                                   ? Colors.green
//                                   : Colors.grey[800],
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               msg['message'] ?? '',
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 50),
//                         Center(
//                           child: Column(
//                             children: [
//                               Image.asset(
//                                 'assets/images/chat.png',
//                                 width: 150,
//                                 height: 150,
//                               ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 'Hello, $username!\nI Am Ready To Help You',
//                                 style: const TextStyle(
//                                   fontSize: 26,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'inter',
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const Text(
//                                 'Ask me about any financial tip or advice you want, I am here to assist you',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontFamily: 'inter',
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         hintText: 'Type your message here...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide(color: Colors.white),
//                         ),
//                         filled: true,
//                         fillColor: Colors.black,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: _isLoading ? null : _sendMessage,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.black,
//                       child: _isLoading
//                           ? const CircularProgressIndicator(
//                               color: Colors.lightGreen,
//                             )
//                           : const Icon(
//                               Icons.send,
//                               color: Colors.lightGreen,
//                               size: 30,
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
