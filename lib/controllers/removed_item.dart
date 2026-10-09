import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/models/library.dart';
import 'package:studymind/services/library.dart';

class RemovedItemController extends GetxController {
  final LibraryService libraryService = LibraryService();

  final RxBool isLoading = true.obs;
  final RxList<LibraryItem> removedItems = <LibraryItem>[].obs;
  final RxList<LibraryItem> selectedItems = <LibraryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRemovedItems();
  }

  @override
  void onClose() {
    super.onClose();
    removedItems.clear();
    selectedItems.clear();
  }

  void fetchRemovedItems({int page = 1, int limit = 50}) {
    isLoading.value = true;

    final query = GetLibraryItemsQuery(page: page, limit: limit, isActive: false);

    libraryService.getLibraryItems(query).then((response) {
      if (response.success && response.data != null) {
        removedItems.value = LibraryResponse.fromJson(response.data).libraryItems;
      } else {
        Notification.error(response.message);
      }

      selectedItems.clear();
      isLoading.value = false;
    });
  }

  void toggleSelection(LibraryItem item) {
    selectedItems.contains(item) ? selectedItems.remove(item) : selectedItems.add(item);
  }

  void selectAll() {
    selectedItems.length == removedItems.length ? selectedItems.clear() : selectedItems.assignAll(removedItems);
  }

  void restoreSelected() {
    if (selectedItems.isEmpty) return;

    final uid = selectedItems.map((item) => item.uid).toList();

    libraryService.updateBulkLibraryItem(UpdateBulkLibraryItem(uid: uid, parentId: null, action: 'RESTORE')).then((response) {
      if (response.success) {
        Notification.success('${uid.length} item(s) restored');
        refreshLibrary();
        fetchRemovedItems();
      } else {
        Notification.error(response.message);
      }
    });
  }

  void deleteSelected() {
    if (selectedItems.isEmpty) return;

    final uid = selectedItems.map((item) => item.uid).toList();

    libraryService.deleteBulkLibraryItem(DeleteBulkLibraryItem(uid: uid)).then((response) {
      if (response.success) {
        Notification.success('${uid.length} item(s) deleted permanently');
        fetchRemovedItems();
      } else {
        Notification.error(response.message);
      }
    });
  }

  void refreshLibrary() {
    final LibraryController libraryController = Get.find<LibraryController>();

    libraryController.fetchLibraryItemByFolder();
    libraryController.fetchLibraryItemByType();
    libraryController.fetchLibraryItemWithPath();
  }
}
