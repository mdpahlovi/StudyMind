import 'package:studymind/controllers/chat.dart';
import 'package:studymind/services/api.dart';

class ChatService {
  final ApiService apiService = ApiService();

  Future<ApiResponse> getChatSessions({String search = '', bool isActive = true}) async {
    return await apiService.get('/chat', queryParameters: {'search': search, 'isActive': isActive});
  }

  Future<ApiResponse> getOneChatSession({required String uid}) async {
    return await apiService.get('/chat/$uid');
  }

  Future<ApiResponse> requestQuery({required String uid, required String? summary, required List<ChatMessage> message}) async {
    return await apiService.patch('/chat/$uid', data: {'summary': summary ?? "", 'message': message.map((m) => m.toJson()).toList()});
  }

  Future<ApiResponse> updateChatSession({required String uid, required String title}) async {
    return await apiService.patch('/chat/update/$uid', data: {'title': title});
  }

  Future<ApiResponse> updateBulkChatSession({required List<String> uid, bool? isActive}) async {
    return await apiService.patch('/chat/update/bulk', data: {'uid': uid, 'isActive': isActive});
  }

  Future<ApiResponse> deleteBulkChatSession({required List<String> uid}) async {
    return await apiService.delete('/chat/bulk', data: {'uid': uid});
  }
}
