import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_grid.dart';
import 'package:studymind/presentation/library/widgets/item_empty.dart';
import 'package:studymind/presentation/library/widgets/item_loader.dart';
import 'package:studymind/widgets/notification_button.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
  final LibraryController libraryController = Get.find<LibraryController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => libraryController.refreshData(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Library'), actions: [NotificationButton()]),
        body: Obx(() {
          List<LibraryItem> folderItems = libraryController.folderItems.toList();

          if (libraryController.isLoading.value) return const ItemLoader(isSearch: true);

          if (folderItems.isEmpty) return const ItemEmpty();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(decoration: InputDecoration(hintText: 'Search in library...', prefixIcon: Icon(Icons.search))),
              const SizedBox(height: 16),
              ItemGrid(items: folderItems),
            ],
          );
        }),
      ),
    );
  }
}
