import 'package:get/get.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/models/library.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/services/library.dart';

enum ItemType { folder, note, document, flashcard, audio, video, image }

class LibraryItem {
  final int id;
  final String uid;
  final bool isActive;
  final bool isEmbedded;
  final String name;
  final ItemType type;
  final int? parentId;
  final int userId;
  final Map<String, dynamic>? metadata;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  LibraryItem({
    required this.id,
    required this.uid,
    required this.isActive,
    required this.isEmbedded,
    required this.name,
    required this.type,
    this.parentId,
    required this.userId,
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
      isEmbedded: ['DOCUMENT', 'AUDIO', 'VIDEO'].contains(json['type']) ? json['isEmbedded'] : true,
      name: json['name'],
      type: ItemType.values.byName(json['type'].toLowerCase()),
      parentId: json['parentId'],
      userId: json['userId'],
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
      'type': type.name.toUpperCase(),
      'parentId': parentId,
      'userId': userId,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class LibraryResponse {
  final List<LibraryItem> libraryItems;
  final int total;

  LibraryResponse({required this.libraryItems, required this.total});

  factory LibraryResponse.fromJson(Map<String, dynamic> json) {
    return LibraryResponse(
      libraryItems: List<LibraryItem>.from(json['libraryItems'].map((x) => LibraryItem.fromJson(x))),
      total: json['total'] ?? 0,
    );
  }
}

class LibraryController extends GetxController {
  final libraryService = LibraryService();

  final RxBool isLoadingItem = true.obs;
  final RxBool isLoadingType = true.obs;
  final RxBool isLoadingFolder = true.obs;
  final Rxn<LibraryItem> libraryItem = Rxn<LibraryItem>(); // To show in item details screen
  final RxList<LibraryItem> libraryItems = <LibraryItem>[].obs; // To show in by type screen
  final RxList<LibraryItem> folderItems = <LibraryItem>[].obs; // To show in library and it's folder screen
  final RxList<LibraryItem> breadcrumbs = <LibraryItem>[].obs; // To navigate between library and it's folder screen
  final RxList<LibraryItem> selectedItems =
      <LibraryItem>[].obs; // To handle selected items in library and it's folder screen

  @override
  void onInit() {
    super.onInit();
    fetchLibraryItemsByType();
    fetchLibraryItems();
  }

  @override
  void onClose() {
    super.onClose();
    isLoadingItem.value = true;
    isLoadingType.value = true;
    isLoadingFolder.value = true;
    libraryItem.value = null;
    libraryItems.clear();
    folderItems.clear();
    breadcrumbs.clear();
  }

  void fetchLibraryItems({String? parentUid, int page = 1, int limit = 12}) {
    isLoadingFolder.value = true;

    final query = GetLibraryItemsQuery(parentUid: parentUid, page: page, limit: limit);
    libraryService.getLibraryItems(query).then((response) {
      if (response.success && response.data != null) {
        final libraryResponse = LibraryResponse.fromJson(response.data);
        folderItems.value = libraryResponse.libraryItems;
      } else {
        Notification.error(response.message);
      }

      isLoadingFolder.value = false;
    });
  }

  void fetchLibraryItemsByType({String search = '', String type = '', int page = 1, int limit = 12}) {
    isLoadingType.value = true;

    final query = GetLibraryItemsByTypeQuery(search: search, type: type, page: page, limit: limit);
    libraryService.getLibraryItemsByType(query).then((response) {
      if (response.success && response.data != null) {
        final libraryResponse = LibraryResponse.fromJson(response.data);
        libraryItems.value = libraryResponse.libraryItems;
      } else {
        Notification.error(response.message);
      }

      isLoadingType.value = false;
    });
  }

  void fetchLibraryItemByUid(String uid) {
    isLoadingItem.value = true;

    libraryService.getLibraryItemByUid(uid).then((response) {
      if (response.success && response.data != null) {
        final fetchedItem = LibraryItem.fromJson(response.data);
        libraryItem.value = fetchedItem;
      } else {
        Notification.error(response.message);
      }

      isLoadingItem.value = false;
    });
  }

  void navigateToItem(LibraryItem item, {bool isReplace = false}) {
    breadcrumbs.add(item);

    if (item.type == ItemType.folder) {
      final page = AppRoutes.itemByFolder.replaceFirst(':uid', item.uid);
      !isReplace ? Get.toNamed(page) : Get.offNamed(page);

      fetchLibraryItems(parentUid: item.uid);
    } else {
      final page = AppRoutes.itemDetails.replaceFirst(':uid', item.uid);
      !isReplace ? Get.toNamed(page) : Get.offNamed(page);

      fetchLibraryItemByUid(item.uid);
    }
  }

  void navigateToBack() {
    if (breadcrumbs.isNotEmpty) {
      breadcrumbs.removeLast();

      Get.back();
      if (breadcrumbs.isEmpty) {
        fetchLibraryItems(parentUid: null);
      } else {
        fetchLibraryItems(parentUid: breadcrumbs.last.uid);
      }
    }
  }

  void backFromDetail() {
    if (breadcrumbs.isNotEmpty) {
      breadcrumbs.removeLast();

      Get.back();
    }
  }

  // Refresh data for by type screen
  void refreshByType() {
    final type = Get.parameters['type'];

    if (type == 'recent_items') {
      fetchLibraryItemsByType(type: '');
    } else if (type != null) {
      fetchLibraryItemsByType(type: type);
    }
  }

  // Refresh data for library and folder screen
  void refreshByFolder() {
    final parentUid = Get.parameters['uid'];

    if (Get.currentRoute == AppRoutes.home) {
      fetchLibraryItems(parentUid: null);
    } else {
      fetchLibraryItems(parentUid: parentUid);
    }
  }

  // Refresh data for item details screen
  void refreshItemDetails() {
    final uid = Get.parameters['uid'];

    if (uid != null) fetchLibraryItemByUid(uid);
  }

  Map<String, int> getFolderStats() {
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
