import 'dart:convert';

import 'package:get/get.dart';
import 'package:studymind/constants/sample_data.dart';

class LibraryItem {
  final int id;
  final String uid;
  final bool isActive;
  final String name;
  final ItemType type;
  final int? parentId;
  final int userId;
  final String path;
  final Map<String, dynamic>? metadata;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  LibraryItem({
    required this.id,
    required this.uid,
    required this.isActive,
    required this.name,
    required this.type,
    this.parentId,
    required this.userId,
    required this.path,
    this.metadata,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LibraryItem.fromJson(Map<String, dynamic> json) {
    return LibraryItem(
      id: json['id'],
      uid: json['uid'],
      isActive: json['isActive'],
      name: json['name'],
      type: ItemType.values.firstWhere((e) => e.toString().split('.').last == json['type'].toLowerCase()),
      parentId: json['parentId'],
      userId: json['userId'],
      path: json['path'],
      metadata: json['metadata'],
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'isActive': isActive,
      'name': name,
      'type': type.toString().split('.').last.toUpperCase(),
      'parentId': parentId,
      'userId': userId,
      'path': path,
      'metadata': metadata,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

enum ItemType { folder, note, document, flashcard, audio, video, image }

class LibraryController extends GetxController {
  final RxList<LibraryItem> allItems = <LibraryItem>[].obs;
  final RxList<LibraryItem> currentFolderItems = <LibraryItem>[].obs;
  final Rxn<LibraryItem> currentItem = Rxn<LibraryItem>();
  final RxList<LibraryItem> breadcrumbs = <LibraryItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDataFromJson();
  }

  void loadDataFromJson() {
    try {
      List<dynamic> sampleData = jsonDecode(SampleData.libraryData);
      List<LibraryItem> libraryItems = [];

      for (int index = 0; index < sampleData.length; index++) {
        LibraryItem item = LibraryItem.fromJson(sampleData[index]);
        libraryItems.add(item);
      }

      isLoading.value = true;
      allItems.assignAll(libraryItems);

      loadFolderData(null);

      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load data: $error');
    }
  }

  void loadFolderData(int? itemId) {
    isLoading.value = true;
    if (itemId == null) {
      currentItem.value = null;
    } else {
      currentItem.value = getItemById(itemId);
    }

    List<LibraryItem> folderItems = allItems.where((item) => item.isActive && item.parentId == itemId).toList();

    folderItems.sort((a, b) {
      if (a.type == ItemType.folder && b.type != ItemType.folder) return -1;
      if (a.type != ItemType.folder && b.type == ItemType.folder) return 1;
      int sortComparison = a.sortOrder.compareTo(b.sortOrder);
      if (sortComparison != 0) return sortComparison;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    currentFolderItems.assignAll(folderItems);
    loadBreadcrumb(itemId);

    isLoading.value = false;
  }

  void loadBreadcrumb(int? itemId) {
    breadcrumbs.clear();

    if (itemId == null) return;

    List<LibraryItem> hierarchy = [];
    LibraryItem? currentItem = getItemById(itemId);

    while (currentItem != null) {
      hierarchy.insert(0, currentItem);
      if (currentItem.parentId == null) break;
      currentItem = getItemById(currentItem.parentId!);
    }

    breadcrumbs.assignAll(hierarchy);
  }

  LibraryItem? getItemById(int id) {
    try {
      return allItems.firstWhere((item) => item.isActive && item.id == id);
    } catch (e) {
      return null;
    }
  }

  List<LibraryItem> searchItems(String query) {
    if (query.isEmpty) return [];

    String lowercaseQuery = query.toLowerCase();
    return allItems.where((item) => item.name.toLowerCase().contains(lowercaseQuery) && item.isActive).toList();
  }

  List<LibraryItem> getItemsByType(ItemType type) {
    return allItems.where((item) => item.type == type && item.isActive).toList();
  }

  List<LibraryItem> getRecentItems({int days = 7}) {
    DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    List<LibraryItem> recentItems =
        allItems.where((item) => item.updatedAt.isAfter(cutoffDate) && item.isActive).toList();

    recentItems.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return recentItems;
  }

  Map<String, int> getFolderStats(int? itemId) {
    List<LibraryItem> folderItems = allItems.where((item) => item.parentId == itemId && item.isActive).toList();

    return {
      'Total Items': folderItems.length,
      'Folders': folderItems.where((item) => item.type == ItemType.folder).length,
      'Notes': folderItems.where((item) => item.type == ItemType.note).length,
      'Documents': folderItems.where((item) => item.type == ItemType.document).length,
      'Flashcards': folderItems.where((item) => item.type == ItemType.flashcard).length,
      'Audios': folderItems.where((item) => item.type == ItemType.audio).length,
      'Videos': folderItems.where((item) => item.type == ItemType.video).length,
      'Images': folderItems.where((item) => item.type == ItemType.image).length,
    };
  }
}
