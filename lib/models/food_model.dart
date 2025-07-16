class Food {
  final String? id;
  final String userId;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String servingSize;
  final bool isCustom;

  Food({
    this.id,
    required this.userId,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    required this.isCustom,
  });

  factory Food.fromFirestore(Map<String, dynamic> data, String id) {
    return Food(
      id: id,
      userId: data['userId'],
      name: data['name'],
      calories: data['calories'],
      protein: data['protein'].toDouble(),
      carbs: data['carbs'].toDouble(),
      fat: data['fat'].toDouble(),
      servingSize: data['servingSize'],
      isCustom: data['isCustom'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'servingSize': servingSize,
      'isCustom': isCustom,
    };
  }
}