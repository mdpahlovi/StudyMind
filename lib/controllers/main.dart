import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/presentation/community/community.dart';
import 'package:studymind/presentation/home/home.dart';
import 'package:studymind/presentation/library/library.dart';
import 'package:studymind/presentation/profile/profile.dart';

class MainController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final List<int> histories = [];
  final List<Widget> screens = [HomeScreen(), LibraryScreen(), SizedBox(), CommunityScreen(), ProfileScreen()];

  Widget getScreen() {
    return screens[selectedIndex.value];
  }

  void onDestinationSelected(int index) {
    selectedIndex.value = index;
    histories.add(index);
  }

  void onBack() {
    if (histories.isEmpty) return;
    histories.removeLast();
    selectedIndex.value = histories.last;
  }
}
