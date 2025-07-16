import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_log_model.dart';
class FoodLogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logFood(FoodLog log) async {
    await _firestore
        .collection('users')
        .doc(log.userId)
        .collection('food_logs')
        .add(log.toFirestore());
  }

  Stream<List<FoodLog>> getFoodLogs(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('food_logs')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FoodLog.fromFirestore(doc.data(), doc.id))
        .toList());
  }
}