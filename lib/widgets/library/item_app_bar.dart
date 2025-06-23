import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_options_sheet.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_back_button.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/notification_button.dart';

PreferredSizeWidget buildItemAppBar() {
  final LibraryController libraryController = Get.find<LibraryController>();
  final ColorPalette colorPalette = AppColors().palette;

  return AppBar(
    leading: Obx(() {
      final selectedItems = libraryController.selectedItems;

      if (selectedItems.isEmpty) {
        if (Get.currentRoute == AppRoutes.home) {
          return SizedBox();
        } else if (Get.currentRoute.contains('/item_by_type')) {
          return CustomBackButton();
        } else {
          return CustomBackButton(onPressed: libraryController.navigateToBack);
        }
      } else {
        return IconButton(
          icon: const CustomIcon(icon: 'cancel', size: 28),
          onPressed: () => selectedItems.clear(),
        );
      }
    }),
    title: Obx(() {
      final breadcrumbs = libraryController.breadcrumbs;
      final selectedItems = libraryController.selectedItems;

      if (selectedItems.isEmpty) {
        if (Get.currentRoute.contains('/item_by_type')) {
          switch (Get.parameters['type']) {
            case 'recent_items':
              return Text('Recent Items');
            default:
              return Text(Get.parameters['type']?.capitalize ?? '');
          }
        } else {
          return Text(breadcrumbs.isEmpty ? 'Library' : breadcrumbs.last.name);
        }
      } else {
        return Text('${selectedItems.length}  items');
      }
    }),
    actions: [
      Obx(() {
        final selectedItems = libraryController.selectedItems;
        final libraryItemByType = libraryController.libraryItems;
        final libraryItemsByFolder = libraryController.folderItems;

        if (selectedItems.isEmpty) return NotificationButton();

        final List<LibraryItem> libraryItems = [];
        if (Get.currentRoute.contains('/item_by_type')) {
          libraryItems.addAll(libraryItemByType);
        } else {
          libraryItems.addAll(libraryItemsByFolder);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: colorPalette.content),
                ),
                child: libraryItems.length == selectedItems.length
                    ? const CustomIcon(icon: 'tick', size: 16)
                    : const SizedBox(),
              ),
              onPressed: () {
                if (libraryItems.length == selectedItems.length) {
                  selectedItems.clear();
                } else {
                  selectedItems.clear();
                  selectedItems.addAll(libraryItems);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => Get.bottomSheet(ItemOptionsSheet(selectedItems: selectedItems)),
            ),
          ],
        );
      }),
    ],
  );
}
