import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_badge.dart';
import 'package:studymind/widgets/custom_icon.dart';

class RecentCard extends StatelessWidget {
  final LibraryItem item;

  const RecentCard({super.key, required this.item});

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
    final LibraryController libraryController = Get.find<LibraryController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color color = item.metadata?['color'] != null
        ? Color(int.parse(item.metadata!['color']!.replaceFirst('#', '0xFF')))
        : ItemTypeStyle.getStyle(item.type).color;
    final String icon = item.metadata?['icon'] ?? ItemTypeStyle.getStyle(item.type).icon;

    return Card(
      child: InkWell(
        onTap: () => libraryController.navigateToItem(item),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                decoration: BoxDecoration(
                  color: colorPalette.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(width: 62, height: 62, child: CustomIcon(icon: icon, size: 36)),
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
                        CustomBadge(label: item.type.name, color: color),
                        CustomIcon(icon: 'arrowRight', color: colorPalette.content, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(item.name, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(getFormattedDate(item.createdAt), style: textTheme.bodySmall),
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
