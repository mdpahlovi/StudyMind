import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/controllers/main.dart';
import 'package:studymind/presentation/home/widgets/recent_card.dart';
import 'package:studymind/presentation/home/widgets/recent_loader.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/chatbot/session_card.dart';
import 'package:studymind/widgets/custom_image.dart';
import 'package:studymind/widgets/notification_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find<MainController>();
    final AuthController authController = Get.find<AuthController>();
    final LibraryController libraryController = Get.find<LibraryController>();
    final ChatController chatController = Get.find<ChatController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final EdgeInsets paddings = MediaQuery.of(context).padding;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          libraryController.fetchLibraryItemByType();
          libraryController.fetchLibraryItemByFolder();
          libraryController.fetchLibraryItemWithPath();
          chatController.fetchChatSessions();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Padding(
                padding: EdgeInsets.only(top: paddings.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final imageUrl = authController.user.value?.photo ?? "";

                      return Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: colorPalette.content),
                          ),
                          child: ClipOval(child: CustomImage(imageUrl: imageUrl, isUser: true)),
                        ),
                      );
                    }),
                    const SizedBox(width: 12),
                    Obx(() {
                      final name = authController.user.value?.name ?? "";
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hi, $name', style: textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                            Text('Welcome to StudyMind', style: textTheme.bodySmall),
                          ],
                        ),
                      );
                    }),
                    NotificationButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Ask AI Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorPalette.primary, colorPalette.secondary, colorPalette.tertiary],
                    stops: [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => chatController.navigateToNewChat(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: colorPalette.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(color: colorPalette.black.withAlpha(25), blurRadius: 20, offset: Offset(0, 10)),
                          ],
                        ),
                        child: const Icon(HugeIcons.strokeRoundedAiBrain02, size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text('Ask AI Assistant', style: textTheme.headlineMedium, textAlign: TextAlign.center),
                      Text(
                        'Get instant help with your studies',
                        style: textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, size: 14),
                          const SizedBox(width: 2),
                          Text('Powered by OpenAI', style: textTheme.labelMedium),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Recent Items
              const SizedBox(height: 16),
              Obx(() {
                final recentItems = libraryController.libraryItems.take(4).toList();
                if (libraryController.isLoadingType.value || recentItems.isNotEmpty) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Items', style: textTheme.headlineMedium),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.itemByType),
                            child: Text(
                              'View All',
                              style: textTheme.labelMedium?.copyWith(color: colorPalette.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentItems.isEmpty ? 4 : recentItems.length,
                        itemBuilder: (context, index) {
                          final item = recentItems.isEmpty ? null : recentItems[index];
                          if (item == null) {
                            return const RecentLoader(height: 90);
                          } else {
                            return RecentCard(item: item);
                          }
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
              // Recent Chats
              Obx(() {
                final sessions = chatController.chatSessions.take(4).toList();
                if (chatController.isLoadingSession.value || sessions.isNotEmpty) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Chats', style: textTheme.headlineMedium),
                          GestureDetector(
                            onTap: () => mainController.onDestinationSelected(2),
                            child: Text(
                              'View All',
                              style: textTheme.labelMedium?.copyWith(color: colorPalette.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sessions.isEmpty ? 4 : sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions.isEmpty ? null : sessions[index];
                          if (session == null) {
                            return const RecentLoader();
                          } else {
                            return SessionCard(session: session);
                          }
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
