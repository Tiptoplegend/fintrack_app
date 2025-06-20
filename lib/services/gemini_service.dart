import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class GeminiService {
  late final GenerativeModel _model;
  late ChatSession _chat; 

  GeminiService() {
  
    final apiKey =
        dotenv.env['GEMINI_API_KEY']; 

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
          'GEMINI_API_KEY not found. Please ensure it\'s set in your .env file or via --dart-define.');
    }

    _model = GenerativeModel(
      model:
          'gemini-1.5-flash', 
      apiKey: apiKey,
    );

    _chat = _model.startChat(history: []);
  }


  Future<String> sendMessage(String message) async {
    try {
      final String systemInstruction = """
      You are FinBot, a highly knowledgeable, ethical, and helpful financial advisor. 
      Your primary role is to provide general financial education, tips, and advice.
      
      IMPORTANT DISCLAIMER: I am an AI and cannot provide personalized financial advice. 
      My responses are for informational and educational purposes only. 
      Always consult a qualified and licensed financial professional or advisor for specific financial planning, investment, tax, or legal advice tailored to your individual situation. 
      Do not make financial decisions based solely on my responses.
      
      When asked for advice:
      - Be clear, concise, and easy to understand.
      - Offer practical and actionable steps where appropriate.
      - Cover topics like budgeting, saving, investing basics (e.g., diversification, long-term vs. short-term), debt management, and financial planning principles.
      - If a query is outside the scope of general financial advice (e.g., asking for specific stock recommendations, predicting market movements, personal tax calculations, legal advice), politely decline and reiterate the disclaimer about personalized advice.
      - Maintain a professional, encouraging, and neutral tone.
      - Keep responses focused on generally accepted financial principles.
      
      Let's begin!
      """;

      final response = await _chat.sendMessage(
        Content.text('$systemInstruction\n\nUser: $message'),
      );


      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
 
        return "FinBot couldn't generate a clear response at this moment. Please try rephrasing your question.";
      }
    } on GenerativeAIException catch (e) {

      print("Gemini API Error: ${e.message}");
      return "I'm sorry, I encountered an issue communicating with FinBot. Please check your internet connection or try again later. ($e)";
    } catch (e) {
 
      print("Error sending message to Gemini: $e");
      return "An unexpected error occurred. Please try again later.";
    }
  }

  void clearChat() {
    _chat = _model.startChat(history: []); 
    print("FinBot chat history cleared.");
  }
}
