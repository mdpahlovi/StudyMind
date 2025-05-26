import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_card.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/notification_button.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  State<ItemDetails> createState() => ItemDetailsState();
}

class ItemDetailsState extends State<ItemDetails> {
  final LibraryController libraryController = Get.put(LibraryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: CustomIcon(icon: 'arrowLeft', size: 28),
          onPressed: () {
            libraryController.loadFolderData(libraryController.currentItem.value?.parentId);
            Get.back();
          },
        ),
        title: Obx(() => Text(libraryController.currentItem.value?.name ?? 'Item Details')),
        actions: [NotificationButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(() {
            List<LibraryItem> folderItems = libraryController.currentFolderItems.toList();

            if (folderItems.isEmpty) {
              return const Center(child: Text('Item not found'));
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
