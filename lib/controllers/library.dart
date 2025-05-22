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

enum ItemType { folder, note, document, flashcard, recording }

class LibraryController extends GetxController {
  final RxList<LibraryItem> items = <LibraryItem>[].obs;
  final RxList<LibraryItem> parentItems = <LibraryItem>[].obs;
  final RxnString parentId = RxnString();
  final RxList<LibraryItem> breadcrumbs = <LibraryItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDataFromJson();
  }

  // Load data from JSON
  void loadDataFromJson() {
    try {
      List<dynamic> sampleData = jsonDecode(SampleData.libraryData);
      List<LibraryItem> libraryItems = [];

      for (int index = 0; index < sampleData.length; index++) {
        LibraryItem item = LibraryItem.fromJson(sampleData[index]);
        libraryItems.add(item);
      }

      isLoading.value = true;
      items.assignAll(libraryItems);

      // Load root items by default
      loadFolderData(null);

      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load data: $error');
    }
  }

  // Get folder contents by folderId
  void loadFolderData(String? folderId) {
    isLoading.value = true;

    List<LibraryItem> folderItems = items.where((item) => item.parentId == folderId && !item.isDeleted).toList();

    // Sort: folders first, then by sort_order, then alphabetically
    folderItems.sort((a, b) {
      if (a.type == ItemType.folder && b.type != ItemType.folder) return -1;
      if (a.type != ItemType.folder && b.type == ItemType.folder) return 1;
      int sortComparison = a.sortOrder.compareTo(b.sortOrder);
      if (sortComparison != 0) return sortComparison;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    parentItems.assignAll(folderItems);
    parentId.value = folderId;

    // Update breadcrumb
    loadBreadcrumb(folderId);

    isLoading.value = false;
  }

  // Update breadcrumbs by folderId
  void loadBreadcrumb(String? folderId) {
    breadcrumbs.clear();

    if (folderId == null) return;

    List<LibraryItem> hierarchy = [];
    LibraryItem? currentItem = getItemById(folderId);

    while (currentItem != null) {
      hierarchy.insert(0, currentItem);
      if (currentItem.parentId == null) break;
      currentItem = getItemById(currentItem.parentId!);
    }

    breadcrumbs.assignAll(hierarchy);
  }

  // Navigate to folder
  void navigateToFolder(String folderId) {
    LibraryItem? folder = getItemById(folderId);
    if (folder != null && folder.type == ItemType.folder) {
      loadFolderData(folderId);
    }
  }

  // Navigate back to parent folder
  void navigateBack() {
    if (breadcrumbs.isNotEmpty) {
      LibraryItem currentFolder = breadcrumbs.last;
      loadFolderData(currentFolder.parentId);
    }
  }

  // Navigate to root
  void navigateToRoot() {
    loadFolderData(null);
  }

  // Get item by ID
  LibraryItem? getItemById(String id) {
    try {
      return items.firstWhere((item) => item.id == id && !item.isDeleted);
    } catch (e) {
      return null;
    }
  }

  // Search items
  List<LibraryItem> searchItems(String query) {
    if (query.isEmpty) return [];

    String lowercaseQuery = query.toLowerCase();
    return items.where((item) => item.name.toLowerCase().contains(lowercaseQuery) && !item.isDeleted).toList();
  }

  // Get items by type
  List<LibraryItem> getItemsByType(ItemType type) {
    return items.where((item) => item.type == type && !item.isDeleted).toList();
  }

  // Get recent items
  List<LibraryItem> getRecentItems({int days = 7}) {
    DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    List<LibraryItem> recentItems = items.where((item) => item.updatedAt.isAfter(cutoffDate) && !item.isDeleted).toList();

    recentItems.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return recentItems;
  }

  // Get folder statistics
  Map<String, int> getFolderStats(String? folderId) {
    List<LibraryItem> folderItems = items.where((item) => item.parentId == folderId && !item.isDeleted).toList();

    return {
      'Total Items': folderItems.length,
      'Folders': folderItems.where((item) => item.type == ItemType.folder).length,
      'Notes': folderItems.where((item) => item.type == ItemType.note).length,
      'Documents': folderItems.where((item) => item.type == ItemType.document).length,
      'Flashcards': folderItems.where((item) => item.type == ItemType.flashcard).length,
      'Recordings': folderItems.where((item) => item.type == ItemType.recording).length,
    };
  }

  // Refresh data
  void refreshData() {
    loadDataFromJson();
  }

  // Debug: Print folder structure
  void printFolderStructure({String? parentId, int indent = 0}) {
    List<LibraryItem> folderItems = items.where((item) => item.parentId == parentId && !item.isDeleted).toList();

    folderItems.sort((a, b) {
      if (a.type == ItemType.folder && b.type != ItemType.folder) return -1;
      if (a.type != ItemType.folder && b.type == ItemType.folder) return 1;
      return a.sortOrder.compareTo(b.sortOrder);
    });

    for (LibraryItem item in folderItems) {
      String prefix = '  ' * indent;
      String icon =
          item.type == ItemType.folder
              ? '📁'
              : item.type == ItemType.note
              ? '📄'
              : item.type == ItemType.document
              ? '📋'
              : item.type == ItemType.flashcard
              ? '🎴'
              : item.type == ItemType.recording
              ? '🎤'
              : '📄';

      print('$prefix$icon ${item.name}');

      if (item.type == ItemType.folder) {
        printFolderStructure(parentId: item.id, indent: indent + 1);
      }
    }
  }
}
