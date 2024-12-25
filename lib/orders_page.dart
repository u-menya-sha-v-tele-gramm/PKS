import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<OrderGroup> _orderGroups = [];
  bool _isLoading = true;
  final userId = Supabase.instance.client.auth.currentUser ?.id;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final response = await http.get(Uri.parse('http://localhost:8080/products-grouped-by-time?user_id=$userId'));

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonData = json.decode(decodedResponse);
      setState(() {
        _orderGroups = jsonData.map((group) => OrderGroup.fromJson(group)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _orderGroups.length,
              itemBuilder: (context, index) {
                final group = _orderGroups[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.time.toString(), // Преобразуем в локальное время
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        ...group.products.map((product) => ListTile(
                              leading: Image.network(product.imageUrl),
                              title: Text(product.name),
                              subtitle: Text(product.description),
                              trailing: Text('\$${product.price}'),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Модели данных
class OrderGroup {
  DateTime time;
  List<Product> products;

  OrderGroup({required this.time, required this.products});

  factory OrderGroup.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    List<Product> productsList = list.map((i) => Product.fromJson(i)).toList();
    return OrderGroup(
      time: DateTime.parse(json['time']),
      products: productsList,
    );
  }
}

class Product {
  int id;
  String name;
  String description;
  double price;
  String imageUrl;
  bool isLiked;
  bool isInCart;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isLiked,
    required this.isInCart,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['p_name'],
      description: json['p_desc'],
      price: json['p_cost'].toDouble(),
      imageUrl: json['image_url'],
      isLiked: json['is_liked'],
      isInCart: json['is_in_art'],
    );
  }
}
