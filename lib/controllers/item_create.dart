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
  void onClose() {
    super.onClose();
    isCreating.value = false;
    isUpdating.value = false;

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

  void createLibraryItem(ItemType type) async {
    isCreating.value = true;
    final CreateLibraryItem? createLibraryItemData;

    switch (type) {
      case ItemType.folder:
        createLibraryItemData = CreateLibraryItem(
          name: nameController.text,
          type: ItemType.folder,
          parentId: libraryController.selectedFolder.value?.id,
          metadata: {'color': folderColor.value, 'icon': folderIcon.value},
        );
        break;
      case ItemType.note:
        if (noteController.document.isEmpty() == false) {
          createLibraryItemData = CreateLibraryItem(
            name: nameController.text,
            type: ItemType.note,
            parentId: libraryController.selectedFolder.value?.id,
            metadata: {
              'description': descriptionController.text,
              'notes': deltaToMarkdown.convert(noteController.document.toDelta()),
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
            parentId: libraryController.selectedFolder.value?.id,
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
            parentId: libraryController.selectedFolder.value?.id,
            metadata: {
              'description': descriptionController.text,
              'cards': flashcards.map((flashcard) => flashcard.toJson()).toList(),
              'cardCount': flashcards.length,
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
            parentId: libraryController.selectedFolder.value?.id,
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
            parentId: libraryController.selectedFolder.value?.id,
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
            parentId: libraryController.selectedFolder.value?.id,
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
        libraryController.fetchLibraryItemByType();
        libraryController.refreshByFolder();
        libraryController.fetchLibraryItemWithPath();

        // Show Success Dialog
        Get.dialog(
          SuccessDialog(
            message: '${itemResponse.name} ${itemResponse.type.name} has been created. Do you want to open it?',
            onConfirm: () => libraryController.navigateToItem(itemResponse, isReplace: true),
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

    libraryController.fetchLibraryItemByType();
    libraryController.refreshByFolder();
    libraryController.fetchLibraryItemWithPath();
  }

  void updateLibraryItem(String uid, {String? name, bool? isEmbedded}) {
    Get.back();
    updateLoader(true);

    final UpdateLibraryItem updateLibraryItemData = UpdateLibraryItem(uid: uid, name: name, isEmbedded: isEmbedded);

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

    final UpdateBulkLibraryItem updateBulkLibraryItemData = UpdateBulkLibraryItem(
      uid: selectedItems.map((e) => e.uid).toList(),
      parentId: libraryController.selectedFolder.value?.id,
      action: action,
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
