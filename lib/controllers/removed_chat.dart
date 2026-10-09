import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/services/chat.dart';

class RemovedChatController extends GetxController {
  final ChatService chatService = ChatService();

  final RxBool isLoading = true.obs;
  final RxList<ChatSession> removedSessions = <ChatSession>[].obs;
  final RxList<ChatSession> selectedSessions = <ChatSession>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRemovedSessions();
  }

  @override
  void onClose() {
    super.onClose();
    removedSessions.clear();
    selectedSessions.clear();
  }

  void fetchRemovedSessions() {
    isLoading.value = true;

    chatService.getChatSessions(isActive: false).then((response) {
      if (response.success && response.data != null) {
        removedSessions.value = ChatSessionResponse.fromJson(response.data).sessions;
      } else {
        Notification.error(response.message);
      }

      selectedSessions.clear();
      isLoading.value = false;
    });
  }

  void toggleSelection(ChatSession session) {
    selectedSessions.contains(session) ? selectedSessions.remove(session) : selectedSessions.add(session);
  }

  void selectAll() {
    selectedSessions.length == removedSessions.length ? selectedSessions.clear() : selectedSessions.assignAll(removedSessions);
  }

  void restoreSelected() {
    if (selectedSessions.isEmpty) return;

    final uid = selectedSessions.map((session) => session.uid).toList();

    chatService.updateBulkChatSession(uid: uid, isActive: true).then((response) {
      if (response.success) {
        Notification.success('${uid.length} chat(s) restored');
        Get.find<ChatController>().fetchChatSessions();
        fetchRemovedSessions();
      } else {
        Notification.error(response.message);
      }
    });
  }

  void deleteSelected() {
    if (selectedSessions.isEmpty) return;

    final uid = selectedSessions.map((session) => session.uid).toList();

    chatService.deleteBulkChatSession(uid: uid).then((response) {
      if (response.success) {
        Notification.success('${uid.length} chat(s) deleted permanently');
        fetchRemovedSessions();
      } else {
        Notification.error(response.message);
      }
    });
  }
}
