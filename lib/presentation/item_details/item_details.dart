import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/item_details/widgets/view_audio.dart';
import 'package:studymind/presentation/item_details/widgets/view_document.dart';
import 'package:studymind/presentation/item_details/widgets/view_flashcard.dart';
import 'package:studymind/presentation/item_details/widgets/view_image.dart';
import 'package:studymind/presentation/item_details/widgets/view_note.dart';
import 'package:studymind/presentation/item_details/widgets/view_video.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_back_button.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        libraryController.backFromDetail();
      },
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
            final LibraryItem? item = libraryController.libraryItem.value;

            if (libraryController.isLoadingItem.value) return const Center(child: CircularProgressIndicator());

            if (item == null) {
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

            switch (item.type) {
              case ItemType.folder:
                return const Center(child: Text('Folder Details'));
              case ItemType.note:
                return ViewNote(item: item);
              case ItemType.document:
                return ViewDocument(item: item);
              case ItemType.flashcard:
                return ViewFlashcard(item: item);
              case ItemType.audio:
                return ViewAudio(item: item);
              case ItemType.video:
                return ViewVideo(item: item);
              case ItemType.image:
                return ViewImage(item: item);
            }
          }),
        ),
      ),
    );
  }
}
