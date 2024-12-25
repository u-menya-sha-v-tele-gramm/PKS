import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'main.dart';
import 'product_box.dart'; // Ensure this import is correct

class ShoppingCartPage extends StatefulWidget {
  final List<Product> cartProducts;

  const ShoppingCartPage({super.key, required this.cartProducts});

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  void _incrementQuantity(Product product) {
    setState(() {
      product.quantity++;
    });
  }

  void _decrementQuantity(Product product) {
    setState(() {
      if (product.quantity > 1) {
        product.quantity--;
      }
    });
  }

  void _removeProduct(Product product) {
    setState(() {
      widget.cartProducts.remove(product);
      product.isInCart = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: widget.cartProducts.isEmpty
          ? const Center(child: Text('Корзина пуста'))
          : ListView.builder(
              itemCount: widget.cartProducts.length,
              itemBuilder: (context, index) {
                final product = widget.cartProducts[index];
                return Slidable(
                  key: Key(product.name),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => _removeProduct(product),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Удалить',
                      ),
                    ],
                  ),
                  child: ProductBox(
                    name: product.name,
                    description: product.description,
                    price: product.price,
                    imageUrl: product.imageUrl,
                    isLiked: product.isLiked,
                    isInCart: true, // Since the product is already in the cart
                    onTap: () {
                      // Logic for tapping on the product box
                    },
                    onToggleFavorite: () {
                      // Logic for toggling favorite
                    },
                    onToggleCart: () {
                      _removeProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} удален из корзины')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
