import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/models/library.dart';
import 'package:studymind/services/library.dart';

class Folder {
  final int? id;
  final String name;
  final String path;

  Folder({this.id, required this.name, required this.path});

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(id: json['id'], name: json['name'], path: json['path']);
}

class ItemCreateController extends GetxController {
  final libraryService = LibraryService();

  final RxBool isCreating = false.obs;
  final RxBool isLoadingFolder = true.obs;
  final RxList<Folder> folders = <Folder>[].obs;
  final Rxn<Folder> selectedFolder = Rxn<Folder>();

  void setSelectedFolder(int? id) {
    selectedFolder.value = folders.firstWhere((folder) => folder.id == id);
  }

  // Folder Metadata
  final RxString folderColor = '#A8C686'.obs;
  final RxString folderIcon = 'folder'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFolders();
  }

  @override
  void onClose() {
    super.onClose();
    isCreating.value = false;
    isLoadingFolder.value = true;
    folders.clear();
  }

  void fetchFolders() {
    isLoadingFolder.value = true;

    libraryService.getLibraryItemsWithPath(GetLibraryItemsWithPathQuery(type: 'FOLDER')).then((response) {
      if (response.success && response.data != null) {
        final folderResponse = response.data.map((x) => Folder.fromJson(x));
        folders.value = [Folder(id: null, name: "Root Folder", path: "/"), ...folderResponse];
        selectedFolder.value = folders.first;
      } else {
        Notification.error(response.message);
        Get.back();
      }

      isLoadingFolder.value = false;
    });
  }

  void createLibraryItem(ItemType type, String name, String? description) {
    isCreating.value = true;
    final CreateLibraryItem createLibraryItemData;

    switch (type) {
      case ItemType.folder:
        createLibraryItemData = CreateLibraryItem(
          name: name,
          type: ItemType.folder,
          parentId: selectedFolder.value?.id,
          metadata: {'color': folderColor.value, 'icon': folderIcon.value},
        );
        break;
      case ItemType.note:
        createLibraryItemData = CreateLibraryItem(name: name, type: ItemType.note);
        break;
      case ItemType.document:
        createLibraryItemData = CreateLibraryItem(name: name, type: ItemType.document);
        break;
      case ItemType.flashcard:
        createLibraryItemData = CreateLibraryItem(name: name, type: ItemType.flashcard);
        break;
      case ItemType.audio:
        createLibraryItemData = CreateLibraryItem(name: name, type: ItemType.audio);
        break;
      case ItemType.video:
        createLibraryItemData = CreateLibraryItem(name: name, type: ItemType.video);
        break;
      case ItemType.image:
        createLibraryItemData = CreateLibraryItem(name: name, type: ItemType.image);
        break;
    }

    libraryService.createLibraryItem(createLibraryItemData).then((response) {
      if (response.success && response.data != null) {
        Notification.success(response.message);
        Get.back();
      } else {
        Notification.error(response.message);
      }

      isCreating.value = false;
    });
  }
}
