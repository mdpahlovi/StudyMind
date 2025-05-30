import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_empty.dart';
import 'package:studymind/presentation/library/widgets/item_grid.dart';
import 'package:studymind/presentation/library/widgets/item_loader.dart';
import 'package:studymind/widgets/create_library_items.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/library/item_app_bar.dart';

class ItemByFolder extends StatefulWidget {
  const ItemByFolder({super.key});

  @override
  State<ItemByFolder> createState() => ItemByFolderState();
}

class ItemByFolderState extends State<ItemByFolder> {
  final LibraryController libraryController = Get.find<LibraryController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: RefreshIndicator(
        onRefresh: () async => libraryController.refreshByFolder(),
        child: Scaffold(
          appBar: buildItemAppBar(),
          body: Obx(() {
            List<LibraryItem> folderItems = libraryController.folderItems.toList();

            if (libraryController.isLoadingFolder.value) return const ItemLoader();

            if (folderItems.isEmpty) return const ItemEmpty();

            return ItemGrid(items: folderItems);
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
