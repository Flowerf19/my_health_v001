class FoodLog {
  final String? id;
  final String userId;
  final String foodId;
  final double servings;
  final DateTime date;
  final int totalCalories;

  FoodLog({
    this.id,
    required this.userId,
    required this.foodId,
    required this.servings,
    required this.date,
    required this.totalCalories,
  });

  factory FoodLog.fromFirestore(Map<String, dynamic> data, String id) {
    return FoodLog(
      id: id,
      userId: data['userId'],
      foodId: data['foodId'],
      servings: data['servings'].toDouble(),
      date: data['date'].toDate(),
      totalCalories: data['totalCalories'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'foodId': foodId,
      'servings': servings,
      'date': date,
      'totalCalories': totalCalories,
    };
  }
}