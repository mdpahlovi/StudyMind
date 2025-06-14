import 'package:get/get.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/services/chat.dart';

class ChatSession {
  final int id;
  final String uid;
  final bool isActive;
  final int userId;
  final String title;
  final String? describe;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.uid,
    required this.isActive,
    required this.userId,
    required this.title,
    this.describe,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      uid: json['uid'],
      isActive: json['isActive'] ?? true,
      userId: json['userId'],
      title: json['title'],
      describe: json['describe'],
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'] != null ? DateTime.parse(json['lastMessageAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'isActive': isActive,
      'userId': userId,
      'title': title,
      'describe': describe,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ChatSessionResponse {
  final List<ChatSession> sessions;
  final int total;

  ChatSessionResponse({required this.sessions, required this.total});

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) {
    return ChatSessionResponse(
      sessions: List<ChatSession>.from(json['sessions'].map((x) => ChatSession.fromJson(x))),
      total: json['total'] ?? 0,
    );
  }
}

enum ChatMessageRole {
  user('USER'),
  assistant('ASSISTANT');

  const ChatMessageRole(this.value);
  final String value;

  static ChatMessageRole fromString(String value) {
    return ChatMessageRole.values.firstWhere((role) => role.value == value, orElse: () => ChatMessageRole.user);
  }
}

class ChatMessage {
  final int id;
  final String uid;
  final ChatMessageRole role;
  final int chatSessionId;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    required this.uid,
    required this.role,
    required this.chatSessionId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      uid: json['uid'],
      role: ChatMessageRole.fromString(json['role']),
      chatSessionId: json['chatSessionId'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'role': role.value,
      'chatSessionId': chatSessionId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ChatSessionWithMessage {
  final ChatSession session;
  final List<ChatMessage> messages;

  ChatSessionWithMessage({required this.session, required this.messages});

  factory ChatSessionWithMessage.fromJson(Map<String, dynamic> json) {
    return ChatSessionWithMessage(
      session: ChatSession.fromJson(json['session']),
      messages: List<ChatMessage>.from(json['messages'].map((x) => ChatMessage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {'session': session.toJson(), 'messages': messages.map((x) => x.toJson()).toList()};
  }
}

class ChatController extends GetxController {
  final ChatService chatService = ChatService();

  final RxBool isLoadingSessions = false.obs;
  final RxBool isLoadingMessages = false.obs;
  final RxList<ChatSession> chatSessions = <ChatSession>[].obs;
  final RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  final Rxn<ChatSession> selectedSession = Rxn<ChatSession>();

  @override
  void onInit() {
    super.onInit();
    fetchChatSessions();
  }

  Future<void> fetchChatSessions({String search = ''}) async {
    isLoadingSessions.value = true;

    chatService.getChatSessions(search: search).then((response) {
      if (response.success && response.data != null) {
        final sessionResponse = ChatSessionResponse.fromJson(response.data);
        chatSessions.value = sessionResponse.sessions;
      } else {
        Notification.error(response.message);
      }

      isLoadingSessions.value = false;
    });
  }

  Future<void> fetchOneChatSession({required String uid}) async {
    isLoadingMessages.value = true;

    chatService.getOneChatSession(uid: uid).then((response) {
      if (response.success && response.data != null) {
        final sessionResponse = ChatSessionWithMessage.fromJson(response.data);
        chatMessages.value = sessionResponse.messages;
        selectedSession.value = sessionResponse.session;
      } else {
        Notification.error(response.message);
      }

      isLoadingMessages.value = false;
    });
  }
}
