import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/main.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/library/item_create_sheet.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find<MainController>();

    return Scaffold(
      body: mainController.getScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: mainController.selectedIndex.value,
        onDestinationSelected: (index) => setState(() => mainController.selectedIndex.value = index),
        destinations: [
          NavigationDestination(icon: CustomIcon(icon: 'home'), label: 'Home'),
          NavigationDestination(icon: CustomIcon(icon: 'library'), label: 'Library'),
          SizedBox(),
          NavigationDestination(icon: CustomIcon(icon: 'community'), label: 'Community'),
          NavigationDestination(icon: CustomIcon(icon: 'profile'), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.bottomSheet(ItemCreateSheet()),
        child: CustomIcon(icon: 'add', size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
