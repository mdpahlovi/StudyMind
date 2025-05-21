import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/presentation/home/widgets/recent_activity_card.dart';
import 'package:studymind/presentation/home/widgets/stat_item.dart';
import 'package:studymind/theme/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<Map<String, dynamic>> recentActivities = [
      {
        'id': 1,
        "title": "Biology Notes: Cell Structure",
        "type": "note",
        "icon": "note",
        'color': colorPalette.primary,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'progress': 0.75,
        "imageUrl": "https://images.unsplash.com/photo-1530026186672-2cd00ffc50fe?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
        "route": "/notes",
      },
      {
        'id': 2,
        "title": "Physics Textbook Chapter 4",
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
        "icon": "flashCard",
        'color': colorPalette.warning,
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'progress': 0.6,
        "imageUrl": "https://images.pixabay.com/photo/2016/01/19/01/42/library-1147815_1280.jpg?auto=compress&cs=tinysrgb&w=800",
        "route": "/flashcard",
      },
      {
        'id': 4,
        "title": "Chemistry Practice Questions",
        "type": "flashcard",
        "icon": "flashCard",
        'color': colorPalette.warning,
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'progress': 0.3,
        "imageUrl": "https://images.unsplash.com/photo-1532094349884-543bc11b234d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
        "route": "/flashcard",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyMind'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent Activity
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Activity', style: textTheme.headlineMedium),
                    TextButton(
                      onPressed: () {
                        // Navigate to view all recent activities
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Recent Activity Cards
              ListView.builder(
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
              ),

              const SizedBox(height: 16),

              // Study Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Study Stats', style: textTheme.titleLarge),
                            TextButton(
                              onPressed: () {
                                // Navigate to detailed stats
                              },
                              child: const Text('Details'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatItem(value: '4.5', label: 'Hours', subLabel: 'Today', color: colorPalette.primary),
                            StatItem(value: '12', label: 'Notes', subLabel: 'Created', color: colorPalette.info),
                            StatItem(value: '85%', label: 'Flashcards', subLabel: 'Mastered', color: colorPalette.warning),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
