import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/constants/item_type.dart';

class ItemCreateScreen extends StatefulWidget {
  const ItemCreateScreen({super.key});

  @override
  State<ItemCreateScreen> createState() => ItemCreateScreenState();
}

class ItemCreateScreenState extends State<ItemCreateScreen> {
  @override
  Widget build(BuildContext context) {
    final TypeOption option = Get.arguments;

    return const Scaffold(body: Center(child: Text("Item Create Screen")));
  }
}
