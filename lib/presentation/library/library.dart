import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_card.dart';
import 'package:studymind/widgets/notification_button.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
  final LibraryController libraryController = Get.put(LibraryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library'), actions: [NotificationButton()]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(decoration: InputDecoration(hintText: 'Search in library...', prefixIcon: Icon(Icons.search))),
          const SizedBox(height: 16),
          Obx(() {
            List<LibraryItem> folderItems = libraryController.currentFolderItems.toList();

            if (folderItems.isEmpty) {
              return const Center(child: Text('No items found'));
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: folderItems.length,
              itemBuilder: (context, index) => ItemCard(item: folderItems[index]),
            );
          }),
        ],
      ),
    );
  }
}
