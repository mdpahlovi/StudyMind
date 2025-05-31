import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/presentation/community/community.dart';
import 'package:studymind/presentation/home/home.dart';
import 'package:studymind/presentation/library/library.dart';
import 'package:studymind/presentation/profile/profile.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/library/item_create_sheet.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;

  void onDestinationSelected(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [HomeScreen(), LibraryScreen(), SizedBox(), CommunityScreen(), ProfileScreen()][selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
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
