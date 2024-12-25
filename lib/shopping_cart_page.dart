import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert'; // Для работы с JSON
import 'main.dart'; // Импортируйте ваш основной файл, где определен класс Product

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Product> cartProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

Future<void> _fetchCartItems() async {
  final userId = Supabase.instance.client.auth.currentUser ?.id; // Получаем userId из Supabase

  if (userId == null) {
    // Обработка случая, когда пользователь не авторизован
    print('Пользователь не авторизован');
    setState(() {
      isLoading = false;
    });
    return;
  }

  try {
    final response = await http.get(
      Uri.parse('http://localhost:8080/show-personal-cart?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(decodedResponse);
      
      setState(() {
        cartProducts = data.map((item) {
          return Product(
            id: item['product_id'], // Сопоставляем product_id с id
            name: item['product_name'], // Сопоставляем product_name с name
            description: item['product_description'], // Сопоставляем product_description с description
            price: item['product_price'], // Сопоставляем product_price с price
            imageUrl: '', // Установите значение по умолчанию, если нет изображения
          );
        }).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Не удалось загрузить товары в корзине');
    }
  } catch (e) {
    print('Ошибка при загрузке товаров в корзине: $e');
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartProducts.isEmpty
              ? const Center(child: Text('Корзина пуста'))
              : ListView.builder(
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    final product = cartProducts[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.price} руб.'),
                    );
                  },
                ),
    );
  }
}
