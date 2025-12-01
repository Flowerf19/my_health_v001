import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/providers/auth_provider.dart';
import '../models/food_model.dart';
import '../services/food_service.dart';

class FoodManagerScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();

  FoodManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Vui lòng đăng nhập')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Thực phẩm')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddFoodDialog(context, user.uid),
      ),
      body: StreamBuilder<List<Food>>(
        stream: FoodService().getFoods(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Đã xảy ra lỗi!'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có thực phẩm nào'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final food = snapshot.data![index];
              return ListTile(
                title: Text(food.name),
                subtitle: Text('${food.calories} kcal'),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddFoodDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm thực phẩm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Tên thực phẩm'),
            ),
            TextField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Calories'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () {
              final newFood = Food(
                userId: userId,
                name: _nameController.text,
                calories: int.tryParse(_caloriesController.text) ?? 0,
                protein: 0,
                carbs: 0,
                fat: 0,
                servingSize: '100g',
                isCustom: true,
              );
              FoodService().addFood(newFood);
              Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
