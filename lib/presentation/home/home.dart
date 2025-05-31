import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/home/widgets/action_button.dart';
import 'package:studymind/presentation/home/widgets/article_card.dart';
import 'package:studymind/presentation/home/widgets/recent_card.dart';
import 'package:studymind/presentation/home/widgets/recent_loader.dart';
import 'package:studymind/presentation/home/widgets/stat_item.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/notification_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    TypeStyle getStyle(ItemType type) => ItemTypeStyle.getStyle(type);

    final List<Map<String, dynamic>> actionButtons = [
      {'title': "Notes", 'icon': "note", 'color': getStyle(ItemType.note).color, 'type': 'note'},
      {'title': "Documents", 'icon': "document", 'color': getStyle(ItemType.document).color, 'type': 'document'},
      {'title': "Flashcards", 'icon': "flashcard", 'color': getStyle(ItemType.flashcard).color, 'type': 'flashcard'},
      {'title': "Medias", 'icon': "media", 'color': getStyle(ItemType.audio).color, 'type': 'media'},
    ];

    final List<Map<String, dynamic>> suggestedContent = [
      {
        "title": "How to Take Effective Notes",
        "type": "Article",
        "imageUrl": "https://images.unsplash.com/photo-1501504905252-473c47e087f8",
      },
      {
        "title": "Memory Techniques for Exams",
        "type": "Video",
        "imageUrl": "https://images.pexels.com/photos/3059748/pexels-photo-3059748.jpeg",
      },
      {
        "title": "Study Planner Template",
        "type": "Template",
        "imageUrl": "https://images.template.net/161790/study-planner-template-yg6ec.png",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('StudyMind'), actions: [NotificationButton()]),
      body: RefreshIndicator(
        onRefresh: () async => libraryController.fetchLibraryItemsByRecent(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Quick Actions', style: textTheme.headlineMedium),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      actionButtons.map((button) {
                        return ActionButton(
                          title: button['title'],
                          icon: button['icon'],
                          color: button['color'],
                          onTap: () => libraryController.navigateToItemByType(button['type']),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Recent Activity
              Obx(() {
                final List<LibraryItem> recentItems = libraryController.recentItems;

                if (libraryController.isLoadingRecent.value || recentItems.isNotEmpty) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recent Activity', style: textTheme.headlineMedium),
                            GestureDetector(
                              onTap: () => libraryController.navigateToItemByType(''),
                              child: Text(
                                'View All',
                                style: textTheme.labelMedium?.copyWith(color: colorPalette.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: recentItems.isEmpty ? 6 : recentItems.length,
                        itemBuilder: (context, index) {
                          final item = recentItems.isEmpty ? null : recentItems[index];
                          if (item == null) {
                            return const RecentLoader();
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

              // Study Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Study Stats', style: textTheme.headlineMedium),
                    Text('Details', style: textTheme.labelMedium?.copyWith(color: colorPalette.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatItem(value: '4.5+', label: 'Hours', subLabel: 'Today', color: colorPalette.primary),
                      ),
                      Expanded(
                        child: StatItem(value: '12+', label: 'Notes', subLabel: 'Created', color: colorPalette.info),
                      ),
                      Expanded(
                        child: StatItem(
                          value: '85%',
                          label: 'Flashcards',
                          subLabel: 'Mastered',
                          color: colorPalette.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Suggested Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Suggested For You', style: textTheme.headlineMedium),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 194,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: suggestedContent.length,
                  itemBuilder: (context, index) {
                    final content = suggestedContent[index];
                    return ArticleCard(title: content['title'], type: content['type'], imageUrl: content['imageUrl']);
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
