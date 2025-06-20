import 'package:fintrack_app/services/gemini_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService =
      GeminiService(); // <--- Instantiate your service

  final List<Map<String, String>> _messages = []; // role: user/bot, message
  bool _isLoading = false; // <--- This needs to be mutable
  bool hasStartedChat = false;

  final user = FirebaseAuth.instance.currentUser!;

  // Add a ScrollController to automatically scroll to the bottom of the chat list
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController
        .dispose(); // Don't forget to dispose the scroll controller!
    super.dispose();
  }

  /// Sends the user's message to FinBot and handles the response.
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    _controller.clear(); // Clear the input field immediately

    if (text.isEmpty) return; // Don't send empty messages

    setState(() {
      // Add the user's message to the list
      _messages.add({'role': 'user', 'message': text});
      _isLoading = true; // Show loading indicator
      hasStartedChat = true; // Transition to chat history view if not already
    });

    // Scroll to the bottom immediately after adding the user's message
    _scrollToBottom();

    try {
      // Send the message to the GeminiService and await the bot's response
      final botResponse = await _geminiService.sendMessage(text);

      setState(() {
        // Add FinBot's response to the list
        _messages.add({'role': 'bot', 'message': botResponse});
        _isLoading = false; // Hide loading indicator
      });
      // Scroll to the bottom after FinBot responds
      _scrollToBottom();
    } catch (e) {
      // Handle any errors that occur during the API call
      setState(() {
        _messages.add({
          'role': 'bot',
          'message':
              'Oops! FinBot encountered an error. Please try again or check your internet connection.'
        });
        _isLoading = false; // Hide loading indicator
      });
      _scrollToBottom();
      print(
          'Error sending message to FinBot: $e'); // Log the error for debugging
    }
  }

  /// Scrolls the ListView to the bottom to show the latest message.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String username = user.displayName ?? "User"; // Get the user's display name

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'FinBot',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.access_time_rounded,
              size: 30,
            ),
            onPressed: () {
              // Action for the clock icon button: Clear chat history
              setState(() {
                _messages.clear(); // Clear messages displayed in UI
                _geminiService.clearChat(); // Clear Gemini's session history
                hasStartedChat = false; // Show welcome message again
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          // Use Column instead of Stack for better flow
          children: [
            // Conditionally display either the welcome message or the chat messages
            Expanded(
              child: _messages.isEmpty && !hasStartedChat
                  ? _buildWelcomeMessage(username) // Initial welcome UI
                  : _buildChatMessages(), // Actual chat messages UI
            ),
            _buildMessageInput(), // The message input field at the bottom
          ],
        ),
      ),
    );
  }

  /// Builds the initial welcome message UI before any chat starts.
  Widget _buildWelcomeMessage(String username) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/chat.png', // Ensure this path is correct
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 10),
              Text(
                'Hello, $username!\nI Am Ready To Help You',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10), // Added a small space
              Text(
                'Ask me about any financial tip or advice you want, I am here to assist you',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'inter',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the ListView for displaying chat messages.
  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController, // Attach the scroll controller
      padding: const EdgeInsets.all(16.0),
      // Add 1 to itemCount if loading, to reserve space for the loading indicator
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          // This is the loading indicator at the end of the list
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
                SizedBox(width: 10),
                Text("FinBot is thinking...",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          );
        }

        final message = _messages[index];
        final isUser = message['role'] == 'user';

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isUser
                  ? Colors.lightGreen.withOpacity(0.8)
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              message['message']!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  /// Builds the input field and send button for messages.
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  // Style when not focused
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  // Style when focused
                  borderRadius: BorderRadius.circular(25),
                  borderSide:
                      const BorderSide(color: Colors.lightGreen, width: 2),
                ),
                filled: true,
                fillColor: Colors.black,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) =>
                  _sendMessage(), // Send message when Enter is pressed
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            // Disable the send button if a message is currently being processed
            onTap: _isLoading ? null : _sendMessage,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.send,
                // Change icon color based on loading state
                color: _isLoading ? Colors.grey : Colors.lightGreen,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
