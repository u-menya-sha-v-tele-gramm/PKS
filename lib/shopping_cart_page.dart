import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Для работы с JSON
import 'main.dart';
//import 'product_box.dart'; // Убедитесь, что этот импорт правильный

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
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/cart-items'));

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedResponse);
        
        setState(() {
          cartProducts = data.map((item) => Product.fromJson(item)).toList();
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
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_shopping_cart),
                        onPressed: () {
                          // Логика для удаления товара из корзины
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
