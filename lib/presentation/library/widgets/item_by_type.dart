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
  late String searchQuery = "";
  Timer? debounce;

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;
    final itemWidth = (size.width - 16 * 2 - 12) / 2;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        if (libraryController.selectedItems.isEmpty) {
          Get.back();
          if (searchQuery.isNotEmpty) {
            libraryController.fetchLibraryItemByType();
          }
        } else {
          libraryController.selectedItems.clear();
        }
      },
      child: RefreshIndicator(
        onRefresh: () async => libraryController.fetchLibraryItemByType(),
        child: Scaffold(
          appBar: buildItemAppBar(isSearchKey: searchQuery.isNotEmpty),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  onChanged: (value) => setState(() {
                    searchQuery = value;
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: 500), () {
                      libraryController.fetchLibraryItemByType(search: searchQuery, type: '');
                    });
                  }),
                  decoration: InputDecoration(hintText: 'Search in library...', prefixIcon: Icon(Icons.search)),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final List<LibraryItem> libraryItems = libraryController.libraryItems;

                  if (libraryController.isLoadingType.value) {
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(
                        8,
                        (index) => SizedBox(width: itemWidth, height: 160, child: const ItemLoaderCard()),
                      ),
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

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: libraryItems.map((item) {
                      return SizedBox(
                        width: itemWidth,
                        child: ItemCard(item: item),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
