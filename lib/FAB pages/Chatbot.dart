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
  final GeminiService _geminiService = GeminiService();

  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool hasStartedChat = false;

  final user = FirebaseAuth.instance.currentUser!;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    _controller.clear();

    if (text.isEmpty) return;

    setState(() {
      // Add the user's message to the list
      _messages.add({'role': 'user', 'message': text});
      _isLoading = true;
      hasStartedChat = true;
    });

    _scrollToBottom();

    try {
      final botResponse = await _geminiService.sendMessage(text);

      setState(() {
        _messages.add({'role': 'bot', 'message': botResponse});
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'message':
              'Oops! FinBot encountered an error. Please try again or check your internet connection.'
        });
        _isLoading = false;
      });
      _scrollToBottom();
      print('Error sending message to FinBot: $e');
    }
  }

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
    String username = user.displayName ?? "User";

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
              setState(() {
                _messages.clear();
                _geminiService.clearChat();
                hasStartedChat = false;
              });
            },
          ),
        ],
      ),
      // body: SafeArea(
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: _messages.isEmpty && !hasStartedChat
      //             ? _buildWelcomeMessage(username)
      //             : _buildChatMessages(),
      //       ),
      //       _buildMessageInput(), //
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: _messages.isEmpty && !hasStartedChat
                  ? _buildWelcomeMessage(username)
                  : _buildChatMessages(),
            ),
            // Input field
            _buildMessageInput(),
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
                'assets/images/chat.png',
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
              const SizedBox(height: 10),
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
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
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
      padding: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 10,
        top: 20.0,
      ),
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
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
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
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.send,
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
