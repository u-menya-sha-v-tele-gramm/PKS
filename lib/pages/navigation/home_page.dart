import 'package:medical_app/components/item_list.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/global/lists.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _refreshState() {}

  @override
  Widget build(BuildContext context) {
    return ItemList(
      itemList: items,
      refreshState: _refreshState,
    );
  }
}
