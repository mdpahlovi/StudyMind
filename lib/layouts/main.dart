import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/layouts/widgets/create_option.dart';
import 'package:studymind/presentation/community/community.dart';
import 'package:studymind/presentation/home/home.dart';
import 'package:studymind/presentation/library/library.dart';
import 'package:studymind/presentation/profile/profile.dart';
import 'package:studymind/theme/colors.dart';
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
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CreateOption(onTap: () => Get.toNamed('/notes'), title: "New Note", icon: "noteEdit", color: colorPalette.primary),
                    SizedBox(height: 12),
                    CreateOption(
                      onTap: () => Get.toNamed('/document'),
                      title: "Scan Document",
                      icon: "documentScanner",
                      color: colorPalette.info,
                    ),
                    SizedBox(height: 12),
                    CreateOption(
                      onTap: () => Get.toNamed('/flashcard'),
                      title: "Create Flashcards",
                      icon: "flashCard",
                      color: colorPalette.warning,
                    ),
                    SizedBox(height: 12),
                    CreateOption(
                      onTap: () => Get.toNamed('/community'),
                      title: "Create Group",
                      icon: "community",
                      color: colorPalette.secondary,
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: CustomIcon(icon: 'add', size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
