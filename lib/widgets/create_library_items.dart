import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CreateLibraryItems extends StatefulWidget {
  const CreateLibraryItems({super.key});

  @override
  State<CreateLibraryItems> createState() => CreateLibraryItemsState();
}

class CreateLibraryItemsState extends State<CreateLibraryItems> {
  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final EdgeInsets paddings = MediaQuery.of(context).padding;

    return Container(
      decoration: BoxDecoration(
        color: colorPalette.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fixed header
          Padding(padding: const EdgeInsets.all(16), child: Text("Create New", style: textTheme.headlineMedium)),
          Divider(),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: paddings.bottom),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  CreateOption(onTap: () {}, title: "New Folder", icon: "folder", color: Color(0xFFA8C686)),
                  const SizedBox(height: 12),
                  CreateOption(
                    onTap: () => Get.toNamed(AppRoutes.note),
                    title: "New Note",
                    icon: "noteEdit",
                    color: Color(0xFF7D9B5F),
                  ),
                  const SizedBox(height: 12),
                  CreateOption(
                    onTap: () => Get.toNamed(AppRoutes.document),
                    title: "Scan Document",
                    icon: "documentScanner",
                    color: Color(0xFFF5F5DC),
                  ),
                  const SizedBox(height: 12),
                  CreateOption(
                    onTap: () => Get.toNamed(AppRoutes.flashcard),
                    title: "Create Flashcard",
                    icon: "flashcard",
                    color: Color(0xFF8FBC8F),
                  ),
                  const SizedBox(height: 12),
                  CreateOption(
                    onTap: () => Get.toNamed(AppRoutes.media),
                    title: "Upload Media",
                    icon: "upload",
                    color: Color(0xFFE6C79C),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateOption extends StatelessWidget {
  const CreateOption({super.key, this.onTap, required this.title, required this.icon, required this.color});

  final void Function()? onTap;
  final String title;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withAlpha(50), borderRadius: BorderRadius.circular(8)),
                child: CustomIcon(icon: icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Text(title, style: textTheme.titleMedium),
              const Spacer(),
              CustomIcon(icon: 'arrowRight', color: colorPalette.content, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
