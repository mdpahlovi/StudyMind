import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_card.dart';
import 'package:studymind/presentation/library/widgets/item_empty.dart';
import 'package:studymind/presentation/library/widgets/item_loader.dart';
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
            title: Obx(() => Text(libraryController.parent.value?.name ?? '')),
            actions: [NotificationButton()],
          ),
          body: Obx(() {
            List<LibraryItem> libraryItems = libraryController.libraryItems.toList();

            if (libraryController.isLoading.value) return const ItemLoader();

            if (libraryItems.isEmpty) return const ItemEmpty();

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: libraryItems.length,
              itemBuilder: (context, index) => ItemCard(item: libraryItems[index]),
            );
          }),
        ),
      ),
    );
  }
}
