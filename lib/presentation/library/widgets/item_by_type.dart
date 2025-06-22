import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_grid.dart';
import 'package:studymind/presentation/library/widgets/item_loader.dart';
import 'package:studymind/widgets/library/item_app_bar.dart';

class ItemByType extends StatefulWidget {
  const ItemByType({super.key});

  @override
  State<ItemByType> createState() => ItemByTypeState();
}

class ItemByTypeState extends State<ItemByType> {
  late String searchQuery;
  Timer? debounce;

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        if (libraryController.selectedItems.isEmpty) {
          Get.back();
        } else {
          libraryController.selectedItems.clear();
        }
      },
      child: RefreshIndicator(
        onRefresh: () async => libraryController.refreshByType(),
        child: Scaffold(
          appBar: buildItemAppBar(),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                onChanged: (value) => setState(() {
                  searchQuery = value;
                  if (debounce?.isActive ?? false) debounce?.cancel();
                  debounce = Timer(const Duration(milliseconds: 500), () {
                    final type = Get.parameters['type'];

                    if (type == 'recent_activity') {
                      libraryController.fetchLibraryItemsByType(search: searchQuery, type: '');
                    } else if (type != null) {
                      libraryController.fetchLibraryItemsByType(search: searchQuery, type: type);
                    }
                  });
                }),
                decoration: InputDecoration(hintText: 'Search in library...', prefixIcon: Icon(Icons.search)),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final List<LibraryItem> libraryItems = libraryController.libraryItems;

                if (libraryController.isLoadingType.value) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) => const ItemLoaderCard(),
                  );
                }

                if (libraryItems.isEmpty) {
                  return SizedBox(
                    height: size.height * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(HugeIcons.strokeRoundedSadDizzy, size: 64),
                        const SizedBox(height: 16),
                        Text('Oops! No items found', style: textTheme.bodyMedium),
                      ],
                    ),
                  );
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
                  itemCount: libraryItems.length,
                  itemBuilder: (context, index) => ItemCard(item: libraryItems[index]),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
