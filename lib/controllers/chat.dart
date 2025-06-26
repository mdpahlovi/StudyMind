import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/core/utils.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/services/chat.dart';
import 'package:studymind/services/library.dart';
import 'package:uuid/uuid.dart';

class ChatContent {
  final String uid;
  final bool isEmbedded;
  final String name;
  final ItemType type;
  final String path;

  ChatContent({
    required this.uid,
    required this.isEmbedded,
    required this.name,
    required this.type,
    required this.path,
  });

  factory ChatContent.fromJson(Map<String, dynamic> json) {
    return ChatContent(
      uid: json['uid'],
      isEmbedded: ['DOCUMENT', 'AUDIO', 'VIDEO'].contains(json['type']) ? json['is_embedded'] : true,
      name: json['name'],
      type: ItemType.values.byName(json['type'].toLowerCase()),
      path: json['path'],
    );
  }
}

class ChatSession {
  final int id;
  final String uid;
  final bool isActive;
  final int userId;
  final String title;
  final String? description;
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
    this.description,
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
      description: json['description'],
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'] != null ? DateTime.parse(json['lastMessageAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
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
  final String uid;
  final ChatMessageRole role;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.uid,
    required this.role,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      uid: json['uid'],
      role: ChatMessageRole.fromString(json['role']),
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role.value,
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
}

class ChatController extends GetxController {
  final LibraryService libraryService = LibraryService();
  final ChatService chatService = ChatService();

  final RxBool isLoadingContext = false.obs;
  final RxBool isLoadingSession = false.obs;
  final RxBool isLoadingMessage = false.obs;
  final RxBool isGenAiTyping = false.obs;
  final RxList<ChatContent> chatContents = <ChatContent>[].obs;
  final RxList<ChatSession> chatSessions = <ChatSession>[].obs;
  final RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  final Rxn<ChatSession> selectedSession = Rxn<ChatSession>();

  final RxList<ChatSession> selectedSessions = <ChatSession>[].obs; // To handle select session functionality

  final QuillController messageController = QuillController.basic();

  @override
  void onInit() {
    super.onInit();
    fetchChatContents();
    fetchChatSessions();
  }

  @override
  void onClose() {
    super.onClose();
    isLoadingContext.value = false;
    isLoadingSession.value = false;
    isLoadingMessage.value = false;
    isGenAiTyping.value = false;
    chatContents.clear();
    chatSessions.clear();
    chatMessages.clear();
    selectedSession.value = null;
    selectedSessions.clear();
    messageController.clear();
  }

  Future<void> fetchChatContents() async {
    isLoadingContext.value = true;

    libraryService.getLibraryItemsWithPath(type: '').then((response) {
      if (response.success && response.data != null) {
        final List<ChatContent> contextResponse = List<ChatContent>.from(
          response.data.map((x) => ChatContent.fromJson(x)),
        );
        chatContents.value = contextResponse;
      } else {
        Notification.error(response.message);
      }

      isLoadingContext.value = false;
    });
  }

  Future<void> fetchChatSessions({String search = ''}) async {
    isLoadingSession.value = true;

    chatService.getChatSessions(search: search).then((response) {
      if (response.success && response.data != null) {
        final sessionResponse = ChatSessionResponse.fromJson(response.data);
        chatSessions.value = sessionResponse.sessions;
      } else {
        Notification.error(response.message);
      }

      isLoadingSession.value = false;
    });
  }

  Future<void> fetchOneChatSession({required String uid}) async {
    isLoadingMessage.value = true;

    chatService.getOneChatSession(uid: uid).then((response) {
      if (response.success && response.data != null) {
        final sessionResponse = ChatSessionWithMessage.fromJson(response.data);
        chatMessages.value = sessionResponse.messages;
      } else {
        Notification.error(response.message);
      }

      isLoadingMessage.value = false;
    });
  }

  void navigateToNewChat({bool isReplace = false}) {
    final page = AppRoutes.chatSession.replaceFirst(':uid', Uuid().v4());
    !isReplace ? Get.toNamed(page) : Get.offNamed(page);

    selectedSession.value = null;
    chatMessages.clear();
  }

  void navigateToSession(ChatSession session, {bool isReplace = false}) async {
    final page = AppRoutes.chatSession.replaceFirst(':uid', session.uid);
    !isReplace ? Get.toNamed(page) : Get.offNamed(page);

    selectedSession.value = session;
    fetchOneChatSession(uid: session.uid);
  }

  void navigateToBack() async {
    Get.back();

    selectedSession.value = null;
    chatMessages.clear();
  }

  Future<void> requestQuery() async {
    isGenAiTyping.value = true;
    final session = Get.parameters['uid'];

    if (session == null) {
      Notification.error('Please select a chat session');
      return;
    }

    if (chatMessages.isEmpty) {
      Notification.error('Please send a message first');
      return;
    }

    final response = await chatService.requestQuery(uid: session, message: chatMessages);
    if (response.success && response.data != null) {
      final session = ChatSession.fromJson(response.data['session']);
      final message = ChatMessage.fromJson(response.data['message']);

      if (selectedSession.value != null) chatSessions.remove(selectedSession.value);
      selectedSession.value = session;
      chatSessions.insert(0, session);
      chatMessages.add(message);
    } else {
      final message = chatMessages.last;
      messageController.document = Document.fromDelta(markdownTODelta.convert(message.message));
      messageController.moveCursorToEnd();
      chatMessages.remove(message);

      Notification.error(response.message);
    }

    isGenAiTyping.value = false;
  }

  Future<void> updateChatSession({required String uid, required String title}) async {
    isLoadingSession.value = true;
    final response = await chatService.updateChatSession(uid: uid, title: title);
    if (response.success && response.data != null) {
      fetchChatSessions();
    } else {
      Notification.error(response.message);
    }
    isLoadingSession.value = false;
  }

  Future<void> updateBulkChatSession({required List<String> uid, bool? isActive}) async {
    isLoadingSession.value = true;
    final response = await chatService.updateBulkChatSession(uid: uid, isActive: isActive);
    if (response.success && response.data != null) {
      fetchChatSessions();
    } else {
      Notification.error(response.message);
    }
    isLoadingSession.value = false;
  }
}
