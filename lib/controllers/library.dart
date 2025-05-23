import 'dart:convert';

import 'package:get/get.dart';
import 'package:studymind/constants/sample_data.dart';

class LibraryItem {
  final String id;
  final String name;
  final ItemType type;
  final String? parentId;
  final String userId;
  final String path;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;
  final bool isDeleted;
  final int sortOrder;

  LibraryItem({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    required this.userId,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
    this.isDeleted = false,
    this.sortOrder = 0,
  });

  factory LibraryItem.fromJson(Map<String, dynamic> json) {
    return LibraryItem(
      id: json['id'],
      name: json['name'],
      type: ItemType.values.firstWhere((e) => e.toString().split('.').last == json['type'].toLowerCase()),
      parentId: json['parent_id'],
      userId: json['user_id'],
      path: json['path'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      metadata: json['metadata'],
      isDeleted: json['is_deleted'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'parent_id': parentId,
      'user_id': userId,
      'path': path,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'metadata': metadata,
      'is_deleted': isDeleted,
      'sort_order': sortOrder,
    };
  }
}

enum ItemType { folder, note, document, flashcard, media }

class LibraryController extends GetxController {
  final RxList<LibraryItem> allItems = <LibraryItem>[].obs;
  final RxList<LibraryItem> currentFolderItems = <LibraryItem>[].obs;
  final Rxn<LibraryItem?> selectedItem = Rxn();
  final RxList<LibraryItem> breadcrumb = <LibraryItem>[].obs;
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

  void loadFolderData(String? itemId) {
    isLoading.value = true;

    List<LibraryItem> folderItems = allItems.where((item) => item.parentId == itemId && !item.isDeleted).toList();

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

  void loadBreadcrumb(String? itemId) {
    breadcrumb.clear();

    if (itemId == null) return;

    List<LibraryItem> hierarchy = [];
    LibraryItem? currentItem = getItemById(itemId);

    while (currentItem != null) {
      hierarchy.insert(0, currentItem);
      if (currentItem.parentId == null) break;
      currentItem = getItemById(currentItem.parentId!);
    }

    breadcrumb.assignAll(hierarchy);
  }

  void navigateToFolder(String itemId) {
    LibraryItem? folder = getItemById(itemId);
    selectedItem.value = folder;
    if (folder != null && folder.type == ItemType.folder) {
      loadFolderData(itemId);
    }
  }

  void navigateBack() {
    if (selectedItem.value != null) {
      LibraryItem? parentFolder = getItemById(selectedItem.value!.parentId!);
      selectedItem.value = parentFolder;
      loadFolderData(parentFolder?.id);
    }
  }

  void navigateToRoot() {
    loadFolderData(null);
  }

  LibraryItem? getItemById(String id) {
    try {
      return allItems.firstWhere((item) => item.id == id && !item.isDeleted);
    } catch (e) {
      return null;
    }
  }

  List<LibraryItem> searchItems(String query) {
    if (query.isEmpty) return [];

    String lowercaseQuery = query.toLowerCase();
    return allItems.where((item) => item.name.toLowerCase().contains(lowercaseQuery) && !item.isDeleted).toList();
  }

  List<LibraryItem> getItemsByType(ItemType type) {
    return allItems.where((item) => item.type == type && !item.isDeleted).toList();
  }

  List<LibraryItem> getRecentItems({int days = 7}) {
    DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    List<LibraryItem> recentItems = allItems.where((item) => item.updatedAt.isAfter(cutoffDate) && !item.isDeleted).toList();

    recentItems.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return recentItems;
  }

  Map<String, int> getFolderStats(String? itemId) {
    List<LibraryItem> folderItems = allItems.where((item) => item.parentId == itemId && !item.isDeleted).toList();

    return {
      'Total Items': folderItems.length,
      'Folders': folderItems.where((item) => item.type == ItemType.folder).length,
      'Notes': folderItems.where((item) => item.type == ItemType.note).length,
      'Documents': folderItems.where((item) => item.type == ItemType.document).length,
      'Flashcards': folderItems.where((item) => item.type == ItemType.flashcard).length,
      'Medias': folderItems.where((item) => item.type == ItemType.media).length,
    };
  }

  void refreshData() {
    loadDataFromJson();
  }
}
