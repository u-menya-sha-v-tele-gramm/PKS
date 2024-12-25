import 'package:medical_app/global/lists.dart';
import 'package:flutter/material.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    super.key,
    required this.itemIndex,
    required this.removeItem,
    required this.incrementItem,
  });

  final int itemIndex;
  final Function removeItem;
  final Function incrementItem;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  // Функция для добавления корректного слова для количества дней
  String _addCorrectPatientWord(int count) {
    if (count < 11 || count > 14) {
      switch (count % 10) {
        case 1:
          return "${count.toString()} пациент";
        case >= 2 && < 5:
          return "${count.toString()} пациента";

        default:
      }
    }
    return "${count.toString()} пациентов";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  cart[widget.itemIndex].item.title,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => widget.removeItem(widget.itemIndex),
                  icon: Image.asset(
                    'assets/icons/delete.png',
                    height: 12.0,
                    width: 12.0,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${cart[widget.itemIndex].item.price} ₽',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    _addCorrectPatientWord(cart[widget.itemIndex].number),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    height: 32,
                    width: 64,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(245, 245, 249, 100),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    margin: const EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: IconButton(
                            iconSize: 20,
                            padding: const EdgeInsets.all(0),
                            onPressed: () =>
                                widget.incrementItem(widget.itemIndex, false),
                            icon: const Icon(
                              Icons.remove,
                              color: Color.fromRGBO(184, 193, 204, 100),
                            ),
                          ),
                        ),
                        Container(
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(235, 235, 235, 100),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: IconButton(
                            iconSize: 20,
                            padding: const EdgeInsets.all(0),
                            onPressed: () =>
                                widget.incrementItem(widget.itemIndex, true),
                            icon: const Icon(
                              Icons.add,
                              color: Color.fromRGBO(147, 147, 150, 100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
