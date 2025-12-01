// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../features/health_connect/models/biometric_model.dart';
import '../models/chat_message_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _biometricCollection =>
      _firestore.collection('biometric_history');

  // CREATE: Thêm dữ liệu biometric
  Future<void> addBiometricData({
    required String userId,
    required BiometricHistory data,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('biometric_history')
          .add(data.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi thêm dữ liệu: $e");
      }
      rethrow;
    }
  }

  // // READ: Lấy toàn bộ lịch sử (realtime)
  // Stream<List<BiometricHistory>> getBiometricHistory(String userId) {
  //   return _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('biometric_history')
  //       .orderBy('date', descending: true) // Sắp xếp theo ngày
  //       .snapshots()
  //       .map(
  //         (snapshot) =>
  //             snapshot.docs
  //                 .map(
  //                   (doc) => BiometricHistory.fromFirestore(doc.data(), doc.id),
  //                 )
  //                 .toList(),
  //       );
  // }

  // UPDATE
  Future<void> updateBiometricData({
    required String userId,
    required String entryId,
    required BiometricHistory newData,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('biometric_history')
          .doc(entryId)
          .update(newData.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi cập nhật: $e");
      }
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteBiometricData({
    required String userId,
    required String entryId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('biometric_history')
          .doc(entryId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi xóa: $e");
      }
      rethrow;
    }
  }

  // CREATE: Thêm tin nhắn vào lịch sử chat
  Future<void> addChatMessage(String userId, message) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('ChatMessage')
          .add(message.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi thêm tin nhắn: $e");
      }
      rethrow;
    }
  }

  Stream<List<ChatMessage>> getChatHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('ChatMessage')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // READ: Lấy lịch sử chat từ một thời điểm cụ thể (phục vụ tiếp tục cuộc trò chuyện)
  Future<List<ChatMessage>> getChatHistoryFromTimestamp(
    String userId,
    DateTime timestamp,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('ChatMessage')
          .where('timestamp', isGreaterThanOrEqualTo: timestamp)
          .orderBy('timestamp', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi lấy lịch sử chat: $e");
      }
      rethrow;
    }
  }

  // UPDATE: Cập nhật tin nhắn (nếu cần)
  Future<void> updateChatMessage({
    required String userId,
    required String messageId,
    required ChatMessage newMessage,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('ChatMessage')
          .doc(messageId)
          .update(newMessage.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi cập nhật tin nhắn: $e");
      }
      rethrow;
    }
  }

  // DELETE: Xóa tin nhắn (nếu cần)
  Future<void> deleteChatMessage({
    required String userId,
    required String messageId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('ChatMessage')
          .doc(messageId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi xóa tin nhắn: $e");
      }
      rethrow;
    }
  }

  // Add new biometric history
  Future<void> addBiometricHistory(BiometricHistory biometric) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _biometricCollection.add({
      'userId': userId,
      ...biometric.toFirestore(),
    });
  }

  // Get biometric history for a specific date range
  Stream<List<BiometricHistory>> getBiometricHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    var query = _biometricCollection.where('userId', isEqualTo: userId);

    if (startDate != null) {
      query = query.where('date', isGreaterThanOrEqualTo: startDate);
    }
    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: endDate);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BiometricHistory.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Get latest biometric history
  Future<BiometricHistory?> getLatestBiometricHistory() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    final snapshot = await _biometricCollection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return BiometricHistory.fromFirestore(
      snapshot.docs.first.data() as Map<String, dynamic>,
      snapshot.docs.first.id,
    );
  }

  // Update biometric history
  Future<void> updateBiometricHistory(
    String id,
    BiometricHistory biometric,
  ) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _biometricCollection.doc(id).update({
      'userId': userId,
      ...biometric.toFirestore(),
    });
  }

  // Delete biometric history
  Future<void> deleteBiometricHistory(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _biometricCollection.doc(id).delete();
  }
}
