// Список товаров
import 'package:medical_app/models/cart_item.dart';
import 'package:medical_app/models/item.dart';

List<Item> items = <Item>[
  Item(
    1,
    'ПЦР-тест на определение РНК коронавируса стандартный',
    2,
    1800,
  ),
  Item(
    2,
    'Клинический анализ крови с лейкоцитарной формулировкой',
    1,
    690,
  ),
  Item(
    3,
    'Биохимический анализ крови, базовый',
    1,
    2440,
  ),
];

List<Item> favourites = [];

List<CartItem> cart = [];
