import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class DeletionPage extends StatelessWidget {
  final Product product;
  final Function onDelete;

  const DeletionPage({required this.product, required this.onDelete, super.key});

  Future<void> deleteProduct(int productId) async {
    final url = Uri.parse('http://localhost:8080/products/delete?id=$productId'); // Убедитесь, что URL правильный

    final response = await http.delete(url);

    if (response.statusCode == 204) {
      // Успешное удаление
      print('Продукт успешно удалён');
      onDelete(); // Вызываем функцию onDelete, чтобы обновить состояние родительского виджета
    } else {
      // Ошибка при удалении
      print('Ошибка при удалении продукта: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подтверждение удаления'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Вы уверены, что хотите удалить "${product.name}"?',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await deleteProduct(product.id); // Вызов функции удаления
                Navigator.of(context).pop(); // Закрываем страницу
              },
              child: const Text('Удалить'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
          ],
        ),
      ),
    );
  }
}
