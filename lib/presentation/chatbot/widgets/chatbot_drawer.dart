import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ChatbotDrawer extends StatelessWidget {
  const ChatbotDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<String> chatHistory = [
      'Math homework help',
      'Physics equations',
      'Chemistry formulas',
      'Biology concepts',
      'History timeline',
      'Literature analysis',
      'Programming basics',
    ];

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorPalette.primary, colorPalette.secondary],
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.smart_toy_rounded, color: colorPalette.primary, size: 28),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chat History', style: textTheme.titleLarge),
                      Text('Your conversations', style: textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorPalette.primary.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIcon(icon: 'message', color: colorPalette.primary),
                    ),
                    title: Text(
                      chatHistory[index],
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('${index + 1} hour${index == 0 ? '' : 's'} ago', style: textTheme.bodySmall),
                    onTap: () {
                      Navigator.pop(context);
                      // Handle chat history item tap
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: colorPalette.border))),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Handle "New Chat" button tap
                  },
                  icon: CustomIcon(icon: 'add', color: colorPalette.primary),
                  label: Text('New Chat', style: textTheme.titleMedium?.copyWith(color: colorPalette.primary)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorPalette.primary,
                    side: BorderSide(color: colorPalette.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
