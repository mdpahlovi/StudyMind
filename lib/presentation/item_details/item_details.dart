import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/core/utils.dart';
import 'package:studymind/presentation/item_details/widgets/view_audio.dart';
import 'package:studymind/presentation/item_details/widgets/view_document.dart';
import 'package:studymind/presentation/item_details/widgets/view_flashcard.dart';
import 'package:studymind/presentation/item_details/widgets/view_image.dart';
import 'package:studymind/presentation/item_details/widgets/view_note.dart';
import 'package:studymind/presentation/item_details/widgets/view_video.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_back_button.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;
    final EdgeInsets paddings = MediaQuery.of(context).padding;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        libraryController.backFromDetail();
      },
      child: RefreshIndicator(
        onRefresh: () async => libraryController.refreshItemDetails(),
        child: Scaffold(
          appBar: AppBar(
            leading: CustomBackButton(icon: 'cancel', onPressed: libraryController.backFromDetail),
            title: Obx(() {
              final breadcrumbs = libraryController.breadcrumbs;
              return breadcrumbs.isEmpty ? const Text('') : Text(breadcrumbs.last.name);
            }),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Obx(() {
                final LibraryItem? item = libraryController.libraryItem.value;

                if (libraryController.isLoadingItem.value) {
                  return SizedBox(
                    width: size.width - paddings.left - paddings.right,
                    height: size.height - paddings.top - paddings.bottom - 56,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (item == null) {
                  return SizedBox(
                    width: size.width - paddings.left - paddings.right,
                    height: size.height - paddings.top - paddings.bottom - 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(HugeIcons.strokeRoundedAlert01, size: 64, color: colorPalette.error),
                        const SizedBox(height: 16),
                        Text('Something went wrong', style: textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text('Item not found! Please try again later.', style: textTheme.bodySmall),
                      ],
                    ),
                  );
                } else {
                  final TypeStyle typeStyle = ItemTypeStyle.getStyle(item.type);

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildItemDetailsWidget(item),
                        if (item.metadata?['description'] != null && item.metadata?['description'] != "") ...[
                          const SizedBox(height: 16),
                          buildDescriptionCard(item.metadata?['description'], colorPalette, textTheme, typeStyle),
                        ],
                        const SizedBox(height: 16),
                        buildPropertiesGrid(item, colorPalette, textTheme),
                      ],
                    ),
                  );
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildItemDetailsWidget(LibraryItem item) {
  switch (item.type) {
    case ItemType.folder:
      return const Center(child: Text('Folder Details'));
    case ItemType.note:
      return ViewNote(item: item);
    case ItemType.document:
      return ViewDocument(item: item);
    case ItemType.flashcard:
      return ViewFlashcard(item: item);
    case ItemType.audio:
      return ViewAudio(item: item);
    case ItemType.video:
      return ViewVideo(item: item);
    case ItemType.image:
      return ViewImage(item: item);
  }
}

Widget buildDescriptionCard(String description, ColorPalette colorPalette, TextTheme textTheme, TypeStyle typeStyle) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: typeStyle.color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: typeStyle.color.withValues(alpha: 0.2), width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(HugeIcons.strokeRoundedFile02, size: 16, color: typeStyle.color),
            const SizedBox(width: 6),
            Text('Description', style: textTheme.labelMedium),
          ],
        ),
        const SizedBox(height: 4),
        Text(description, style: textTheme.bodyMedium),
      ],
    ),
  );
}

Widget buildPropertiesGrid(LibraryItem item, ColorPalette colorPalette, TextTheme textTheme) {
  final metadata = item.metadata;
  final properties = <Map<String, dynamic>>[];

  properties.add({
    'icon': HugeIcons.strokeRoundedClock01,
    'label': 'Created',
    'value': DateFormat.yMMMd().add_Hm().format(item.createdAt),
  });
  properties.add({
    'icon': HugeIcons.strokeRoundedClock03,
    'label': 'Modified',
    'value': DateFormat.yMMMd().add_Hm().format(item.updatedAt),
  });

  switch (item.type) {
    case ItemType.folder:
      break;
    case ItemType.note:
      break;
    case ItemType.document:
      if (metadata?['fileType'] != null && metadata?['fileType'] != '') {
        properties.add({
          'icon': HugeIcons.strokeRoundedFileEmpty02,
          'label': 'Format',
          'value': metadata?['fileType'].toUpperCase(),
        });
      }
      if (metadata?['fileSize'] != null && metadata?['fileSize'] != '') {
        properties.add({
          'icon': HugeIcons.strokeRoundedDatabase01,
          'label': 'File Size',
          'value': '${bytesToMB(metadata?['fileSize'])} MB',
        });
      }
      break;

    case ItemType.flashcard:
      if (metadata?['cardCount'] != null && metadata?['cardCount'] != '') {
        properties.add({
          'icon': HugeIcons.strokeRoundedNote,
          'label': 'Cards',
          'value': '${metadata?['cardCount']} cards',
        });
      }
      break;

    case ItemType.audio:
    case ItemType.video:
      if (metadata?['duration'] != null && metadata?['duration'] != '') {
        properties.add({
          'icon': HugeIcons.strokeRoundedClock01,
          'label': 'Duration',
          'value': secToMin(metadata?['duration']),
        });
      }
      if (metadata?['fileSize'] != null && metadata?['fileSize'] != '') {
        properties.add({
          'icon': HugeIcons.strokeRoundedDatabase01,
          'label': 'File Size',
          'value': '${bytesToMB(metadata?['fileSize'])} MB',
        });
      }
      break;

    case ItemType.image:
      if (metadata?['resolution'] != null && metadata?['resolution'] != '') {
        properties.add({
          'icon': HugeIcons.strokeRoundedImage03,
          'label': 'Resolution',
          'value': metadata?['resolution'],
        });
      }
      if (metadata?['fileSize'] != null && metadata?['fileSize'] != '') {
        properties.add({
          'icon': HugeIcons.strokeRoundedDatabase01,
          'label': 'File Size',
          'value': '${bytesToMB(metadata?['fileSize'])} MB',
        });
      }
      break;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: colorPalette.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: colorPalette.border, width: 1),
    ),
    child: Column(
      children: [
        for (int i = 0; i < properties.length; i += 2) ...[
          Row(
            children: [
              Expanded(child: buildPropertyItem(properties[i], colorPalette, textTheme)),
              if (i + 1 < properties.length) ...[
                SizedBox(width: 16),
                Expanded(child: buildPropertyItem(properties[i + 1], colorPalette, textTheme)),
              ] else
                Expanded(child: SizedBox()),
            ],
          ),
          if (i + 2 < properties.length) SizedBox(height: 12),
        ],
      ],
    ),
  );
}

Widget buildPropertyItem(Map<String, dynamic> property, ColorPalette colorPalette, TextTheme textTheme) {
  final color = property['color'] as Color? ?? colorPalette.contentDim;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(property['icon'], color: color, size: 16),
          SizedBox(width: 6),
          Text(property['label'], style: textTheme.labelMedium),
        ],
      ),
      SizedBox(height: 4),
      Text(property['value'], style: textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
    ],
  );
}
