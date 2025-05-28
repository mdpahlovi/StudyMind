import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/presentation/community/community.dart';
import 'package:studymind/presentation/home/home.dart';
import 'package:studymind/presentation/library/library.dart';
import 'package:studymind/presentation/profile/profile.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/create_library_items.dart';
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
    final ColorPalette colorPalette = AppColors().palette;

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: CustomIcon(icon: 'home'),
            selectedIcon: CustomIcon(icon: 'home', color: colorPalette.background),
            label: 'Home',
          ),
          NavigationDestination(
            icon: CustomIcon(icon: 'library'),
            selectedIcon: CustomIcon(icon: 'library', color: colorPalette.background),
            label: 'Library',
          ),
          SizedBox(),
          NavigationDestination(
            icon: CustomIcon(icon: 'community'),
            selectedIcon: CustomIcon(icon: 'community', color: colorPalette.background),
            label: 'Community',
          ),
          NavigationDestination(
            icon: CustomIcon(icon: 'profile'),
            selectedIcon: CustomIcon(icon: 'profile', color: colorPalette.background),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.bottomSheet(CreateLibraryItems()),
        child: CustomIcon(icon: 'add', size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
