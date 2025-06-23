import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_badge.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentCard extends StatelessWidget {
  final LibraryItem item;
  const RecentCard({super.key, required this.item});

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
          padding: const EdgeInsets.only(left: 12, right: 8, top: 8, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 4),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withAlpha(100), width: 1),
                ),
                child: CustomIcon(icon: icon, color: color, size: 24),
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
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Icon(HugeIcons.strokeRoundedArrowRight01, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        item.name,
                        style: textTheme.titleMedium?.copyWith(height: 1.25),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedClock01,
                          size: 14,
                          color: colorPalette.contentDim.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeago.format(item.updatedAt),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorPalette.contentDim.withValues(alpha: 0.7),
                            height: 1.25,
                          ),
                        ),
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
