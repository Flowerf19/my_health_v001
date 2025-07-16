import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/chat_message_model.dart'; // Đảm bảo tên file thống nhất
import 'database_service.dart';

class GeminiService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY']!;
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  // Danh sách lưu chat history cục bộ
  List<ChatMessage> chatHistory = [];

  // Tạo instance của DatabaseService để lưu dữ liệu lên Firestore
  final DatabaseService _databaseService = DatabaseService();

  /// Hàm gửi tin nhắn đến Gemini API.
  /// Sau khi nhận phản hồi từ Gemini, tin nhắn của người dùng và bot
  /// được lưu vào chatHistory cục bộ và đồng thời được lưu lên database Firestore
  /// theo user được cung cấp thông qua [userId].
  Future<String> sendMessage(String message, String senderId, String userId) async {
    try {
      // Tạo đối tượng ChatMessage cho tin nhắn người dùng
      ChatMessage userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        senderId: senderId,
        timestamp: DateTime.now(),
        isBot: false,
      );

      // Lưu tin nhắn người dùng vào danh sách cục bộ
      chatHistory.add(userMessage);
      // Lưu tin nhắn người dùng vào database theo userId
      await _databaseService.addChatMessage(userId, userMessage);

      // Gửi request tới Gemini API
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botResponse = data['candidates'][0]['content']['parts'][0]['text'];

        // Tạo đối tượng ChatMessage cho tin nhắn của bot
        ChatMessage botMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: botResponse,
          senderId: 'bot', // Giả sử senderId của bot là 'bot'
          timestamp: DateTime.now(),
          isBot: true,
        );

        // Lưu tin nhắn bot vào danh sách cục bộ
        chatHistory.add(botMessage);
        // Lưu tin nhắn bot vào database theo userId
        await _databaseService.addChatMessage(userId, botMessage);

        return botResponse;
      } else {
        throw Exception('Failed to send message: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Phương thức lấy lịch sử chat cục bộ (nếu cần)
  List<ChatMessage> getChatHistory() => chatHistory;
}
