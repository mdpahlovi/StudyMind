import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/core/utils.dart';
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
  final RxBool isUpdating = false.obs;
  final RxBool isLoadingFolder = true.obs;
  final RxList<Folder> folders = <Folder>[].obs;
  final Rxn<Folder> selectedFolder = Rxn<Folder>();

  void setSelectedFolder(String? uid) {
    selectedFolder.value = folders.firstWhere((folder) => folder.uid == uid);
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
    isUpdating.value = false;
    isLoadingFolder.value = true;
    folders.clear();
    selectedFolder.value = null;

    // Item Common Data
    nameController.dispose();
    descriptionController.dispose();

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

    libraryService.getLibraryItemsWithPath(type: 'FOLDER').then((response) {
      if (response.success && response.data != null) {
        final folderResponse = response.data.map((x) => Folder.fromJson(x));
        folders.value = [Folder(id: null, uid: null, name: "Root Folder", path: "/"), ...folderResponse];
        selectedFolder.value = folders.first;
      } else {
        Notification.error(response.message);
      }

      isLoadingFolder.value = false;
    });
  }

  void createLibraryItem(ItemType type) async {
    isCreating.value = true;
    final CreateLibraryItem? createLibraryItemData;

    switch (type) {
      case ItemType.folder:
        createLibraryItemData = CreateLibraryItem(
          name: nameController.text,
          type: ItemType.folder,
          parentId: selectedFolder.value?.id,
          metadata: {'color': folderColor.value, 'icon': folderIcon.value},
        );
        break;
      case ItemType.note:
        if (noteController.document.isEmpty() == false) {
          createLibraryItemData = CreateLibraryItem(
            name: nameController.text,
            type: ItemType.note,
            parentId: selectedFolder.value?.id,
            metadata: {
              'description': descriptionController.text,
              'content': deltaToMarkdown.convert(noteController.document.toDelta()),
            },
          );
        } else {
          createLibraryItemData = null;
        }
        break;
      case ItemType.document:
        if (selectedFile.value != null) {
          createLibraryItemData = CreateLibraryItem(
            name: nameController.text,
            type: type,
            parentId: selectedFolder.value?.id,
            metadata: {'description': descriptionController.text, 'fileType': selectedFile.value!.extension},
            file: selectedFile.value,
          );
        } else {
          createLibraryItemData = null;
        }
        break;
      case ItemType.flashcard:
        if (flashcards.isNotEmpty) {
          createLibraryItemData = CreateLibraryItem(
            name: nameController.text,
            type: ItemType.flashcard,
            parentId: selectedFolder.value?.id,
            metadata: {
              'content': flashcards.map((flashcard) => flashcard.toJson()).toList(),
              'cardCount': flashcards.length,
              'description': descriptionController.text,
            },
          );
        } else {
          createLibraryItemData = null;
        }
        break;
      case ItemType.audio:
        if (selectedFile.value != null) {
          createLibraryItemData = CreateLibraryItem(
            name: nameController.text,
            type: type,
            parentId: selectedFolder.value?.id,
            metadata: {
              'description': descriptionController.text,
              'fileType': selectedFile.value!.extension,
              'duration': await getAudioDuration(selectedFile.value!.path!),
            },
            file: selectedFile.value,
          );
        } else {
          createLibraryItemData = null;
        }
        break;
      case ItemType.video:
        if (selectedFile.value != null) {
          createLibraryItemData = CreateLibraryItem(
            name: nameController.text,
            type: type,
            parentId: selectedFolder.value?.id,
            metadata: {
              'description': descriptionController.text,
              'fileType': selectedFile.value!.extension,
              'duration': await getVideoDuration(selectedFile.value!.path!),
            },
            file: selectedFile.value,
          );
        } else {
          createLibraryItemData = null;
        }
        break;
      case ItemType.image:
        if (selectedFile.value != null) {
          createLibraryItemData = CreateLibraryItem(
            name: nameController.text,
            type: type,
            parentId: selectedFolder.value?.id,
            metadata: {
              'description': descriptionController.text,
              'fileType': selectedFile.value!.extension,
              'resolution': await getImageResolution(selectedFile.value!.path!),
            },
            file: selectedFile.value,
          );
        } else {
          createLibraryItemData = null;
        }
        break;
    }

    if (createLibraryItemData == null) {
      Notification.error('Please fill necessary fields.');
      isCreating.value = false;
      return;
    }

    libraryService.createLibraryItem(createLibraryItemData).then((response) {
      if (response.success && response.data != null) {
        // Reset Metadata
        nameController.clear();
        descriptionController.clear();
        folderColor.value = '#A8C686';
        folderIcon.value = 'folder';
        noteController.clear();
        flashcards.clear();
        selectedFile.value = null;

        final itemResponse = LibraryItem.fromJson(response.data);

        // Refetch
        libraryController.fetchLibraryItems(parentUid: selectedFolder.value?.uid);
        libraryController.fetchLibraryItemsByRecent();

        // Show Success Dialog
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

  void updateLoader(bool value) {
    isUpdating.value = value;

    if (Get.currentRoute.contains('/item_by_type')) {
      libraryController.isLoadingType.value = value;
    } else {
      libraryController.isLoadingFolder.value = value;
    }
  }

  void updateRefetch() {
    libraryController.selectedItems.clear();

    if (Get.currentRoute.contains('/item_by_type')) {
      libraryController.refreshByType();
    } else {
      libraryController.refreshByFolder();
    }

    libraryController.fetchLibraryItemsByRecent();
  }

  void updateLibraryItem(String uid, String name) {
    Get.back();
    updateLoader(true);

    final UpdateLibraryItem updateLibraryItemData = UpdateLibraryItem(uid: uid, name: name);

    libraryService.updateLibraryItem(updateLibraryItemData).then((response) {
      if (response.success && response.data != null) {
        updateRefetch();

        Notification.success(response.message);
      } else {
        Notification.error(response.message);
      }

      updateLoader(false);
    });
  }

  void updateBulkLibraryItem(List<LibraryItem> selectedItems, String action) {
    Get.back();
    updateLoader(true);

    final currentFolder = libraryController.breadcrumbs.isNotEmpty ? libraryController.breadcrumbs.last : null;

    final UpdateBulkLibraryItem updateBulkLibraryItemData = UpdateBulkLibraryItem(
      uid: selectedItems.map((e) => e.uid).toList(),
      isActive: action == 'REMOVE' ? false : true,
      parentId: action == 'MOVE' ? selectedFolder.value?.id : currentFolder?.id,
    );

    libraryService.updateBulkLibraryItem(updateBulkLibraryItemData).then((response) {
      if (response.success && response.data != null) {
        updateRefetch();

        Notification.success(response.message);
      } else {
        Notification.error(response.message);
      }

      updateLoader(false);
    });
  }
}
