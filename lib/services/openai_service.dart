// import 'dart:convert';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class OpenaiService {
//   final _apikey = dotenv.env['OPENAI_API_KEY'];
//   final _url = 'https://api.openai.com/v1/chat/completions';

//   Future<String> getResponse(String message) async {
//     // print('API KEY: $_apikey');

//     final response = await http.post(
//       Uri.parse(_url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $_apikey'
//       },
//       body: jsonEncode({
//         "model": "gpt-3.5-turbo",
//         "messages": [
//           {
//             "role": "system",
//             "content":
//                 "You are FinBot, a helpful financial assistant. You give financial advice, budgeting tips, saving techniques, and explain how to manage money wisely."
//           },
//           {"role": "user", "content": message}
//         ]
//       }),
//     );

//     // if (response.statusCode == 200) {
//     //   final json = jsonDecode(response.body);
//     //   return json['choices'][0]['message']['content'];
//     // } else {
//     //   throw Exception("Failed to get response from OpenAI");
//     // }
//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);
//       return json['choices'][0]['message']['content'];
//     } else {
//       print('Error Status: ${response.statusCode}');
//       print('Error Body: ${response.body}');
//       throw Exception("Failed to get response from OpenAI");
//     }
//   }
// }
