import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/controllers/main.dart';
import 'package:studymind/presentation/chatbot/chatbot.dart';
import 'package:studymind/presentation/home/home.dart';
import 'package:studymind/presentation/library/library.dart';
import 'package:studymind/presentation/profile/profile.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/library/item_create_sheet.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find<MainController>();
    final LibraryController libraryController = Get.find<LibraryController>();
    final ChatController chatController = Get.find<ChatController>();

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: mainController.selectedIndex.value,
          children: [const HomeScreen(), const LibraryScreen(), const ChatbotScreen(), const ProfileScreen()],
        ),
      ),
      bottomNavigationBar: Obx(() {
        final selectedItems = libraryController.selectedItems;
        final selectedSessions = chatController.selectedSessions;

        if (selectedItems.isNotEmpty || selectedSessions.isNotEmpty) {
          return const SizedBox();
        } else {
          return NavigationBar(
            selectedIndex: mainController.selectedIndex.value,
            onDestinationSelected: mainController.onDestinationSelected,
            destinations: [
              NavigationDestination(
                icon: CustomIcon(icon: 'home'),
                label: 'Home',
              ),
              NavigationDestination(
                icon: CustomIcon(icon: 'library'),
                label: 'Library',
              ),
              NavigationDestination(
                icon: CustomIcon(icon: 'chatbot'),
                label: 'Chatbot',
              ),
              NavigationDestination(
                icon: CustomIcon(icon: 'profile'),
                label: 'Profile',
              ),
            ],
          );
        }
      }),
      floatingActionButton: Obx(() {
        if (mainController.selectedIndex.value == 1 || mainController.selectedIndex.value == 2) {
          return FloatingActionButton(
            onPressed: () {
              if (mainController.selectedIndex.value == 1) {
                Get.bottomSheet(ItemCreateSheet());
              } else {
                chatController.navigateToNewChat();
              }
            },
            child: const Icon(Icons.add),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
