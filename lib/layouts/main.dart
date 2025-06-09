import 'package:flutter/material.dart';
import 'package:studymind/presentation/chatbot/chatbot.dart';
import 'package:studymind/presentation/home/home.dart';
import 'package:studymind/presentation/library/library.dart';
import 'package:studymind/presentation/profile/profile.dart';
import 'package:studymind/widgets/custom_icon.dart';

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
      body: [HomeScreen(), LibraryScreen(), ChatbotScreen(), ProfileScreen()][selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          NavigationDestination(icon: CustomIcon(icon: 'home'), label: 'Home'),
          NavigationDestination(icon: CustomIcon(icon: 'library'), label: 'Library'),
          NavigationDestination(icon: CustomIcon(icon: 'chatbot'), label: 'Chatbot'),
          NavigationDestination(icon: CustomIcon(icon: 'profile'), label: 'Profile'),
        ],
      ),
    );
  }
}
