import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'product_box.dart';
import 'product_detail_page.dart';
//import 'product_creation_page.dart';
import 'account_page.dart';
import 'shopping_cart_page.dart';


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
    final String response = await rootBundle.loadString('lib/assets/products.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      products = data.map((item) => Product.fromJson(item)).toList();
    });
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
                  onToggleFavorite: () {
                    setState(() {
                      product.toggleFavorite();
                    });
                  },
                  onToggleCart: () {
                    setState(() {
                      product.toggleCart();
                    });
                  },
                );
              },
            ),
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShoppingCartPage(cartProducts: cartProducts),
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
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  bool isLiked;
  bool isInCart;
  int quantity;

  Product({
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
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      isLiked: json['IsLiked'],
      isInCart: json['isInCart'] ?? false,
      quantity: json['quantity'] ?? 1,  );
  }

  void toggleFavorite() {
    isLiked = !isLiked;
  }

  void toggleCart(){
    isInCart = !isInCart;
  }
}
