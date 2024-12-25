import 'dart:convert';
import 'package:flutter/material.dart';
import 'product_box.dart';
import 'product_detail_page.dart';
//import 'product_creation_page.dart';
import 'account_page.dart';
import 'shopping_cart_page.dart';
import 'package:http/http.dart' as http;


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Демо Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Product> products = [];
  
  @override void initState() {
    super.initState();
    loadProducts();
  }

  List<Product> get cartProducts => products.where((product) => product.isInCart).toList();



Future<void> loadProducts() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:8080/products'));

    print('Статус-код ответа: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Пробуем декодировать тело ответа как UTF-8
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(decodedResponse);
      print(data);
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Не удалось загрузить продукты: ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка при загрузке продуктов: $e');
  }
}


Future<void> toggleFavorite(int productId) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/toggle-favorite?id=$productId'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Обработка успешного ответа
    print('Изменение состояния IsLiked успешно');
  } else {
    // Обработка ошибки
    print('Ошибка при изменении состояния IsLiked: ${response.body}');
  }
}

Future<void> toggleCart(int productId) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/toggle-cart?id=$productId'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Обработка успешного ответа
    print('Изменение состояния IsInCart успешно');
  } else {
    // Обработка ошибки
    print('Ошибка при изменении состояния IsInCart: ${response.body}');
  }
}




  void removeProduct(Product product) {
    setState(() {
      products.remove(product);
    });
  }

  void addProduct(Product product) {
    setState(() {
      products.add(product);
    });
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AccountPage(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override Widget build(BuildContext context) {
    List<Product> displayedProducts;

    if (_selectedIndex == 1) {
      displayedProducts = products.where((product) => product.isLiked).toList();
    } else {
      displayedProducts = products;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Главная страница' : 'Избранное'),
      ),
      body: displayedProducts.isEmpty ? const Center(child: Text('Нет товаров для отображения'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                final product = displayedProducts[index];
                return ProductBox(
                  name: product.name,
                  description: product.description,
                  price: product.price,
                  imageUrl: product.imageUrl,
                  isLiked: product.isLiked,
                  isInCart: product.isInCart,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: product,
                          onDelete: () => removeProduct(product),
                        ),
                      ),
                    );
                  },
                  onToggleFavorite: () async {
                    setState(() {
                      product.toggleFavorite();
                    });
                    await toggleFavorite(product.id); // Используйте product.id
                  },
                  onToggleCart: () async {
                    setState(() {
                      product.toggleCart();
                    });
                    await toggleCart(product.id); // Используйте product.id
                  },

                );
              },
            ),
            floatingActionButton: _selectedIndex == 0 
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoppingCartPage(), // Удаляем cartProducts
                      ),
                    );
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.shopping_cart),
                )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная страница',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Аккаунт',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class Product {
  final int id; // Добавляем поле id
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  bool isLiked;
  bool isInCart;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isLiked = false,
    this.isInCart = false,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'], 
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      isLiked: json['IsLiked'] ?? false,
      isInCart: json['isInCart'] ?? false,
      quantity: json['quantity'] ?? 1,
    );
  }

  void toggleFavorite() {
    isLiked = !isLiked;
  }

  void toggleCart() {
    isInCart = !isInCart;
  }
}
