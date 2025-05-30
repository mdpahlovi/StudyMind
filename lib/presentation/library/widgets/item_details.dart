import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_back_button.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: RefreshIndicator(
        onRefresh: () async => libraryController.refreshItemDetails(),
        child: Scaffold(
          appBar: AppBar(
            leading: CustomBackButton(onPressed: libraryController.backFromDetail),
            title: Obx(() {
              final breadcrumbs = libraryController.breadcrumbs;
              return breadcrumbs.isEmpty ? const Text('') : Text(breadcrumbs.last.name);
            }),
          ),
          body: Obx(() {
            if (libraryController.isLoadingItem.value) return const Center(child: CircularProgressIndicator());

            if (libraryController.libraryItem.value == null) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(HugeIcons.strokeRoundedAlert01, size: 64, color: colorPalette.error),
                    const SizedBox(height: 16),
                    Text('Something went wrong', style: textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text('Item not found! Please try again later.', style: textTheme.bodySmall),
                  ],
                ),
              );
            }

            switch (libraryController.libraryItem.value!.type) {
              case ItemType.folder:
                return const Center(child: Text('Folder Details'));
              case ItemType.note:
                return const Center(child: Text('Note Details'));
              case ItemType.document:
                return const Center(child: Text('Document Details'));
              case ItemType.flashcard:
                return const Center(child: Text('Flashcard Details'));
              case ItemType.audio:
                return const Center(child: Text('Audio Details'));
              case ItemType.video:
                return const Center(child: Text('Video Details'));
              case ItemType.image:
                return const Center(child: Text('Image Details'));
            }
          }),
        ),
      ),
    );
  }
}
