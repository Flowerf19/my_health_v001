import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatMessengerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Gửi tin nhắn
  Future<void> sendMessage(String message) async {
    try {
      final User user = _auth.currentUser!;
      await _firestore.collection('messages').add({
        'message': message,
        'senderId': user.uid,
        'timestamp': DateTime.now(),
        'isBot': false, // Tin nhắn từ người dùng
      });
    } catch (e) {
      print('Lỗi khi gửi tin nhắn: $e');
    }
  }

  // Nhận tin nhắn
  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Gửi tin nhắn từ chatbot
  Future<void> sendBotMessage(String message) async {
    try {
      await _firestore.collection('messages').add({
        'message': message,
        'senderId': 'bot', // ID của chatbot
        'timestamp': DateTime.now(),
        'isBot': true, // Tin nhắn từ chatbot
      });
    } catch (e) {
      print('Lỗi khi gửi tin nhắn từ chatbot: $e');
    }
  }

  // Xóa lịch sử chat
  Future<void> clearChatHistory() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('messages').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Lỗi khi xóa lịch sử chat: $e');
    }
  }
}
