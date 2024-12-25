// Класс элементов корзины

import 'package:medical_app/models/item.dart';

class CartItem {
  final Item item;
  int number;

  CartItem(this.item, this.number);
}
