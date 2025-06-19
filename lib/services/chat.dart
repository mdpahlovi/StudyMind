import 'package:studymind/controllers/chat.dart';
import 'package:studymind/services/api.dart';

class ChatService {
  final ApiService apiService = ApiService();

  Future<ApiResponse> getChatSessions({String search = ''}) async {
    return await apiService.get('/chat', queryParameters: {'search': search});
  }

  Future<ApiResponse> getOneChatSession({required String uid}) async {
    return await apiService.get('/chat/$uid');
  }

  Future<ApiResponse> requestQuery({required String uid, required List<ChatMessage> message}) async {
    return await apiService.patch('/chat/$uid', data: {'message': message.map((m) => m.toJson()).toList()});
  }
}
