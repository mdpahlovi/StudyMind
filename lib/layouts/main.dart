import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/presentation/home/home.dart';
import 'package:studymind/presentation/library/library.dart';
import 'package:studymind/presentation/profile/profile.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:uuid/uuid.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  final ChatController chatController = Get.find<ChatController>();
  int selectedIndex = 0;

  void onDestinationSelected(int index) {
    if (index == 2) {
      if (chatController.selectedSession.value != null) {
        Get.toNamed(AppRoutes.chatSession.replaceFirst(':uid', chatController.selectedSession.value!.uid));
      } else {
        Get.toNamed(AppRoutes.chatSession.replaceFirst(':uid', Uuid().v4()));
      }
    } else {
      setState(() => selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [HomeScreen(), LibraryScreen(), SizedBox(), ProfileScreen()][selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
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
      ),
    );
  }
}
