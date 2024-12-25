import 'package:medical_app/components/cart_card.dart';
import 'package:medical_app/global/lists.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _removeItem(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }

  void _incrementItem(int index, bool add) {
    setState(() {
      if (add) {
        cart[index].number++;
      } else {
        cart[index].number--;
      }

      if (cart[index].number == 0) {
        cart.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Корзина',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          titleSpacing: 27,
        ),
        body: cart.isEmpty
            ? const Center(
                child: Text(
                  "Пусто 🤷\nПопробуйте добавить услугу в корзину",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              )
            : Container(
                margin: const EdgeInsets.only(top: 38),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cart.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CartCard(
                              itemIndex: index,
                              removeItem: _removeItem,
                              incrementItem: _incrementItem,
                            );
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(29, 40, 29, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Сумма',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '${cart.fold(0, (sum, book) => sum + (book.item.price * book.number))} ₽',
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(27.5, 0, 27.5, 30),
                        height: 56,
                        width: 335,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).primaryColor,
                        ),
                        // padding: const EdgeInsets.fromLTRB(27.5, 0, 27.5, 30),
                        child: InkWell(
                          onTap: () {},
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Перейти к оформлению заказа',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
