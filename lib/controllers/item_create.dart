import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/models/library.dart';
import 'package:studymind/services/library.dart';
import 'package:studymind/widgets/dialog/success.dart';

class Folder {
  final int? id;
  final String? uid;
  final String name;
  final String path;

  Folder({this.id, this.uid, required this.name, required this.path});

  factory Folder.fromJson(Map<String, dynamic> json) =>
      Folder(id: json['id'], uid: json['uid'], name: json['name'], path: json['path']);
}

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});

  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      Flashcard(question: json['question'], answer: json['answer']);

  Map<String, String> toJson() => {'question': question, 'answer': answer};
}

class ItemCreateController extends GetxController {
  final libraryService = LibraryService();
  final LibraryController libraryController = Get.find<LibraryController>();

  final RxBool isCreating = false.obs;
  final RxBool isLoadingFolder = true.obs;
  final RxList<Folder> folders = <Folder>[].obs;
  final Rxn<Folder> selectedFolder = Rxn<Folder>();

  void setSelectedFolder(String? uid) {
    selectedFolder.value = folders.firstWhere((folder) => folder.uid == uid);
  }

  // Folder Metadata
  final RxString folderColor = '#A8C686'.obs;
  final RxString folderIcon = 'folder'.obs;

  // Note Metadata
  final QuillController noteController = QuillController.basic();

  // Flashcard Metadata
  final RxList<Flashcard> flashcards = <Flashcard>[].obs;

  // Document, Audio, Video, Image Metadata
  final Rxn<PlatformFile> selectedFile = Rxn<PlatformFile>();

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
    selectedFolder.value = null;

    // Folder Metadata
    folderColor.value = '#A8C686';
    folderIcon.value = 'folder';

    // Note Metadata
    noteController.dispose();

    // Flashcard Metadata
    flashcards.clear();

    // Document, Audio, Video, Image Metadata
    selectedFile.value = null;
  }

  void fetchFolders() {
    isLoadingFolder.value = true;

    libraryService.getLibraryItemsWithPath(GetLibraryItemsWithPathQuery(type: 'FOLDER')).then((response) {
      if (response.success && response.data != null) {
        final folderResponse = response.data.map((x) => Folder.fromJson(x));
        folders.value = [Folder(id: null, uid: null, name: "Root Folder", path: "/"), ...folderResponse];
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
        createLibraryItemData = CreateLibraryItem(
          name: name,
          type: ItemType.note,
          parentId: selectedFolder.value?.id,
          metadata: {'content': noteController.document.toDelta().toJson(), 'description': description},
        );
        break;

      case ItemType.flashcard:
        createLibraryItemData = CreateLibraryItem(
          name: name,
          type: ItemType.flashcard,
          parentId: selectedFolder.value?.id,
          metadata: {
            'content': jsonEncode(flashcards.map((flashcard) => flashcard.toJson()).toList()),
            'description': description,
          },
        );
        break;
      case ItemType.document:
      case ItemType.audio:
      case ItemType.video:
      case ItemType.image:
        createLibraryItemData = CreateLibraryItem(
          name: name,
          type: type,
          parentId: selectedFolder.value?.id,
          metadata: {'description': description},
          file: selectedFile.value,
        );
        break;
    }

    libraryService.createLibraryItem(createLibraryItemData).then((response) {
      if (response.success && response.data != null) {
        // Reset Metadata
        folderColor.value = '#A8C686';
        folderIcon.value = 'folder';
        noteController.clear();
        flashcards.clear();

        final itemResponse = LibraryItem.fromJson(response.data);
        libraryController.fetchLibraryItems(parentUid: selectedFolder.value?.uid);
        libraryController.fetchLibraryItemsByRecent();
        Get.dialog(
          SuccessDialog(
            message: '${itemResponse.name} ${itemResponse.type.name} has been created. Do you want to open it?',
            onConfirmed: () => libraryController.navigateToItem(itemResponse, isReplace: true),
          ),
        );
      } else {
        Notification.error(response.message);
      }

      isCreating.value = false;
    });
  }
}
