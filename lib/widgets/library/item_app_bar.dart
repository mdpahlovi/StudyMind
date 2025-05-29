import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_options.dart';
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

      return selectedItems.isEmpty
          ? const CustomBackButton()
          : IconButton(icon: const CustomIcon(icon: 'cancel', size: 28), onPressed: () => selectedItems.clear());
    }),
    title: Obx(() {
      final breadcrumbs = libraryController.breadcrumbs;
      final selectedItems = libraryController.selectedItems;

      if (selectedItems.isEmpty) {
        if (Get.currentRoute == AppRoutes.home) {
          return Text("Library");
        } else if (Get.currentRoute.contains('/item_by_type')) {
          return Text(Get.parameters['type']!.split('_').map((e) => e.capitalize!).join(' '));
        } else {
          return Text(breadcrumbs.last.name);
        }
      } else {
        return Text('${selectedItems.length} Items');
      }
    }),
    actions: [
      Obx(() {
        final selectedItems = libraryController.selectedItems;

        if (selectedItems.isEmpty) return NotificationButton();

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
                child: CustomIcon(icon: 'tick', size: 16),
              ),
              onPressed: () => Get.bottomSheet(ItemOptions()),
            ),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () => Get.bottomSheet(ItemOptions())),
          ],
        );
      }),
    ],
  );
}
