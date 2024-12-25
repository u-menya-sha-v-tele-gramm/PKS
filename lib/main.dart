import 'dart:convert';
import 'package:flutter/material.dart';
import 'product_box.dart';
import 'product_detail_page.dart';
import 'account_page.dart';
import 'shopping_cart_page.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase
  await Supabase.initialize(
    url: 'https://hvtufmrmhwcqqhlkradu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2dHVmbXJtaHdjcXFobGtyYWR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyNjUxMTIsImV4cCI6MjA0OTg0MTExMn0.kb-GTWVs8Alpl6GUZVs5-POYFxeIYfCgstVwmUZGmxY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Демо Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем текущего пользователя
    final user = Supabase.instance.client.auth.currentUser ;

    // Если пользователь не авторизован, показываем страницу входа
    if (user == null) {
      return const LoginPage();
    } else {
      // Если пользователь авторизован, показываем главную страницу
      return const MyHomePage();
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Product> products = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  String? name;
  String? description;

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadWishlist();
    _searchController.addListener(_onSearchChanged);
    _minPriceController.addListener(_onSearchChanged);
    _maxPriceController.addListener(_onSearchChanged);
  }

  List<Product> get cartProducts => products.where((product) => product.isInCart).toList();

  Future<void> loadProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/products'));

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedResponse);
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

  Future<void> loadWishlist() async {
    final userId = Supabase.instance.client.auth.currentUser ?.id;
    if (userId == null) return;

    try {
      final response = await http.get(Uri.parse('http://localhost:8080/show-personal-whishlist?user_id=$userId'));

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> wishlistData = json.decode(decodedResponse);

        // Создаем список продуктов из полученных данных
        List<Product> wishlistProducts = wishlistData.map((item) => Product.fromJson(item)).toList();

        // Обновляем состояние с учетом избранного
        setState(() {
          products.forEach((product) {
            product.isLiked = wishlistProducts.any((wishlistProduct) => wishlistProduct.id == product.id);
          });
        });
      } else {
        throw Exception('Не удалось загрузить wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка при загрузке wishlist: $e');
    }
  }

  Future<void> searchProducts() async {
    String minPrice = _minPriceController.text.isNotEmpty ? _minPriceController.text : "";
    String maxPrice = _maxPriceController.text.isNotEmpty ? _maxPriceController.text : "";
    String url = 'http://localhost:8080/search-products?name=${name ?? ""}&description=${description ?? ""}&min_price=$minPrice&max_price=$maxPrice';
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedResponse);
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

  void _onSearchChanged() {
    name = _searchController.text.isNotEmpty ? _searchController.text : null;
    description = null; // Уберите, если не нужно
    searchProducts();
  }

  Future<void> toggleFavorite(int productId) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/toggle-favorite?id=$productId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Изменение состояния IsLiked успешно');
    } else {
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
      print('Изменение состояния IsInCart успешно');
    } else {
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
      if (Supabase.instance.client.auth.currentUser  == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountPage(),
          ),
        );
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Product> displayedProducts;

    if (_selectedIndex == 1) {
      displayedProducts = products.where((product) => product.isLiked).toList();
    } else {
      displayedProducts = products;
    }

    final userId = Supabase.instance.client.auth.currentUser ?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Главная страница' : 'Избранное'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск...',
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        decoration: InputDecoration(
                          hintText: 'Мин. цена',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        decoration: InputDecoration(
                          hintText: 'Макс. цена',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: displayedProducts.isEmpty
          ? const Center(child: Text('Нет товаров для отображения'))
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
                  productId: product.id,
                  userId: userId ?? '',
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
                    await toggleFavorite(product.id);
                  },
                  onToggleCart: () async {
                    setState(() {
                      product.toggleCart();
                    });
                    await toggleCart(product.id);
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
                    builder: (context) => const ShoppingCartPage(),
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
  final int id;
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
      id: json['product_id'],
      name: json['p_name'],
      description: json['p_desc'],
      price: json['p_cost'],
      imageUrl: json['image_url'],
      isLiked: json['is_liked'] ?? false,
      isInCart: json['is_in_cart'] ?? false,
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
