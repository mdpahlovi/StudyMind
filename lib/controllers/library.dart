import 'package:get/get.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/models/library.dart';
import 'package:studymind/routes/routes.dart' show AppRoutes;
import 'package:studymind/services/library.dart';

enum ItemType { folder, note, document, flashcard, audio, video, image }

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

  final RxBool isLoading = true.obs;
  final Rxn<LibraryItem> libraryItem = Rxn<LibraryItem>();
  final RxList<LibraryItem> folderItems = <LibraryItem>[].obs;
  final RxList<LibraryItem> breadcrumbs = <LibraryItem>[].obs;
  final RxInt total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLibraryItems(parentUid: Get.parameters['uid']);
  }

  @override
  void onClose() {
    super.onClose();
    isLoading.value = true;
    libraryItem.value = null;
    folderItems.clear();
    breadcrumbs.clear();
  }

  void fetchLibraryItems({String? parentUid}) {
    isLoading.value = true;

    libraryService.getLibraryItems(GetLibraryItemsQuery(parentUid: parentUid)).then((response) {
      if (response.success && response.data != null) {
        final libraryResponse = LibraryResponse.fromJson(response.data);
        folderItems.value = libraryResponse.libraryItems;
        total.value = libraryResponse.total;
      } else {
        Notification().error(response.message);
        Get.back();
      }

      isLoading.value = false;
    });
  }

  void fetchLibraryItemsByType({String search = '', ItemType? type}) {
    isLoading.value = true;

    libraryService.getLibraryItemsByType(GetLibraryItemsByTypeQuery(search: search, type: type)).then((response) {
      if (response.success && response.data != null) {
        final libraryResponse = LibraryResponse.fromJson(response.data);
        folderItems.value = libraryResponse.libraryItems;
        total.value = libraryResponse.total;
      } else {
        Notification().error(response.message);
        Get.back();
      }

      isLoading.value = false;
    });
  }

  void fetchLibraryItemByUid(String uid) {
    isLoading.value = true;

    libraryService.getLibraryItemByUid(uid).then((response) {
      if (response.success && response.data != null) {
        final fetchedItem = LibraryItem.fromJson(response.data);
        libraryItem.value = fetchedItem;
      } else {
        Notification().error(response.message);
        Get.back();
      }

      isLoading.value = false;
    });
  }

  void navigateToFolder(LibraryItem item) {
    breadcrumbs.add(item);

    Get.toNamed(AppRoutes.library.replaceFirst(':uid', item.uid));
    fetchLibraryItems(parentUid: item.uid);
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

  void refreshData() {
    final parentUid = Get.parameters['uid'];

    if (Get.currentRoute == AppRoutes.home) {
      fetchLibraryItems(parentUid: null);
    } else {
      fetchLibraryItems(parentUid: parentUid);
    }
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
