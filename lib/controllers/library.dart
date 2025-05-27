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
  final String? parentUid;
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
    this.parentUid,
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
      parentUid: json['parentUid'],
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
      'parentUid': parentUid,
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
  final LibraryItem? parent;
  final List<LibraryItem> libraryItems;
  final int total;

  LibraryResponse({this.parent, required this.libraryItems, required this.total});

  factory LibraryResponse.fromJson(Map<String, dynamic> json) {
    return LibraryResponse(
      parent: json['parent'] != null ? LibraryItem.fromJson(json['parent']) : null,
      libraryItems: List<LibraryItem>.from(json['libraryItems'].map((x) => LibraryItem.fromJson(x))),
      total: json['total'] ?? 0,
    );
  }
}

class LibraryController extends GetxController {
  final libraryService = LibraryService();

  final RxBool isLoading = true.obs;
  final Rxn<LibraryItem> parent = Rxn<LibraryItem>();
  final RxList<LibraryItem> libraryItems = <LibraryItem>[].obs;
  final RxInt total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLibraryItems(parentUid: Get.parameters['uid']);
  }

  @override
  void onClose() {
    super.onClose();
    libraryItems.clear();
    parent.value = null;
    isLoading.value = true;
  }

  void fetchLibraryItems({String? parentUid}) {
    isLoading.value = true;

    libraryService.getLibraryItems(GetLibraryItemsQuery(parentUid: parentUid)).then((response) {
      if (response.success && response.data != null) {
        final libraryResponse = LibraryResponse.fromJson(response.data);
        parent.value = libraryResponse.parent;
        libraryItems.value = libraryResponse.libraryItems;
        total.value = libraryResponse.total;
      } else {
        Notification().error(response.message);
        Get.back();
      }

      isLoading.value = false;
    });
  }

  void navigateToFolder(String uid) {
    Get.toNamed(AppRoutes.library.replaceFirst(':uid', uid));
    fetchLibraryItems(parentUid: uid);
  }

  void navigateToBack() {
    if (parent.value != null) {
      Get.back();
      fetchLibraryItems(parentUid: parent.value!.parentUid);
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
      'Total Items': libraryItems.length,
      'Folders': libraryItems.where((item) => item.type == ItemType.folder).length,
      'Notes': libraryItems.where((item) => item.type == ItemType.note).length,
      'Documents': libraryItems.where((item) => item.type == ItemType.document).length,
      'Flashcards': libraryItems.where((item) => item.type == ItemType.flashcard).length,
      'Audios': libraryItems.where((item) => item.type == ItemType.audio).length,
      'Videos': libraryItems.where((item) => item.type == ItemType.video).length,
      'Images': libraryItems.where((item) => item.type == ItemType.image).length,
    };
  }
}
