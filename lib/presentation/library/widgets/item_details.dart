import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_empty.dart';
import 'package:studymind/presentation/library/widgets/item_grid.dart';
import 'package:studymind/presentation/library/widgets/item_loader.dart';
import 'package:studymind/widgets/create_library_items.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/notification_button.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  State<ItemDetails> createState() => ItemDetailsState();
}

class ItemDetailsState extends State<ItemDetails> {
  final LibraryController libraryController = Get.find<LibraryController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: RefreshIndicator(
        onRefresh: () async => libraryController.refreshData(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: CustomIcon(icon: 'arrowLeft', size: 28),
              onPressed: () => libraryController.navigateToBack(),
            ),
            title: Obx(() {
              if (libraryController.breadcrumbs.isEmpty) {
                return const Text('');
              } else {
                return Text(libraryController.breadcrumbs.last.name);
              }
            }),
            actions: [NotificationButton()],
          ),
          body: Obx(() {
            List<LibraryItem> folderItems = libraryController.folderItems.toList();

            if (libraryController.isLoading.value) return const ItemLoader();

            if (folderItems.isEmpty) return const ItemEmpty();

            return ListView(padding: const EdgeInsets.all(16), children: [ItemGrid(items: folderItems)]);
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.bottomSheet(CreateLibraryItems()),
            child: CustomIcon(icon: 'add', size: 24),
          ),
        ),
      ),
    );
  }
}
