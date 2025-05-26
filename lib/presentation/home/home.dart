import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/presentation/home/widgets/action_button.dart';
import 'package:studymind/presentation/home/widgets/article_card.dart';
import 'package:studymind/presentation/home/widgets/recent_activity_card.dart';
import 'package:studymind/presentation/home/widgets/stat_item.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<Map<String, dynamic>> actionButtons = [
      {"title": "Notes", "icon": "note", 'color': colorPalette.primary, "route": "/note"},
      {"title": "Documents", "icon": "document", 'color': colorPalette.info, "route": "/document"},
      {"title": "Flashcards", "icon": "flashcard", 'color': colorPalette.warning, "route": "/flashcard"},
      {"title": "Medias", "icon": "media", 'color': colorPalette.secondary, "route": "/media"},
    ];

    final List<Map<String, dynamic>> recentActivities = [
      {
        'id': 1,
        "title": "Biology Notes: Cell Structure",
        "type": "note",
        "icon": "note",
        'color': colorPalette.primary,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'progress': 0.75,
        "imageUrl":
            "https://images.unsplash.com/photo-1530026186672-2cd00ffc50fe?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
        "route": "/note",
      },
      {
        'id': 2,
        "title": "Physics Textbook Chapter 4 - Forces and Motion",
        "type": "document",
        "icon": "document",
        'color': colorPalette.info,
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'progress': 0.4,
        "imageUrl": "https://images.pexels.com/photos/2251/light-sea-city-dark.jpg?auto=compress&cs=tinysrgb&w=800",
        "route": "/document",
      },
      {
        'id': 3,
        "title": "Spanish Vocabulary Flashcards",
        "type": "flashcard",
        "icon": "flashcard",
        'color': colorPalette.warning,
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'progress': 0.6,
        "imageUrl":
            "https://images.pixabay.com/photo/2016/01/19/01/42/library-1147815_1280.jpg?auto=compress&cs=tinysrgb&w=800",
        "route": "/flashcard",
      },
      {
        'id': 4,
        "title": "Chemistry Practice Questions",
        "type": "flashcard",
        "icon": "flashcard",
        'color': colorPalette.warning,
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'progress': 0.3,
        "imageUrl":
            "https://images.unsplash.com/photo-1532094349884-543bc11b234d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
        "route": "/flashcard",
      },
    ];
    final List<Map<String, dynamic>> suggestedContent = [
      {
        "title": "How to Take Effective Notes",
        "type": "Article",
        "imageUrl":
            "https://images.unsplash.com/photo-1501504905252-473c47e087f8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
      },
      {
        "title": "Memory Techniques for Exams",
        "type": "Video",
        "imageUrl":
            "https://images.pexels.com/photos/3059748/pexels-photo-3059748.jpeg?auto=compress&cs=tinysrgb&w=800",
      },
      {
        "title": "Study Planner Template",
        "type": "Template",
        "imageUrl":
            "https://images.pixabay.com/photo/2015/07/19/10/00/school-items-851328_1280.jpg?auto=compress&cs=tinysrgb&w=800",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyMind'),
        actions: [
          IconButton(onPressed: () {}, icon: const CustomIcon(icon: 'notification')),
          IconButton(onPressed: () {}, icon: const CustomIcon(icon: 'profile')),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
                          onTap: () => Get.toNamed(button['route']),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Recent Activity
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Activity', style: textTheme.headlineMedium),
                    Text('View All', style: textTheme.labelMedium?.copyWith(color: colorPalette.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recentActivities.length > 4 ? 4 : recentActivities.length,
                itemBuilder: (context, index) {
                  final activity = recentActivities[index];
                  return RecentActivityCard(
                    title: activity['title'],
                    type: activity['type'],
                    icon: activity['icon'],
                    color: activity['color'],
                    timestamp: activity['timestamp'],
                    progress: activity['progress'],
                    imageUrl: activity['imageUrl'],
                    onTap: () => Get.toNamed(activity['route']),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 12),
              ),
              const SizedBox(height: 16),

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
