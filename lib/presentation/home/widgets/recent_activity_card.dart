import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_badge.dart' show CustomBadge;
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/custom_image.dart';

class RecentActivityCard extends StatelessWidget {
  final String title;
  final String type;
  final String icon;
  final Color color;
  final DateTime timestamp;
  final double progress;
  final String imageUrl;
  final VoidCallback onTap;

  const RecentActivityCard({
    super.key,
    required this.title,
    required this.type,
    required this.icon,
    required this.color,
    required this.timestamp,
    required this.progress,
    required this.imageUrl,
    required this.onTap,
  });

  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat.EEEE().format(date)}, ${DateFormat.jm().format(date)}';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(width: 64, height: 64, child: CustomImage(imageUrl: imageUrl)),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomBadge(label: type.capitalize!, icon: icon, color: color),
                        CustomIcon(icon: 'arrowRight', color: colorPalette.content, size: 16),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Title
                    Text(title, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),

                    const SizedBox(height: 2),

                    // Timestamp
                    Text(getFormattedDate(timestamp), style: textTheme.bodySmall),

                    const SizedBox(height: 2),

                    // Progress Bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: colorPalette.border,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${(progress * 100).toInt()}%', style: textTheme.labelSmall?.copyWith(color: colorPalette.content)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
