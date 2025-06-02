import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ItemCreateSheet extends StatefulWidget {
  const ItemCreateSheet({super.key});

  @override
  State<ItemCreateSheet> createState() => ItemCreateSheetState();
}

class ItemCreateSheetState extends State<ItemCreateSheet> {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text("Create New", style: textTheme.headlineMedium),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: CustomIcon(icon: 'cancel', color: colorPalette.content, size: 24),
                ),
              ],
            ),
          ),
          Divider(),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: paddings.bottom),
              child: Column(
                children:
                    ItemTypeStyle.options
                        .map<List<Widget>>((option) => [const SizedBox(height: 12), CreateOption(option: option)])
                        .expand((widget) => widget)
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateOption extends StatelessWidget {
  final TypeOption option;

  const CreateOption({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        itemCreateController.setSelectedFolder(Get.parameters['uid']);
        Get.offNamed(AppRoutes.itemCreate.replaceFirst(':type', option.title.toLowerCase()));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: option.color.withAlpha(50), borderRadius: BorderRadius.circular(8)),
                child: CustomIcon(icon: option.icon, color: option.color, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.title, style: textTheme.titleMedium),
                  Text(option.description, style: textTheme.bodySmall),
                ],
              ),
              const Spacer(),
              CustomIcon(icon: 'arrowRight', color: colorPalette.content, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
