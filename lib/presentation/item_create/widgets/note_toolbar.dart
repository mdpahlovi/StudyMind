import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';

class NoteToolbar extends StatefulWidget {
  const NoteToolbar({super.key});

  @override
  State<NoteToolbar> createState() => NoteToolbarState();
}

class NoteToolbarState extends State<NoteToolbar> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;

    List<Widget> toolbarItems = [
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedTextBold,
        onPressed: () => toggleFormat('bold'),
        isSelected: isFormatSelected('bold'),
        colorPalette: colorPalette,
      ),
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedTextItalic,
        onPressed: () => toggleFormat('italic'),
        isSelected: isFormatSelected('italic'),
        colorPalette: colorPalette,
      ),
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedTextUnderline,
        onPressed: () => toggleFormat('underline'),
        isSelected: isFormatSelected('underline'),
        colorPalette: colorPalette,
      ),
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedTextStrikethrough,
        onPressed: () => toggleFormat('strikethrough'),
        isSelected: isFormatSelected('strikethrough'),
        colorPalette: colorPalette,
      ),
      const VerticalDivider(),
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedLeftToRightListBullet,
        onPressed: () => toggleList('bulleted_list'),
        isSelected: isBlockTypeSelected('bulleted_list'),
        colorPalette: colorPalette,
      ),
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedLeftToRightListNumber,
        onPressed: () => toggleList('numbered_list'),
        isSelected: isBlockTypeSelected('numbered_list'),
        colorPalette: colorPalette,
      ),
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedCheckList,
        onPressed: () => toggleList('todo_list'),
        isSelected: isBlockTypeSelected('todo_list'),
        colorPalette: colorPalette,
      ),
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedQuoteDown,
        onPressed: () => _toggleBlockFormat('quote'),
        isSelected: isBlockTypeSelected('quote'),
        colorPalette: colorPalette,
      ),
      const VerticalDivider(),
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedUndo03,
        onPressed: () => itemCreateController.noteEditorState.undoManager.undo(),
        colorPalette: colorPalette,
      ),
      buildToolbarButton(
        icon: HugeIcons.strokeRoundedRedo03,
        onPressed: () => itemCreateController.noteEditorState.undoManager.redo(),
        colorPalette: colorPalette,
      ),
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorPalette.surface,
        border: Border.symmetric(horizontal: BorderSide(color: colorPalette.border)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: toolbarItems.length,
        itemBuilder: (context, index) => toolbarItems[index],
        separatorBuilder: (context, index) => const SizedBox(width: 4),
      ),
    );
  }

  Widget buildToolbarButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ColorPalette colorPalette,
    bool isSelected = false,
  }) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        color: isSelected ? colorPalette.content.withAlpha(50) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colorPalette.border),
        ),
        child: InkWell(onTap: onPressed, child: Icon(icon, size: 20)),
      ),
    );
  }

  void toggleFormat(String attribute) {
    final selection = itemCreateController.noteEditorState.selection;
    if (selection == null) return;

    itemCreateController.noteEditorState.toggleAttribute(attribute);
  }

  void toggleList(String listType) {
    final selection = itemCreateController.noteEditorState.selection;
    if (selection == null) return;

    final node = itemCreateController.noteEditorState.getNodeAtPath(selection.start.path);
    if (node == null) return;

    final transaction = itemCreateController.noteEditorState.transaction;

    if (node.type == listType) {
      transaction.updateNode(node, {'type': 'paragraph'});
    } else {
      transaction.updateNode(node, {'type': listType});
    }

    itemCreateController.noteEditorState.apply(transaction);
  }

  void _toggleBlockFormat(String blockType) {
    final selection = itemCreateController.noteEditorState.selection;
    if (selection == null) return;

    final node = itemCreateController.noteEditorState.getNodeAtPath(selection.start.path);
    if (node == null) return;

    final transaction = itemCreateController.noteEditorState.transaction;

    if (node.type == blockType) {
      transaction.updateNode(node, {'type': 'paragraph'});
    } else {
      transaction.updateNode(node, {'type': blockType});
    }

    itemCreateController.noteEditorState.apply(transaction);
  }

  bool isFormatSelected(String attribute) {
    final selection = itemCreateController.noteEditorState.selection;
    if (selection == null) return false;

    final nodes = itemCreateController.noteEditorState.getNodesInSelection(selection);
    if (nodes.isEmpty) return false;

    // Check if any selected node has the attribute
    for (final node in nodes) {
      if (node.delta != null) {
        final delta = node.delta!;
        // Check if delta has the attribute
        final text = delta.toPlainText();
        if (text.isNotEmpty) {
          // Simple check - you might need to adjust based on your needs
          return itemCreateController.noteEditorState.getDeltaAttributeValueInSelection(attribute, selection) == true;
        }
      }
    }
    return false;
  }

  bool isBlockTypeSelected(String blockType) {
    final selection = itemCreateController.noteEditorState.selection;
    if (selection == null) return false;

    final node = itemCreateController.noteEditorState.getNodeAtPath(selection.start.path);
    return node?.type == blockType;
  }
}
