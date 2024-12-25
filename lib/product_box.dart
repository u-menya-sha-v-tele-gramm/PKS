import 'package:flutter/material.dart';

class ProductBox extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final VoidCallback onTap;

  const ProductBox({required this.name, required this.description, required this.price, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const placeholderImage = 'lib/assets/images/not-image.png';
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        height: 120,
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
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(description),
                      Text("Цена: \$${price}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}