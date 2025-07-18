import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_empty.dart';
import 'package:studymind/presentation/library/widgets/item_grid.dart';
import 'package:studymind/presentation/library/widgets/item_loader.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/library/item_app_bar.dart';
import 'package:studymind/widgets/library/item_create_sheet.dart';

class ItemByFolder extends StatelessWidget {
  const ItemByFolder({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        if (libraryController.selectedItems.isEmpty) {
          libraryController.navigateToBack();
        } else {
          libraryController.selectedItems.clear();
        }
      },
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
            onPressed: () => Get.bottomSheet(ItemCreateSheet()),
            child: CustomIcon(icon: 'add', size: 24),
          ),
        ),
      ),
    );
  }
}
