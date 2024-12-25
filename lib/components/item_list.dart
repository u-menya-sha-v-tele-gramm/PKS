import 'package:flutter/material.dart';
import 'package:medical_app/components/item_card.dart';

class ItemList extends StatefulWidget {
  const ItemList(
      {super.key, required this.itemList, required this.refreshState});

  final List itemList;
  final Function refreshState;

  @override
  State<ItemList> createState() => _BookListState();
}

class _BookListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const Padding(padding: EdgeInsets.only(left: 27)),
        // leadingWidth: 27,
        titleSpacing: 27,
        title: const Text(
          "Каталог услуг",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: widget.itemList.isEmpty
          ? const Center(
              child: Text(
                "Пусто 🤷\nНет доступных услуг",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            )
          : Container(
              margin: const EdgeInsets.only(top: 38),
              child: ListView.builder(
                  itemCount: widget.itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemCard(
                      itemIndex: index,
                      itemList: widget.itemList,
                      refresh: widget.refreshState,
                    );
                  }),
            ),
    );
  }
}
