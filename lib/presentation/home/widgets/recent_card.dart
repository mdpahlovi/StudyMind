import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_type_style.dart';
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
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TypeStyle typeStyle = ItemTypeStyle(type: item.type).decoration;

    return Card(
      child: InkWell(
        // onTap: () => Get.toNamed(AppRoutes.library.replaceFirst(':uid', item.uid)),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(width: 70, height: 70, child: CustomIcon(icon: typeStyle.icon, size: 40)),
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
                        CustomBadge(label: item.type.name.capitalize!, icon: typeStyle.icon, color: typeStyle.color),
                        CustomIcon(icon: 'arrowRight', color: colorPalette.content, size: 20),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Title
                    Text(item.name, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    // Timestamp
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
