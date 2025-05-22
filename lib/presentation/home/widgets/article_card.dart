import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_badge.dart';
import 'package:studymind/widgets/custom_image.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.title, required this.type, required this.imageUrl});

  final String title;
  final String type;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 256,
      child: Card(
        child: InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 120, width: double.infinity, child: CustomImage(imageUrl: imageUrl, fit: BoxFit.cover)),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBadge(label: type, color: colorPalette.primary),
                    const SizedBox(height: 6),
                    Text(title, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
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
