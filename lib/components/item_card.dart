import 'package:medical_app/models/cart_item.dart';
import 'package:medical_app/models/item.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/global/lists.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.itemIndex,
    required this.itemList,
    required this.refresh,
  });

  final int itemIndex; // Проп для названия заметки
  final List itemList;
  final Function refresh;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // Добавить в корзину
  void _addToCart() {
    setState(() {
      Item bookToAdd = items[widget.itemIndex];

      int existingItemIndex = cart.indexWhere((item) => item.item == bookToAdd);

      // Проверяем, есть ли уже книга в корзине
      // Если нет, добавляем новый элемент в список
      if (existingItemIndex == -1) {
        cart.add(CartItem(items[widget.itemIndex], 1));
      }
      // Если есть, прибавляем 1 к количеству
      else {
        cart[existingItemIndex].number++;
      }
    });
  }

  // Функция для добавления корректного слова для количества дней
  String _addCorrectDayWord(int days) {
    if (days < 11 || days > 14) {
      switch (days % 10) {
        case 1:
          return "${days.toString()} день";
        case >= 2 && < 5:
          return "${days.toString()} дня";

        default:
      }
    }
    return "${days.toString()} дней";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      margin: const EdgeInsets.fromLTRB(27.5, 0, 27.5, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: const Color.fromRGBO(224, 224, 224, 100),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              items[widget.itemIndex].title,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _addCorrectDayWord(items[widget.itemIndex].duration),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(147, 147, 150, 100),
                    ),
                  ),
                  Text(
                    '${items[widget.itemIndex].price} ₽',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => _addToCart(),
                child: Container(
                  width: 96,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Center(
                    child: Text(
                      'Добавить',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
