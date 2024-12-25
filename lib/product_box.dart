import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductBox extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final bool isLiked;
  final bool isInCart;
  final int productId; // Добавляем productId
  final String userId; // Добавляем userId
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleCart;

  const ProductBox({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isLiked,
    required this.isInCart,
    required this.productId, // Обязательный параметр
    required this.userId, // Обязательный параметр
    required this.onTap,
    required this.onToggleFavorite,
    required this.onToggleCart,
  });

  Future<void> toggleWishlist() async {
    final url = isLiked
        ? 'http://localhost:8080/remove-whishlist?product_id=$productId&user_id=$userId'
        : 'http://localhost:8080/add-whishlist?product_id=$productId&user_id=$userId';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Успешно добавлено или удалено из wishlist
        print('Product ${isLiked ? "removed from" : "added to"} wishlist');
      } else {
        // Обработка ошибок
        print('Failed to ${isLiked ? "remove" : "add"} product to wishlist: ${response.statusCode}');
      }
    } catch (error) {
      print('Error toggling product in wishlist: $error');
    }
  }

  Future<void> toggleCart() async {
    final url = isInCart
        ? 'http://localhost:8080/remove-cart?product_id=$productId&user_id=$userId'
        : 'http://localhost:8080/add-cart?product_id=$productId&user_id=$userId';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Успешно добавлено или удалено из корзины
        print('Product ${isInCart ? "removed from" : "added to"} cart');
      } else {
        // Обработка ошибок
        print('Failed to ${isInCart ? "remove" : "add"} product to cart: ${response.statusCode}');
      }
    } catch (error) {
      print('Error toggling product in cart: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    const placeholderImage = 'lib/assets/images/not-image.png';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        height: 130,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                imageUrl.isNotEmpty ? imageUrl : placeholderImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(description),
                      Text("Цена: \$${price}"), // Исправлено для отображения цены
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  onToggleFavorite(); // Обновляем состояние
                  toggleWishlist(); // Добавляем или удаляем продукт из wishlist при нажатии
                },
              ),
              IconButton(
                icon: Icon(
                  isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                  color: isInCart ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  onToggleCart(); // Обновляем состояние
                  toggleCart(); // Добавляем или удаляем продукт из корзины при нажатии
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
