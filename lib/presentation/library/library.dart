import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_empty.dart';
import 'package:studymind/presentation/library/widgets/item_grid.dart';
import 'package:studymind/presentation/library/widgets/item_loader.dart';
import 'package:studymind/widgets/library/item_app_bar.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        if (libraryController.selectedItems.isNotEmpty) {
          libraryController.selectedItems.clear();
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
        ),
      ),
    );
  }
}
