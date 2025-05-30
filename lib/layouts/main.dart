import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/presentation/community/community.dart';
import 'package:studymind/presentation/home/home.dart';
import 'package:studymind/presentation/library/library.dart';
import 'package:studymind/presentation/profile/profile.dart';
import 'package:studymind/widgets/library/item_create_sheet.dart';
import 'package:studymind/widgets/custom_icon.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  final List<Widget> screens = [HomeScreen(), LibraryScreen(), SizedBox(), CommunityScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
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
