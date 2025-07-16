import '../models/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE
  Future<void> addFood(Food food) async {
    await _firestore
        .collection('users')
        .doc(food.userId)
        .collection('foods')
        .add(food.toFirestore());
  }

  // READ (Realtime)
  Stream<List<Food>> getFoods(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('foods')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Food.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // UPDATE
  Future<void> updateFood(Food food) async {
    await _firestore
        .collection('users')
        .doc(food.userId)
        .collection('foods')
        .doc(food.id)
        .update(food.toFirestore());
  }

  // DELETE
  Future<void> deleteFood(String userId, String foodId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('foods')
        .doc(foodId)
        .delete();
  }
}